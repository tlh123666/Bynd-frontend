import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../tokens/app_motion.dart';
import '../tokens/app_atmosphere_palette.dart';

/// Slowly moving radial light over a CSS-token gradient. Pauses its updates
/// underneath inactive routes and honours the system's reduced motion setting.
class AppAtmosphereBackground extends StatefulWidget {
  const AppAtmosphereBackground({
    required this.gradient,
    required this.light,
    required this.child,
    this.palette,
    super.key,
  });
  final Gradient gradient;
  final Color light;
  final Widget child;
  final AppAtmospherePalette? palette;
  @override
  State<AppAtmosphereBackground> createState() =>
      _AppAtmosphereBackgroundState();
}

class _AppAtmosphereBackgroundState extends State<AppAtmosphereBackground> {
  Timer? _timer;
  double _phase = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer?.cancel();
    if (AppMotion.enabled(context) && TickerMode.valuesOf(context).enabled) {
      _timer = Timer.periodic(const Duration(seconds: 15), (_) {
        if (mounted) setState(() => _phase = 1 - _phase);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(gradient: widget.gradient),
    child: TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: _phase),
      duration: AppMotion.enabled(context)
          ? const Duration(seconds: 8)
          : Duration.zero,
      builder: (c, v, child) => CustomPaint(
        painter: _AtmospherePainter(widget.light, v, widget.palette),
        child: child,
      ),
      child: widget.child,
    ),
  );
}

class _AtmospherePainter extends CustomPainter {
  const _AtmospherePainter(this.light, this.phase, this.palette);
  final Color light;
  final double phase;
  final AppAtmospherePalette? palette;
  @override
  void paint(Canvas canvas, Size size) {
    if (palette != null) {
      _paintSky(canvas, size, palette!);
      return;
    }
    final rect = Offset.zero & size;
    for (final spot in [
      (.28 + .16 * phase, .08, .62, .07),
      (.85 - .12 * phase, .3, .45, .04),
    ]) {
      final center = Offset(size.width * spot.$1, size.height * spot.$2),
          radius = size.width * spot.$3;
      final shader = RadialGradient(
        colors: [
          light.withValues(alpha: spot.$4),
          light.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawRect(rect, Paint()..shader = shader);
    }
  }

  static double _fract(double x) => x - x.floor();
  static double _hash(double x, double y) =>
      _fract(math.sin(x * 127.1 + y * 311.7) * 43758.5453123);
  static double _smooth(double a, double b, double v) {
    final t = ((v - a) / (b - a)).clamp(0.0, 1.0);
    return t * t * (3 - 2 * t);
  }

  static double _noise(double x, double y) {
    final ix = x.floorToDouble(),
        iy = y.floorToDouble(),
        u = _smooth(0, 1, _fract(x)),
        v = _smooth(0, 1, _fract(y)),
        a = _hash(ix, iy),
        b = _hash(ix + 1, iy),
        c = _hash(ix, iy + 1),
        d = _hash(ix + 1, iy + 1);
    return a + (b - a) * u + (c - a) * v * (1 - u) + (d - b) * u * v;
  }

  static double _fbm(double x, double y) {
    var value = 0.0, amplitude = .5;
    for (var i = 0; i < 4; i++) {
      value += amplitude * _noise(x, y);
      x *= 2.03;
      y *= 2.03;
      amplitude *= .5;
    }
    return value;
  }

  static double _linear(double c) =>
      c <= .04045 ? c / 12.92 : math.pow((c + .055) / 1.055, 2.4).toDouble();

  // Port of ceuVivo's color/noise equations. A small interpolated mesh keeps
  // the same palette and lighting on Flutter Web without a WebGL dependency.
  void _paintSky(Canvas canvas, Size size, AppAtmospherePalette p) {
    if (size.isEmpty) return;
    List<double> rgb(Color c) => [_linear(c.r), _linear(c.g), _linear(c.b)];
    final c1 = rgb(p.base),
        c2 = rgb(p.top),
        c3 = rgb(p.pool),
        aur = [p.aurora.r, p.aurora.g, p.aurora.b];
    const progress = .1, columns = 10, rows = 24;
    final time = 6 + phase * 8,
        t = time * .05,
        angle = (18 - 32 * progress) * math.pi / 180;
    final positions = <Offset>[], colors = <Color>[], indices = <int>[];
    for (var y = 0; y <= rows; y++) {
      for (var x = 0; x <= columns; x++) {
        final ax = (x / columns - .5) * size.width / size.height,
            ay = .5 - y / rows,
            g = (ax * math.sin(angle) + ay * math.cos(angle)) * .7 + .5,
            mix = _smooth(.12, .85, g),
            qx = ax * 1.6 + t * .6,
            qy = ay * 1.6 - t * .4,
            warp = _fbm(qx + t * .3, qy + t * .3),
            pool =
                _smooth(.55, .95, _fbm(qx + warp, qy + warp)) *
                (.4 - .2 * progress) *
                .3,
            bandY = ay - .34 + _fbm(ax * 1.2 + t * .8, 2.7) * .34 - .17,
            band =
                math.exp(-bandY * bandY * 26) *
                (.16 + .1 * math.sin(time * .18)) *
                (1 - .5 * progress),
            d = math.sqrt(ax * ax + ay * ay),
            glow = (.03 + .07 * progress) * _smooth(.85, 0, d),
            vignette = 1 - .28 * _smooth(.55, 1.25, d);
        final out = <double>[];
        for (var channel = 0; channel < 3; channel++) {
          final base = c1[channel] + (c2[channel] - c1[channel]) * mix,
              shade = base + (c3[channel] - base) * pool,
              light = aur[channel] + (c3[channel] - aur[channel]) * .45;
          out.add(
            ((shade + light * band + c3[channel] * glow) * vignette).clamp(
              0,
              1,
            ),
          );
        }
        positions.add(Offset(x / columns * size.width, y / rows * size.height));
        colors.add(
          Color.from(alpha: 1, red: out[0], green: out[1], blue: out[2]),
        );
        if (x < columns && y < rows) {
          final a = y * (columns + 1) + x, b = a + columns + 1;
          indices.addAll([a, b, a + 1, a + 1, b, b + 1]);
        }
      }
    }
    final mesh = ui.Vertices(
      ui.VertexMode.triangles,
      positions,
      colors: colors,
      indices: indices,
    );
    canvas.drawVertices(mesh, BlendMode.src, Paint());
    mesh.dispose();
  }

  @override
  bool shouldRepaint(_AtmospherePainter old) =>
      old.phase != phase || old.light != light || old.palette != palette;
}
