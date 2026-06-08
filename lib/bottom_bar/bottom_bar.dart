import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../library/library_screen.dart';
import 'equalizer_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'player_screen.dart';

class BottomBarShell extends StatefulWidget {
  const BottomBarShell({super.key});
  @override
  State<BottomBarShell> createState() => _BottomBarShellState();
}

class _BottomBarShellState extends State<BottomBarShell> {
  int _index = 0;

  static const _screens = [
    LibraryScreen(),
    EqualizerScreen(),
    SearchScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _screens[_index],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MiniPlayer(onTap: () => Navigator.push(context,
            MaterialPageRoute(fullscreenDialog: true, builder: (_) => const PlayerScreen()))),
          _NavBar(index: _index, onTap: (i) => setState(() => _index = i)),
        ],
      ),
    );
  }
}

// ── Mini Player ──────────────────────────────────────────────────────────────
class _MiniPlayer extends StatelessWidget {
  final VoidCallback onTap;
  const _MiniPlayer({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PlayerProvider>();
    final song = p.currentSong;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C1C),
          border: Border(top: BorderSide(color: Color(0xFF2A2A2A), width: 0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
              child: Row(
                children: [
                  // Album art
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      width: 48, height: 48,
                      color: const Color(0xFF2A2A2A),
                      child: const Icon(Icons.music_note_rounded,
                          color: Color(0xFF555555), size: 24),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song?.title ?? 'Sin reproducción',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white,
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          song?.artist ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color(0xFF888888), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => p.togglePlay(),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 42, height: 42,
                      decoration: const BoxDecoration(
                          color: Color(0xFF2A2A2A), shape: BoxShape.circle),
                      child: Icon(
                        p.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ),
            // Progress bar
            LinearProgressIndicator(
              value: p.progress,
              minHeight: 2,
              backgroundColor: const Color(0xFF2A2A2A),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF888888)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Nav Bar ──────────────────────────────────────────────────────────────────
class _NavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const _NavBar({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const items = [
      Icons.grid_view_rounded,
      Icons.equalizer_rounded,
      Icons.search_rounded,
      Icons.menu_rounded,
    ];
    return Container(
      color: Colors.black,
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (i) {
            final sel = index == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Icon(items[i],
                    size: 28,
                    color: sel ? Colors.white : const Color(0xFF555555)),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
