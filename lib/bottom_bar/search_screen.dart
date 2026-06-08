import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../library/shared/song_list_item.dart';

class SearchScreen extends StatefulWidget {
  final String? initialFilter;
  const SearchScreen({super.key, this.initialFilter});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  List<String> _history = ['toda', 'toe2', 'el fue', 'eñ', 'fogo'];
  String _query = '';
  String _activeCategory = 'Todo';

  static const _categories = ['Todo', 'Álbumes', 'Artistas', 'Artistas del álbum',
    'Carpetas', 'Géneros', 'Compositores', 'Años'];

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PlayerProvider>();
    final results = _query.isNotEmpty
        ? p.songs.where((s) =>
            s.title.toLowerCase().contains(_query.toLowerCase()) ||
            s.artist.toLowerCase().contains(_query.toLowerCase())).toList()
        : <dynamic>[];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    const Icon(Icons.search_rounded, color: Color(0xFF888888), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        focusNode: _focus,
                        autofocus: false,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: const InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: (v) => setState(() => _query = v),
                      ),
                    ),
                    if (_ctrl.text.isNotEmpty)
                      GestureDetector(
                        onTap: () { _ctrl.clear(); setState(() => _query = ''); },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(Icons.close_rounded, color: Color(0xFF888888), size: 18)),
                      ),
                  ],
                ),
              ),
            ),

            // Category chips
            if (_query.isNotEmpty) ...[
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _categories.length,
                  itemBuilder: (_, i) {
                    final sel = _activeCategory == _categories[i];
                    return GestureDetector(
                      onTap: () => setState(() => _activeCategory = _categories[i]),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: sel ? const Color(0xFF3A3A3A) : const Color(0xFF1C1C1C),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: sel ? Colors.white : const Color(0xFF2A2A2A)),
                        ),
                        child: Text(_categories[i],
                            style: TextStyle(
                                color: sel ? Colors.white : const Color(0xFF888888),
                                fontSize: 12)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
              // Action row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(children: [
                  _ActionBtn(icon: Icons.shuffle_rounded, onTap: () {}),
                  const SizedBox(width: 8),
                  _ActionBtn(icon: Icons.play_arrow_rounded, onTap: () {}),
                  const SizedBox(width: 8),
                  _ActionBtn(label: 'Seleccionar', onTap: () {}),
                  const Spacer(),
                  _ActionBtn(icon: Icons.more_vert_rounded, onTap: () {}),
                ]),
              ),
              // Results
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (_, i) => SongListItem(
                    title: results[i].title,
                    artist: results[i].artist,
                    duration: results[i].duration,
                    format: results[i].format,
                    onTap: () {
                      final idx = p.songs.indexOf(results[i]);
                      if (idx >= 0) p.playSong(idx);
                    },
                  ),
                ),
              ),
            ] else ...[
              // History
              Expanded(
                child: Column(
                  children: [
                    ..._history.map((h) => ListTile(
                      dense: true,
                      title: Text(h, style: const TextStyle(color: Colors.white, fontSize: 15)),
                      trailing: GestureDetector(
                        onTap: () => setState(() => _history.remove(h)),
                        child: const Icon(Icons.close_rounded, color: Color(0xFF555555), size: 18)),
                    )),
                    if (_history.isNotEmpty)
                      TextButton(
                        onPressed: () => setState(() => _history.clear()),
                        child: const Text('Limpiar historial de búsqueda',
                            style: TextStyle(color: Color(0xFF555555), fontSize: 13)),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData? icon; final String? label; final VoidCallback onTap;
  const _ActionBtn({this.icon, this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: label != null
          ? const EdgeInsets.symmetric(horizontal: 14, vertical: 9)
          : const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C), shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF2A2A2A))),
      child: label != null
          ? Text(label!, style: const TextStyle(color: Colors.white, fontSize: 13))
          : Icon(icon!, color: Colors.white, size: 20)),
  );
}
