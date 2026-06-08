import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/eq_provider.dart';

class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({super.key});
  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eq = context.watch<EqProvider>();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Tab bar
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TabBar(
                controller: _tabs,
                indicator: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(22),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF666666),
                labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.tune_rounded, size: 18), SizedBox(width: 4), Text('EQ')])),
                  Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.radio_button_checked_rounded, size: 18), SizedBox(width: 4), Text('Tono')])),
                  Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.spatial_audio_rounded, size: 18), SizedBox(width: 4), Text('Reverb')])),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _EqTab(eq: eq),
                  _ToneTab(eq: eq),
                  _ReverbTab(eq: eq),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── EQ Tab ───────────────────────────────────────────────────────────────────
class _EqTab extends StatelessWidget {
  final EqProvider eq;
  const _EqTab({required this.eq});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sliders
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: Row(
              children: List.generate(EqProvider.bandLabels.length, (i) {
                return Expanded(
                  child: _EqSlider(
                    label: EqProvider.bandLabels[i],
                    value: eq.bands[i],
                    onChanged: (v) => eq.setBand(i, v),
                  ),
                );
              }),
            ),
          ),
        ),
        // Frequency curve preview
        Container(
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomPaint(
            painter: _EqCurvePainter(bands: eq.bands),
            size: const Size(double.infinity, 48),
          ),
        ),
        // Preset label
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(eq.preset,
              style: const TextStyle(color: Color(0xFF888888), fontSize: 12)),
        ),
        // Buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              _EqChip(label: 'Ecu', onTap: () {}),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showPresets(context, eq),
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1C),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF3A3A3A)),
                    ),
                    child: const Center(child: Text('Preajuste',
                        style: TextStyle(color: Colors.white, fontSize: 13))),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _EqChip(label: 'Reset', onTap: eq.reset),
            ],
          ),
        ),
        // Tone + Treble knobs
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Expanded(child: _KnobControl(
                label: 'Graves', value: eq.tone,
                onChanged: (v) => eq.setVolume(v),
                color: Colors.cyanAccent)),
              const SizedBox(width: 16),
              Expanded(child: _KnobControl(
                label: 'Agud...', value: eq.treble,
                onChanged: (v) {},
                color: const Color(0xFF555555))),
            ],
          ),
        ),
      ],
    );
  }

  void _showPresets(BuildContext context, EqProvider eq) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1C),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Preajustes',
                style: TextStyle(color: Colors.white, fontSize: 16,
                    fontWeight: FontWeight.w700)),
          ),
          ...EqProvider.presets.keys.map((p) => ListTile(
            title: Text(p, style: const TextStyle(color: Colors.white)),
            trailing: eq.preset == p
                ? const Icon(Icons.check_rounded, color: Colors.white)
                : null,
            onTap: () { eq.applyPreset(p); Navigator.pop(context); },
          )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _EqSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  const _EqSlider({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${value >= 0 ? '+' : ''}${value.toStringAsFixed(1)}',
            style: const TextStyle(color: Color(0xFF888888), fontSize: 9)),
        Expanded(
          child: RotatedBox(
            quarterTurns: 3,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                thumbShape: _EqThumbShape(),
                activeTrackColor: const Color(0xFF39FF14),
                inactiveTrackColor: const Color(0xFF333333),
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: value, min: -12, max: 12,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
        Text(label,
            style: const TextStyle(color: Color(0xFF888888), fontSize: 9,
                fontWeight: FontWeight.w600)),
        Text('${value.toStringAsFixed(1)}',
            style: const TextStyle(color: Color(0xFF555555), fontSize: 8)),
      ],
    );
  }
}

class _EqThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(24, 24);

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final canvas = context.canvas;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: 28, height: 16),
          const Radius.circular(8)),
      Paint()..color = const Color(0xFF3A3A3A),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: 14, height: 3),
          const Radius.circular(2)),
      Paint()..color = const Color(0xFF888888),
    );
  }
}

class _EqCurvePainter extends CustomPainter {
  final List<double> bands;
  const _EqCurvePainter({required this.bands});

  @override
  void paint(Canvas canvas, Size size) {
    if (bands.isEmpty) return;
    final paint = Paint()
      ..color = const Color(0xFF39FF14)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final path = Path();
    final mid = size.height / 2;
    for (int i = 0; i < bands.length; i++) {
      final x = i / (bands.length - 1) * size.width;
      final y = mid - (bands[i] / 12) * (mid - 4);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
    // Zero line
    canvas.drawLine(Offset(0, mid), Offset(size.width, mid),
        Paint()..color = const Color(0xFF333333)..strokeWidth = 0.5);
  }

  @override
  bool shouldRepaint(_EqCurvePainter old) => old.bands != bands;
}

// ── Tone Tab ─────────────────────────────────────────────────────────────────
class _ToneTab extends StatelessWidget {
  final EqProvider eq;
  const _ToneTab({required this.eq});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(children: [
            Expanded(child: _KnobControl(label: 'Balance', value: (eq.balance + 1) / 2,
                onChanged: (v) => eq.setBalance(v * 2 - 1), color: const Color(0xFF888888))),
            const SizedBox(width: 24),
            Expanded(child: _KnobControl(label: 'Expans. Estéreo', value: eq.stereoExpansion,
                onChanged: eq.setStereoExpansion, color: const Color(0xFF888888))),
          ]),
          const SizedBox(height: 24),
          _EqChip(label: 'Tempo', onTap: () {}),
          const SizedBox(height: 16),
          _KnobControl(label: '${eq.tempo.toStringAsFixed(2)}x', value: (eq.tempo - 0.5) / 1.5,
              onChanged: (v) => eq.setTempo(0.5 + v * 1.5), color: const Color(0xFF888888)),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _EqChip(label: eq.mono ? 'Mono ✓' : 'Mono', onTap: eq.toggleMono),
            _EqChip(label: 'Restablecer', onTap: eq.reset),
          ]),
          const SizedBox(height: 24),
          _KnobControl(label: 'Volumen\n${(eq.volume * 100).round()}%',
              value: eq.volume, onChanged: eq.setVolume, color: const Color(0xFF39FF14), size: 120),
        ],
      ),
    );
  }
}

// ── Reverb Tab ────────────────────────────────────────────────────────────────
class _ReverbTab extends StatelessWidget {
  final EqProvider eq;
  const _ReverbTab({required this.eq});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(children: [
            Expanded(child: _KnobControl(label: 'Amortiguación\n${eq.damping.toStringAsFixed(2)}',
                value: eq.damping, onChanged: eq.setDamping, color: const Color(0xFF888888))),
            const SizedBox(width: 16),
            Expanded(child: _KnobControl(label: 'Filtro\n${eq.filter.toStringAsFixed(2)}',
                value: eq.filter, onChanged: eq.setFilter, color: const Color(0xFF888888))),
            const SizedBox(width: 16),
            Expanded(child: _KnobControl(label: 'Fundido\n${eq.fade.toStringAsFixed(2)}',
                value: eq.fade, onChanged: eq.setFade, color: const Color(0xFF888888))),
          ]),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: _KnobControl(label: 'Preretardo\n${eq.preDelay.toStringAsFixed(2)}',
                value: eq.preDelay, onChanged: eq.setPreDelay, color: const Color(0xFF888888))),
            const SizedBox(width: 16),
            Expanded(child: _KnobControl(label: 'Mezcla preretardo\n${eq.reverbMix.toStringAsFixed(2)}',
                value: eq.reverbMix, onChanged: eq.setReverbMix, color: const Color(0xFF888888))),
            const SizedBox(width: 16),
            Expanded(child: _KnobControl(label: 'Tamaño\n${eq.reverbSize.toStringAsFixed(2)}',
                value: eq.reverbSize, onChanged: eq.setReverbSize, color: const Color(0xFF888888))),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            _EqChip(label: 'Reverb', onTap: () {}),
            const SizedBox(width: 8),
            _EqChip(label: 'Preajuste', onTap: () {}),
            const SizedBox(width: 8),
            _EqChip(label: 'Guardar', onTap: () {}),
            const SizedBox(width: 8),
            _EqChip(label: 'Restable...', onTap: eq.reset),
          ]),
          const SizedBox(height: 24),
          _KnobControl(label: 'Mezclado\n${eq.mixed.toStringAsFixed(2)}',
              value: eq.mixed, onChanged: eq.setMixed,
              color: const Color(0xFF888888), size: 120),
        ],
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────
class _KnobControl extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final Color color;
  final double size;
  const _KnobControl({required this.label, required this.value,
      required this.onChanged, required this.color, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onVerticalDragUpdate: (d) {
            onChanged((value - d.delta.dy / 100).clamp(0.0, 1.0));
          },
          child: CustomPaint(
            painter: _KnobPainter(value: value, color: color),
            size: Size(size, size),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF888888), fontSize: 11)),
      ],
    );
  }
}

class _KnobPainter extends CustomPainter {
  final double value;
  final Color color;
  const _KnobPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final r = math.min(cx, cy) - 4;
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = const Color(0xFF2A2A2A));
    final trackPaint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r - 4),
        math.pi * 0.75, math.pi * 1.5, false, trackPaint);
    if (value > 0) {
      final valPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r - 4),
          math.pi * 0.75, math.pi * 1.5 * value, false, valPaint);
    }
    final angle = math.pi * 0.75 + math.pi * 1.5 * value;
    final dx = cx + (r - 10) * math.cos(angle);
    final dy = cy + (r - 10) * math.sin(angle);
    canvas.drawLine(Offset(cx, cy), Offset(dx, dy),
        Paint()..color = const Color(0xFF888888)..strokeWidth = 2..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(_KnobPainter old) => old.value != value;
}

class _EqChip extends StatelessWidget {
  final String label; final VoidCallback onTap;
  const _EqChip({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF3A3A3A))),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12))),
  );
}
