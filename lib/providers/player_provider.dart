import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'song_model.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _audio = AudioPlayer();
  static const _channel = MethodChannel('powerflux/folder_picker');

  List<Song> _songs = [];
  int _currentIndex = -1;
  bool _isPlaying = false;
  bool _isShuffle = false;
  bool _isRepeat = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String _musicFolder = '/storage/emulated/0/Music';

  List<Song> get songs => _songs;
  int get currentIndex => _currentIndex;
  Song? get currentSong =>
      _currentIndex >= 0 && _currentIndex < _songs.length
          ? _songs[_currentIndex]
          : null;
  bool get isPlaying => _isPlaying;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;
  Duration get position => _position;
  Duration get duration => _duration;
  String get musicFolder => _musicFolder;
  double get progress => _duration.inMilliseconds > 0
      ? _position.inMilliseconds / _duration.inMilliseconds
      : 0.0;

  String formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  PlayerProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _musicFolder =
        prefs.getString('music_folder') ?? '/storage/emulated/0/Music';

    _audio.onPositionChanged.listen((pos) {
      _position = pos;
      notifyListeners();
    });
    _audio.onDurationChanged.listen((dur) {
      _duration = dur;
      notifyListeners();
    });
    _audio.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });
    _audio.onPlayerComplete.listen((_) => _onComplete());

    await loadSongsFromFolder(_musicFolder);
  }

  Future<bool> _requestPermission() async {
    // Android 13+
    if (await Permission.audio.isGranted) return true;
    final a = await Permission.audio.request();
    if (a.isGranted) return true;
    // Android < 13
    if (await Permission.storage.isGranted) return true;
    final s = await Permission.storage.request();
    return s.isGranted;
  }

  Future<void> loadSongsFromFolder(String folderPath) async {
    final granted = await _requestPermission();
    if (!granted) return;

    final dir = Directory(folderPath);
    if (!await dir.exists()) return;

    const supported = ['mp3', 'aac', 'm4a', 'wav', 'flac', 'ogg', 'opus'];
    final files = <Song>[];

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        final ext = entity.path.split('.').last.toLowerCase();
        if (supported.contains(ext)) {
          files.add(Song.fromFile(entity.path));
        }
      }
    }

    files.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    _songs = files;
    _musicFolder = folderPath;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('music_folder', folderPath);

    notifyListeners();
  }

  /// Muestra un diálogo simple para que el usuario escriba/elija la ruta
  Future<void> selectFolder([BuildContext? context]) async {
    if (context == null) return;
    final controller = TextEditingController(text: _musicFolder);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Seleccionar carpeta',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: '/storage/emulated/0/Music',
            hintStyle: TextStyle(color: Color(0xFF555555)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF555555))),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
        ),
        actions: [
          // Rutas comunes predefinidas
          _FolderOption(
              label: 'Music',
              path: '/storage/emulated/0/Music',
              onTap: () => Navigator.pop(context, '/storage/emulated/0/Music')),
          _FolderOption(
              label: 'Downloads',
              path: '/storage/emulated/0/Download',
              onTap: () =>
                  Navigator.pop(context, '/storage/emulated/0/Download')),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Usar esta ruta',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await loadSongsFromFolder(result);
    }
  }

  Future<void> playSong(int index) async {
    if (index < 0 || index >= _songs.length) return;
    _currentIndex = index;
    await _audio.stop();
    await _audio.play(DeviceFileSource(_songs[index].path));
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> togglePlay() async {
    if (_isPlaying) {
      await _audio.pause();
    } else {
      if (_currentIndex < 0 && _songs.isNotEmpty) {
        await playSong(0);
        return;
      }
      await _audio.resume();
    }
  }

  Future<void> next() async {
    if (_songs.isEmpty) return;
    int next;
    if (_isShuffle) {
      next = DateTime.now().millisecondsSinceEpoch % _songs.length;
    } else {
      next = (_currentIndex + 1) % _songs.length;
    }
    await playSong(next);
  }

  Future<void> previous() async {
    if (_songs.isEmpty) return;
    if (_position.inSeconds > 3) {
      await _audio.seek(Duration.zero);
      return;
    }
    final prev = (_currentIndex - 1 + _songs.length) % _songs.length;
    await playSong(prev);
  }

  Future<void> seekTo(double value) async {
    final ms = (value * _duration.inMilliseconds).round();
    await _audio.seek(Duration(milliseconds: ms));
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    _audio.setReleaseMode(
        _isRepeat ? ReleaseMode.loop : ReleaseMode.release);
    notifyListeners();
  }

  void _onComplete() {
    if (_isRepeat) {
      playSong(_currentIndex);
    } else {
      next();
    }
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }
}

class _FolderOption extends StatelessWidget {
  final String label;
  final String path;
  final VoidCallback onTap;
  const _FolderOption(
      {required this.label, required this.path, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.folder_rounded,
          color: Color(0xFF888888), size: 18),
      label: Text(label,
          style: const TextStyle(color: Color(0xFF888888), fontSize: 13)),
    );
  }
}
