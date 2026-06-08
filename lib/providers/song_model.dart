class Song {
  final String path;
  final String title;
  final String artist;
  final String album;
  final String duration;
  final int durationMs;
  final String format;

  Song({
    required this.path,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.durationMs,
    required this.format,
  });

  factory Song.fromFile(String filePath) {
    final name = filePath.split('/').last;
    final ext = name.contains('.') ? name.split('.').last.toLowerCase() : 'mp3';
    final title = name.contains('.')
        ? name.substring(0, name.lastIndexOf('.'))
        : name;
    return Song(
      path: filePath,
      title: title,
      artist: 'Artista desconocido',
      album: 'Álbum desconocido',
      duration: '0:00',
      durationMs: 0,
      format: ext,
    );
  }

  Song copyWith({String? duration, int? durationMs, String? artist, String? album}) {
    return Song(
      path: path,
      title: title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      duration: duration ?? this.duration,
      durationMs: durationMs ?? this.durationMs,
      format: format,
    );
  }
}
