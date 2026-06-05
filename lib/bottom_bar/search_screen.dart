import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  int _selectedChip = 0;
  bool _isSearching = false;

  final List<String> _chips = [
    'Todo',
    'Álbumes',
    'Artistas',
    'Géneros',
    'Compositores',
    'Listas',
  ];

  final List<String> _history = [
    'Hillsong',
    'The Walters',
    'I Love You So',
    'Unidos',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1C),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          const Icon(
                            Icons.search,
                            color: Color(0xFF666666),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              autofocus: false,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Buscar canciones...',
                                hintStyle: TextStyle(color: Color(0xFF555555)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (v) =>
                                  setState(() => _isSearching = v.isNotEmpty),
                            ),
                          ),
                          if (_isSearching)
                            GestureDetector(
                              onTap: () {
                                _controller.clear();
                                setState(() => _isSearching = false);
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.close,
                                  color: Color(0xFF666666),
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Chips de categorías
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _chips.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final active = _selectedChip == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedChip = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: active ? Colors.white : const Color(0xFF1C1C1C),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        _chips[i],
                        style: TextStyle(
                          color: active
                              ? Colors.black
                              : const Color(0xFFAAAAAA),
                          fontSize: 13,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Historial o resultados
            if (!_isSearching) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Búsquedas recientes',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (_, i) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    leading: const Icon(
                      Icons.history,
                      color: Color(0xFF555555),
                      size: 20,
                    ),
                    title: Text(
                      _history[i],
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: GestureDetector(
                      onTap: () => setState(() => _history.removeAt(i)),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFF555555),
                        size: 16,
                      ),
                    ),
                    onTap: () {
                      _controller.text = _history[i];
                      setState(() => _isSearching = true);
                    },
                  ),
                ),
              ),
            ] else ...[
              const Expanded(
                child: Center(
                  child: Text(
                    'Sin resultados',
                    style: TextStyle(color: Color(0xFF555555)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
