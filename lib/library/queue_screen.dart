import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import 'shared/library_options_menu.dart';
import 'shared/song_list_item.dart';
import 'shared/alphabet_index.dart';
import 'shared/selection_bar.dart';
import '../bottom_bar/search_screen.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});
  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  bool _selectionMode = false;
  final Set<int> _selected = {};

  void _exitSelection() => setState(() { _selectionMode = false; _selected.clear(); });
  void _toggleSelect(int i) => setState(() =>
    _selected.contains(i) ? _selected.remove(i) : _selected.add(i));
  void _selectAll(int total) => setState(() =>
    _selected.length == total ? _selected.clear() : _selected.addAll(List.generate(total, (i) => i)));

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PlayerProvider>();
    final songs = p.songs;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFF1C1C1C),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Row(children: [
                      Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('Biblioteca', style: TextStyle(color: Colors.white, fontSize: 13)),
                    ]),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(children: [
                Container(
                  width: 42, height: 42,
                  decoration: const BoxDecoration(color: Color(0xFFB45309), shape: BoxShape.circle),
                  child: const Icon(Icons.fast_forward_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Cola', style: TextStyle(color: Colors.white,
                      fontSize: 20, fontWeight: FontWeight.w700)),
                  Text('${songs.length} canciones',
                      style: const TextStyle(color: Color(0xFF555555), fontSize: 12)),
                ]),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(children: [
                _Chip(icon: Icons.shuffle_rounded, onTap: () {}),
                const SizedBox(width: 8),
                _Chip(icon: Icons.play_arrow_rounded, onTap: () {
                  if (songs.isNotEmpty) p.playSong(0);
                }),
                const SizedBox(width: 8),
                _Chip(icon: Icons.search_rounded, onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SearchScreen(initialFilter: 'Cola')))),
                const SizedBox(width: 8),
                _ChipLabel(label: 'Seleccionar',
                    onTap: () => setState(() => _selectionMode = true)),
                const Spacer(),
                GestureDetector(
                  onTap: () => LibraryOptionsMenu.show(context,
                      title: 'Cola', icon: Icons.fast_forward_rounded, iconBgColor: const Color(0xFFB45309),
                      onSelectFolders: () => p.selectFolder()),
                  child: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF2A2A2A))),
                    child: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 20)),
                ),
              ]),
            ),
            songs.isEmpty
              ? const Expanded(child: Center(
                  child: Text('Sin contenido', style: TextStyle(color: Color(0xFF555555)))))
              : Expanded(
                  child: Stack(children: [
                    ListView.builder(
                      padding: const EdgeInsets.only(right: 20, bottom: 8),
                      itemCount: songs.length,
                      itemBuilder: (_, i) => SongListItem(
                        title: songs[i].title,
                        artist: songs[i].artist,
                        duration: songs[i].duration,
                        format: songs[i].format,
                        isSelected: _selected.contains(i),
                        selectionMode: _selectionMode,
                        isPlaying: p.currentIndex == i && p.isPlaying,
                        onTap: () => _selectionMode ? _toggleSelect(i) : p.playSong(i),
                        onLongPress: () => setState(() { _selectionMode = true; _selected.add(i); }),
                      ),
                    ),
                    Positioned(right: 0, top: 0, bottom: 0,
                        child: Center(child: AlphabetIndex(onLetterTap: (_) {}))),
                  ]),
                ),
            if (_selectionMode)
              SelectionBar(
                selectedCount: _selected.length, totalCount: songs.length,
                allSelected: _selected.length == songs.length,
                onSelectAll: () => _selectAll(songs.length),
                onClose: _exitSelection,
                onAddToPlaylist: () {}, onAddToQueue: () {}, onPlayNext: () {},
                onDelete: () {}, onShare: () {}, onInfo: () {}, onArtwork: () {},
              ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _Chip({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(width: 40, height: 40,
      decoration: BoxDecoration(color: const Color(0xFF1C1C1C),
          shape: BoxShape.circle, border: Border.all(color: const Color(0xFF2A2A2A))),
      child: Icon(icon, color: Colors.white, size: 20)));
}

class _ChipLabel extends StatelessWidget {
  final String label; final VoidCallback onTap;
  const _ChipLabel({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2A2A2A))),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13))));
}
