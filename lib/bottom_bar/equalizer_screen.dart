import 'package:flutter/material.dart';
import 'dart:math' as math;

class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({super.key});

  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen> {
  int _activeTab = 0; // 0=Ecu, 1=Tono, 2=Límite

  // EQ bands: Preamp, 31, 62, 125, 250, 500, 1K, 2K, 4K, 8K
  final List<String> _bandLabels = [
    'Preamp', '31', '62', '125', '250', '500', '1K', '2K', '4K', '8K'
  ];
  final List<double> _bandValues = List.filled(10, 0.0);

  // Tono knobs
  double _bassValue = 0.31;
  double _trebleValue = 0.0;
  double _balanceValue = 0.5;
  double _stereoValue = 0.0;
  double _volumeValue = 0.44;
  double _tempoValue = 0.5;

  // Reverb knobs
  final List<double> _reverbValues = List.filled(7, 0.0);
  final List<String> _reverbLabels = [
    'Amortiguación', 'Filtro', 'Fundido',
    'Preretardo', 'Mezcla preretardo', 'Tamaño', 'Mezclado'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Tab selector superior
            _buildTabBar(),
            // Contenido según tab
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _TabBtn(label: '≡ᵢ', index: 0, active: _activeTab, onTap: _setTab),
          _TabBtn(label: '◑', index: 1, active: _activeTab, onTap: _setTab),
          _TabBtn(label: '(●)', index: 2, active: _activeTab, onTap: _setTab),
        ],
      ),
    );
  }

  void _setTab(int i) => setState(() => _activeTab = i);

  Widget _buildTabContent() {
    switch (_activeTab) {
      case 0:
        return _buildEcuContent();
      case 1:
        return _buildTonoContent();
      case 2:
        return _buildReverbContent();
      default:
        return _buildEcuContent();
    }
  }

  // ── TAB ECU ──────────────────────────────────────────────────────────────

  Widget _buildEcuContent() {
    return Column(
      children: [
        // Sliders EQ
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: Row(
              children: List.generate(10, (i) => _buildEqSlider(i)),
            ),
          ),
        ),
        // Curva EQ visualizer
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomPaint(painter: _EqCurvePainter(_bandValues)),
        ),
        // Info
        const Text(
          'DVC EQ 10 TON LMT',
          style: TextStyle(color: Color(0xFF888888), fontSize: 12),
        ),
        const SizedBox(height: 8),
        // Botones Ecu / Preajuste / ⋮
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              _ActiveChip(label: 'Ecu', active: true),
              const SizedBox(width: 8),
              _ActiveChip(label: 'Preajuste', active: false, bold: true),
              const Spacer(),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF444444)),
                ),
                child: const Icon(Icons.more_vert,
                    color: Color(0xFFAAAAAA), size: 18),
              ),
            ],
          ),
        ),
        // Graves y Agudos knobs
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _KnobWidget(
                label: 'Graves',
                value: _bassValue,
                displayValue: '${(_bassValue * 100).round()}%',
                accentColor: const Color(0xFF00FF88),
                onChanged: (v) => setState(() => _bassValue = v),
              ),
              const SizedBox(width: 24),
              _KnobWidget(
                label: 'Agud...',
                value: _trebleValue,
                displayValue: '${(_trebleValue * 100).round()}%',
                onChanged: (v) => setState(() => _trebleValue = v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEqSlider(int index) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: RotatedBox(
              quarterTurns: -1,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape: const _EqThumbShape(),
                  activeTrackColor: const Color(0xFF00FF66),
                  inactiveTrackColor: const Color(0xFF333333),
                  overlayColor: Colors.transparent,
                ),
                child: Slider(
                  value: (_bandValues[index] + 12) / 24,
                  onChanged: (v) => setState(
                      () => _bandValues[index] = v * 24 - 12),
                ),
              ),
            ),
          ),
          Text(
            _bandLabels[index],
            style: const TextStyle(
                color: Color(0xFF888888), fontSize: 9),
          ),
          const SizedBox(height: 2),
          Text(
            _bandValues[index].toStringAsFixed(1),
            style: const TextStyle(
                color: Color(0xFF666666), fontSize: 9),
          ),
        ],
      ),
    );
  }

  // ── TAB TONO ─────────────────────────────────────────────────────────────

  Widget _buildTonoContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _KnobWidget(
                label: 'Balance',
                value: _balanceValue,
                displayValue: '0.00',
                size: 110,
                onChanged: (v) => setState(() => _balanceValue = v),
              ),
              _KnobWidget(
                label: 'Expans. Estéreo',
                value: _stereoValue,
                displayValue: '${(_stereoValue * 100).round()}%',
                size: 110,
                onChanged: (v) => setState(() => _stereoValue = v),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _ActiveChip(label: 'Tempo', active: false),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _KnobWidget(
                label: '',
                value: _tempoValue,
                displayValue: '1.00x',
                size: 110,
                onChanged: (v) => setState(() => _tempoValue = v),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  _SmallButton(label: '+', onTap: () {}),
                  const SizedBox(height: 8),
                  _SmallButton(label: '−', onTap: () {}),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ActiveChip(label: 'Mono', active: false),
              _ActiveChip(label: 'Restablecer', active: false, bold: true),
            ],
          ),
          const SizedBox(height: 24),
          _KnobWidget(
            label: 'Volumen',
            value: _volumeValue,
            displayValue: '${(_volumeValue * 100).round()}%',
            size: 130,
            accentColor: const Color(0xFF00FF88),
            onChanged: (v) => setState(() => _volumeValue = v),
          ),
        ],
      ),
    );
  }

  // ── TAB REVERB ───────────────────────────────────────────────────────────

  Widget _buildReverbContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Primera fila: 3 knobs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [0, 1, 2].map((i) => _KnobWidget(
              label: _reverbLabels[i],
              value: _reverbValues[i],
              displayValue: _reverbValues[i].toStringAsFixed(2),
              size: 90,
              onChanged: (v) => setState(() => _reverbValues[i] = v),
            )).toList(),
          ),
          const SizedBox(height: 20),
          // Segunda fila: 3 knobs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [3, 4, 5].map((i) => _KnobWidget(
              label: _reverbLabels[i],
              value: _reverbValues[i],
              displayValue: _reverbValues[i].toStringAsFixed(2),
              size: 90,
              onChanged: (v) => setState(() => _reverbValues[i] = v),
            )).toList(),
          ),
          const SizedBox(height: 16),
          // Botones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ActiveChip(label: 'Reverb', active: true),
              _ActiveChip(label: 'Preajuste', active: false, bold: true),
              _ActiveChip(label: 'Guardar', active: false, bold: true),
              _ActiveChip(label: 'Restable...', active: false, bold: true),
            ],
          ),
          const SizedBox(height: 24),
          // Último knob centrado
          _KnobWidget(
            label: _reverbLabels[6],
            value: _reverbValues[6],
            displayValue: _reverbValues[6].toStringAsFixed(2),
            size: 110,
            onChanged: (v) => setState(() => _reverbValues[6] = v),
          ),
        ],
      ),
    );
  }
}

// ─── Componentes ────────────────────────────────────────────────────────────

class _TabBtn extends StatelessWidget {
  final String label;
  final int index;
  final int active;
  final ValueChanged<int> onTap;

  const _TabBtn(
      {required this.label,
      required this.index,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = index == active;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF3A3A3A) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF666666),
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  final String label;
  final bool active;
  final bool bold;

  const _ActiveChip(
      {required this.label, required this.active, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF333333) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? const Color(0xFF555555) : const Color(0xFF333333),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFFAAAAAA),
            fontSize: 13,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SmallButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(label,
              style:
                  const TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }
}

// ─── Knob circular ──────────────────────────────────────────────────────────

class _KnobWidget extends StatefulWidget {
  final String label;
  final double value;
  final String displayValue;
  final double size;
  final Color accentColor;
  final ValueChanged<double> onChanged;

  const _KnobWidget({
    required this.label,
    required this.value,
    required this.displayValue,
    required this.onChanged,
    this.size = 80,
    this.accentColor = const Color(0xFF444444),
  });

  @override
  State<_KnobWidget> createState() => _KnobWidgetState();
}

class _KnobWidgetState extends State<_KnobWidget> {
  double _startY = 0;
  double _startValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onVerticalDragStart: (d) {
            _startY = d.globalPosition.dy;
            _startValue = widget.value;
          },
          onVerticalDragUpdate: (d) {
            final delta = (_startY - d.globalPosition.dy) / 150;
            final newVal = (_startValue + delta).clamp(0.0, 1.0);
            widget.onChanged(newVal);
          },
          child: CustomPaint(
            painter: _KnobPainter(widget.value, widget.accentColor),
            size: Size(widget.size, widget.size),
          ),
        ),
        if (widget.label.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(widget.label,
              style: const TextStyle(
                  color: Color(0xFFAAAAAA), fontSize: 11)),
        ],
        Text(widget.displayValue,
            style: const TextStyle(
                color: Color(0xFF888888), fontSize: 11)),
      ],
    );
  }
}

class _KnobPainter extends CustomPainter {
  final double value;
  final Color accentColor;

  _KnobPainter(this.value, this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Fondo del knob
    canvas.drawCircle(
        center,
        radius,
        Paint()..color = const Color(0xFF2A2A2A));

    // Arco de progreso
    final startAngle = math.pi * 0.75;
    final sweepAngle = math.pi * 1.5 * value;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = accentColor
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Marcador (línea blanca)
    final angle = startAngle + sweepAngle;
    final markerX = center.dx + (radius - 12) * math.cos(angle);
    final markerY = center.dy + (radius - 12) * math.sin(angle);
    canvas.drawCircle(
        Offset(markerX, markerY), 3, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_KnobPainter old) => old.value != value;
}

class _EqThumbShape extends SliderComponentShape {
  const _EqThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size(28, 28);

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
        Rect.fromCenter(center: center, width: 28, height: 20),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF555555),
    );
    canvas.drawRect(
      Rect.fromCenter(center: center, width: 12, height: 2),
      Paint()..color = const Color(0xFFAAAAAA),
    );
  }
}

class _EqCurvePainter extends CustomPainter {
  final List<double> values;

  _EqCurvePainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF66)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final step = size.width / (values.length - 1);
    for (int i = 0; i < values.length; i++) {
      final x = i * step;
      final y = size.height / 2 - (values[i] / 12) * (size.height / 2 - 4);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_EqCurvePainter old) => true;
}
