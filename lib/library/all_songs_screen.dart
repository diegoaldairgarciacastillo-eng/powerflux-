import 'package:flutter/material.dart';
import 'shared/library_options_menu.dart';
import 'shared/song_list_item.dart';
import 'shared/alphabet_index.dart';
import 'shared/selection_bar.dart';

class AllSongsScreen extends StatefulWidget {
  const AllSongsScreen({super.key});

  @override
  State<AllSongsScreen> createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  bool _selectionMode = false;
  final Set<int> _selected = {};
  int _playingIndex = 0;

  final List<Map<String, String>> _songs = List.generate(
    20,
    (i) => {
      'title': i == 0
          ? '* (Introduccion)'
          : i == 1
              ? '* (Introduccion)'
              : i == 2
                  ? '** (Repeticion)'
                  : i == 3
                      ? '** (Repeticion)'
                      : i == 4
                          ? '*** (Selah)'
                          : '**** (Selah)',
      'artist': i < 2
          ? 'Hillsong en Español/Hillsong UNITED - Unidos ...'
          : 'Hillsong En Español/ Hillsong UNITED - Unidos ...',
      'duration': i < 2 ? '1:32' : i < 4 ? '2:53' : i == 4 ? '1:43' : '3:40',
      'format': 'mp3',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Botón volver a Biblioteca
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_upward,
                            color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('Biblioteca',
                            style: TextStyle(
                                color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Header: ícono + título
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: Color(0xFF5B6EAE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.music_note,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Todas las canciones',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Barra de acciones
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  _ActionBtn(
                    icon: Icons.shuffle,
                    onTap: () {},
                  ),
                  const SizedBox(width: 6),
                  _ActionBtn(
                    icon: Icons.play_arrow,
                    onTap: () {},
                  ),
                  const SizedBox(width: 6),
                  _ActionBtn(
                    icon: Icons.search,
                    onTap: () {},
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _selectionMode = !_selectionMode),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectionMode
                            ? const Color(0xFF3A3A3A)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF444444)),
                      ),
                      child: const Text('Seleccionar',
                          style: TextStyle(
                              color: Colors.white, fontSize: 13)),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => LibraryOptionsMenu.show(
                      context,
                      title: 'Todas las canciones',
                      icon: Icons.music_note,
                    ),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF444444)),
                      ),
                      child: const Icon(Icons.more_vert,
                          color: Color(0xFFAAAAAA), size: 18),
                    ),
                  ),
                ],
              ),
            ),
            // Lista + índice alfabético
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: _songs.length,
                    padding: const EdgeInsets.only(right: 24),
                    itemBuilder: (_, i) => SongListItem(
                      title: _songs[i]['title']!,
                      artist: _songs[i]['artist']!,
                      duration: _songs[i]['duration']!,
                      format: _songs[i]['format']!,
                      isPlaying: i == _playingIndex,
                      isSelected: _selected.contains(i),
                      selectionMode: _selectionMode,
                      onTap: () {
                        if (_selectionMode) {
                          setState(() {
                            if (_selected.contains(i)) {
                              _selected.remove(i);
                            } else {
                              _selected.add(i);
                            }
                          });
                        } else {
                          setState(() => _playingIndex = i);
                        }
                      },
                      onLongPress: () =>
                          setState(() => _selectionMode = true),
                    ),
                  ),
                  // Índice alfabético
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: AlphabetIndex(onLetterTap: (_) {}),
                  ),
                ],
              ),
            ),
            // Barra de selección (cuando está activa)
            if (_selectionMode)
              SelectionBar(
                selectedCount: _selected.length,
                totalCount: _songs.length,
                allSelected: _selected.length == _songs.length,
                onSelectAll: () => setState(() {
                  if (_selected.length == _songs.length) {
                    _selected.clear();
                  } else {
                    _selected.addAll(
                        List.generate(_songs.length, (i) => i));
                  }
                }),
                onClose: () => setState(() {
                  _selectionMode = false;
                  _selected.clear();
                }),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF444444)),
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
