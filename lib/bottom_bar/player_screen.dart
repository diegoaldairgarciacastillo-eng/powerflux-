import 'package:flutter/material.dart';
import 'dart:math' as math;

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  bool _isPlaying = false;
  bool _isLiked = false;
  bool _isDisliked = false;
  double _progress = 0.02;
  bool _isShuffle = false;
  bool _isRepeat = false;

  late AnimationController _waveController;

  final List<double> _barHeights = [
    0.3, 0.5, 0.7, 0.9, 1.0, 0.8, 0.6, 0.4, 0.5, 0.7,
    0.9, 0.6, 0.4, 0.8, 1.0, 0.7, 0.5, 0.3, 0.6, 0.9,
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A18),
      body: SafeArea(
        child: Column(
          children: [
            // Portada del álbum
            _buildAlbumArt(),
            // Título, artista, controles superiores
            _buildSongInfo(),
            // Botones de control secundarios
            _buildSecondaryControls(),
            const Spacer(),
            // Botones principales + visualizador
            _buildMainControls(),
            // Tiempo
            _buildTimeRow(),
            // Info de output
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                '🔊  OPENSL ES OUTPUT  24 BIT  48 KHZ',
                style: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumArt() {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Stack(
          children: [
            // Portada principal
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFE8E4D0),
              ),
              child: const Center(
                child: Icon(Icons.music_note,
                    size: 80, color: Color(0xFF888880)),
              ),
            ),
            // Botón like
            Positioned(
              left: 12,
              bottom: 12,
              child: _RoundButton(
                onTap: () => setState(() => _isLiked = !_isLiked),
                child: Icon(
                  Icons.thumb_up,
                  color: _isLiked ? Colors.white : const Color(0xFFAAAAAA),
                  size: 20,
                ),
              ),
            ),
            // Botón dislike
            Positioned(
              left: 60,
              bottom: 12,
              child: _RoundButton(
                onTap: () => setState(() => _isDisliked = !_isDisliked),
                child: Icon(
                  Icons.thumb_down,
                  color: _isDisliked ? Colors.white : const Color(0xFFAAAAAA),
                  size: 20,
                ),
              ),
            ),
            // Botón 3 puntos
            Positioned(
              right: 12,
              bottom: 12,
              child: _RoundButton(
                onTap: () => _showOptionsMenu(context),
                child: const Icon(Icons.more_vert,
                    color: Color(0xFFAAAAAA), size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'I Love You So',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'The Walters - I Love You So',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          // Visualizador de barras (pequeño)
          _RoundButton(
            onTap: () {},
            child: const Icon(Icons.equalizer,
                color: Color(0xFFAAAAAA), size: 20),
          ),
          const SizedBox(width: 8),
          // Temporizador
          _RoundButton(
            onTap: () {},
            child: const Icon(Icons.timer, color: Color(0xFFAAAAAA), size: 20),
          ),
          const Spacer(),
          // Repeat
          _RoundButton(
            onTap: () => setState(() => _isRepeat = !_isRepeat),
            child: Icon(
              Icons.repeat,
              color: _isRepeat ? Colors.white : const Color(0xFFAAAAAA),
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          // Shuffle
          _RoundButton(
            onTap: () => setState(() => _isShuffle = !_isShuffle),
            child: Icon(
              Icons.shuffle,
              color: _isShuffle ? Colors.white : const Color(0xFFAAAAAA),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Retroceso rápido (doble)
          _BigButton(
            size: 50,
            onTap: () {},
            child: const Icon(Icons.fast_rewind,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 8),
          // Retroceso
          _BigButton(
            size: 56,
            onTap: () {},
            child: const Icon(Icons.skip_previous,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 8),
          // Play/Pause (más grande)
          _BigButton(
            size: 70,
            onTap: () => setState(() => _isPlaying = !_isPlaying),
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: 8),
          // Adelante
          _BigButton(
            size: 56,
            onTap: () {},
            child: const Icon(Icons.skip_next,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 8),
          // Adelanto rápido (doble)
          _BigButton(
            size: 50,
            onTap: () {},
            child: const Icon(Icons.fast_forward,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          // Visualizador de barras animado
          _buildBarVisualizer(),
        ],
      ),
    );
  }

  Widget _buildBarVisualizer() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, _) {
        return SizedBox(
          width: 60,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(8, (i) {
              final base = _barHeights[i % _barHeights.length];
              final animated = _isPlaying
                  ? base *
                      (0.4 +
                          0.6 *
                              math
                                  .sin(_waveController.value * math.pi +
                                      i * 0.5)
                                  .abs())
                  : base * 0.3;
              return Container(
                width: 5,
                height: 70 * animated,
                decoration: BoxDecoration(
                  color: const Color(0xFF888888),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildTimeRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 0),
              overlayShape:
                  const RoundSliderOverlayShape(overlayRadius: 0),
              activeTrackColor: Colors.white,
              inactiveTrackColor: const Color(0xFF444444),
            ),
            child: Slider(
              value: _progress,
              onChanged: (v) => setState(() => _progress = v),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '0:02',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '2:40',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'I Love You So',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _OptionItem(icon: Icons.star_outline, label: 'Calificar'),
              _OptionItem(
                  icon: Icons.playlist_add, label: 'Añadir a lista'),
              _OptionItem(icon: Icons.queue_music, label: 'Añadir a cola'),
              _OptionItem(icon: Icons.info_outline, label: 'Info/Etiquetas'),
              _OptionItem(icon: Icons.image_outlined, label: 'Carátula'),
              _OptionItem(icon: Icons.share_outlined, label: 'Compartir'),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Botón redondo pequeño ───────────────────────────────────────────────────

class _RoundButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _RoundButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(child: child),
      ),
    );
  }
}

// ─── Botón circular grande (controles) ──────────────────────────────────────

class _BigButton extends StatelessWidget {
  final double size;
  final VoidCallback onTap;
  final Widget child;

  const _BigButton(
      {required this.size, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      ),
    );
  }
}

// ─── Opción del menú ─────────────────────────────────────────────────────────

class _OptionItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _OptionItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFAAAAAA), size: 22),
          const SizedBox(width: 14),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 15)),
        ],
      ),
    );
  }
}
