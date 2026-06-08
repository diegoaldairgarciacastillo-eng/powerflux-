import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PlayerProvider>();
    final song = p.currentSong;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // ── Waveform artwork area ────────────────────────────────────
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  // Waveform background shape
                  Positioned.fill(
                    child: CustomPaint(painter: _WaveformPainter()),
                  ),
                  // Rating + menu row
                  Positioned(
                    bottom: 16, left: 16, right: 16,
                    child: Row(
                      children: [
                        _RoundBtn(icon: Icons.thumb_up_outlined, onTap: () {}),
                        const SizedBox(width: 8),
                        _RoundBtn(icon: Icons.thumb_down_outlined, onTap: () {}),
                        const Spacer(),
                        _RoundBtn(
                          icon: Icons.more_vert_rounded,
                          onTap: () => _showSongMenu(context, p),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Song info ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      song?.title ?? 'Sin reproducción',
                      style: const TextStyle(color: Colors.white,
                          fontSize: 16, fontWeight: FontWeight.w700),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      song?.artist ?? '',
                      style: const TextStyle(color: Colors.white,
                          fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            // ── Secondary controls ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _RoundBtn(icon: Icons.graphic_eq_rounded, onTap: () {}),
                  const SizedBox(width: 8),
                  _RoundBtn(icon: Icons.timer_outlined, onTap: () {}),
                  const Spacer(),
                  _RoundBtn(
                    icon: Icons.repeat_rounded,
                    onTap: p.toggleRepeat,
                    active: p.isRepeat,
                  ),
                  const SizedBox(width: 8),
                  _RoundBtn(
                    icon: Icons.shuffle_rounded,
                    onTap: p.toggleShuffle,
                    active: p.isShuffle,
                  ),
                ],
              ),
            ),

            // ── Waveform seek + controls ─────────────────────────────────
            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Waveform visualizer as seek bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: GestureDetector(
                      onHorizontalDragUpdate: (d) {
                        final box = context.findRenderObject() as RenderBox;
                        final dx = d.localPosition.dx / box.size.width;
                        p.seekTo(dx.clamp(0.0, 1.0));
                      },
                      child: CustomPaint(
                        painter: _SeekWaveformPainter(progress: p.progress),
                        size: Size(MediaQuery.of(context).size.width, 120),
                      ),
                    ),
                  ),
                  // Transport controls
                  Positioned(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _TransportBtn(icon: Icons.fast_rewind_rounded, size: 32, onTap: () {}),
                        const SizedBox(width: 8),
                        _TransportBtn(icon: Icons.skip_previous_rounded, size: 40, onTap: p.previous),
                        const SizedBox(width: 8),
                        // Big play button
                        GestureDetector(
                          onTap: () => p.togglePlay(),
                          child: Container(
                            width: 72, height: 72,
                            decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                            child: Icon(
                              p.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: Colors.black, size: 40),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _TransportBtn(icon: Icons.skip_next_rounded, size: 40, onTap: p.next),
                        const SizedBox(width: 8),
                        _TransportBtn(icon: Icons.fast_forward_rounded, size: 32, onTap: () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Time row ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TimeChip(p.formatDuration(p.position)),
                  _TimeChip(p.formatDuration(p.duration)),
                ],
              ),
            ),

            // ── Output info ──────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.headphones_rounded, color: Color(0xFF555555), size: 14),
                  SizedBox(width: 4),
                  Text('OPENSL ES OUTPUT  24 BIT  48 KHZ',
                    style: TextStyle(color: Color(0xFF555555), fontSize: 10,
                        letterSpacing: 1)),
                ],
              ),
            ),

            // ── Bottom nav (same as shell) ───────────────────────────────
            Container(
              color: Colors.black,
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    _NavBtn(icon: Icons.grid_view_rounded, onTap: () => Navigator.pop(context)),
                    _NavBtn(icon: Icons.equalizer_rounded, onTap: () {}),
                    _NavBtn(icon: Icons.search_rounded, onTap: () {}),
                    _NavBtn(icon: Icons.menu_rounded, onTap: () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSongMenu(BuildContext context, PlayerProvider p) {
    final song = p.currentSong;
    if (song == null) return;
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(song.title, style: const TextStyle(color: Colors.white,
                  fontSize: 15, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
              Text(song.artist, style: const TextStyle(
                  color: Color(0xFF888888), fontSize: 12)),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.music_note_rounded, color: Color(0xFF666666), size: 12),
                const SizedBox(width: 4),
                Text('${song.duration} | ${song.format}',
                    style: const TextStyle(color: Color(0xFF666666), fontSize: 12)),
              ]),
              const SizedBox(height: 4),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _RoundBtn(icon: Icons.thumb_up_outlined, onTap: () {}),
                const SizedBox(width: 8),
                _RoundBtn(icon: Icons.thumb_down_outlined, onTap: () {}),
              ]),
              const Divider(color: Color(0xFF3A3A3A)),
              _MenuRow(children: [
                _MenuBtn(icon: Icons.delete_outline_rounded, label: 'Eliminar', onTap: () => Navigator.pop(context)),
              ]),
              _MenuRow(children: [
                _MenuBtn(icon: Icons.add_rounded, label: 'Lista de reprod', onTap: () => Navigator.pop(context)),
                _MenuBtn(icon: Icons.bookmark_border_rounded, label: 'Favorito', onTap: () => Navigator.pop(context)),
              ]),
              _MenuRow(children: [
                _MenuBtn(icon: Icons.image_outlined, label: 'Carátula', onTap: () => Navigator.pop(context)),
              ]),
              _MenuRow(children: [
                _MenuBtn(icon: Icons.info_outline_rounded, label: 'Info./Etiq.', onTap: () => Navigator.pop(context)),
                _MenuBtn(icon: Icons.lyrics_outlined, label: 'Letra', onTap: () => Navigator.pop(context)),
              ]),
              _MenuRow(children: [
                _MenuBtn(icon: Icons.mic_rounded, label: 'Artista', onTap: () => Navigator.pop(context)),
                _MenuBtn(icon: Icons.album_rounded, label: 'Álbum', onTap: () => Navigator.pop(context)),
              ]),
              _MenuRow(children: [
                _MenuBtn(icon: Icons.folder_outlined, label: 'Carpeta', onTap: () => Navigator.pop(context)),
                _MenuBtn(icon: Icons.library_music_rounded, label: 'Género', onTap: () => Navigator.pop(context)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final List<Widget> children;
  const _MenuRow({required this.children});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: children.map((c) => Expanded(child: c)).toList()),
  );
}

class _MenuBtn extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _MenuBtn({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ]),
    ),
  );
}

class _RoundBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap; final bool active;
  const _RoundBtn({required this.icon, required this.onTap, this.active = false});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF3A3A3A) : const Color(0xFF1C1C1C),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF2A2A2A))),
      child: Icon(icon, color: active ? Colors.white : const Color(0xFF888888), size: 20)),
  );
}

class _TransportBtn extends StatelessWidget {
  final IconData icon; final double size; final VoidCallback onTap;
  const _TransportBtn({required this.icon, required this.size, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: size + 16, height: size + 16,
      decoration: const BoxDecoration(color: Color(0xFF1C1C1C), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: size)),
  );
}

class _TimeChip extends StatelessWidget {
  final String text;
  const _TimeChip(this.text);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(12)),
    child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
  );
}

class _NavBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Icon(icon, color: const Color(0xFF555555), size: 28)),
    ),
  );
}

// ── Painters ─────────────────────────────────────────────────────────────────
class _WaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1A1A1A)..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, size.height);
    final points = [0.0, 0.6, 0.3, 0.8, 0.15, 0.7, 0.4, 0.5, 0.25, 0.9, 0.5, 0.4, 0.35, 0.75, 0.6, 0.3, 0.45, 0.65, 0.75, 0.2, 0.55, 0.5, 0.85, 0.1, 0.7, 0.45, 1.0, 0.8];
    for (int i = 0; i < points.length; i += 2) {
      path.lineTo(points[i] * size.width, points[i + 1] * size.height);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(_) => false;
}

class _SeekWaveformPainter extends CustomPainter {
  final double progress;
  const _SeekWaveformPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final barW = 3.0;
    final gap = 2.0;
    final count = (size.width / (barW + gap)).floor();
    final playedPaint = Paint()..color = const Color(0xFF888888);
    final unplayedPaint = Paint()..color = const Color(0xFF333333);

    for (int i = 0; i < count; i++) {
      final x = i * (barW + gap);
      final h = 20 + rng.nextDouble() * (size.height - 40);
      final y = (size.height - h) / 2;
      final played = (i / count) <= progress;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, barW, h), const Radius.circular(1.5)),
        played ? playedPaint : unplayedPaint,
      );
    }
  }
  @override
  bool shouldRepaint(_SeekWaveformPainter old) => old.progress != progress;
}
