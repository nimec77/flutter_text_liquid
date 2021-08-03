import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextLiquidFill extends StatefulWidget {
  const TextLiquidFill({
    Key? key,
    required this.text,
    this.textStyle = const TextStyle(fontSize: 140, fontWeight: FontWeight.bold),
    this.textAlign = TextAlign.center,
    this.loadDuration = const Duration(seconds: 6),
    this.waveDuration = const Duration(seconds: 2),
    this.decoration = const BoxDecoration(color: Colors.red),
    this.waveColor = Colors.blueAccent,
  }) : super(key: key);

  final TextStyle textStyle;
  final Duration loadDuration;
  final Duration waveDuration;
  final String text;
  final TextAlign textAlign;
  final Decoration decoration;
  final Color waveColor;

  @override
  _TextLiquidFillState createState() => _TextLiquidFillState();
}

class _TextLiquidFillState extends State<TextLiquidFill> with TickerProviderStateMixin {
  final _textKey = GlobalKey();
  late final AnimationController _waveController, _loadController;
  late final Animation<double> _loadValue;
  ui.Image? _image;

  @override
  void initState() {
    _waveController = AnimationController(
      vsync: this,
      duration: widget.waveDuration,
    );
    _loadController = AnimationController(
      vsync: this,
      duration: widget.loadDuration,
    );
    _loadValue = Tween<double>().animate(_loadController);

    super.initState();

    _loadImage('assets/no_data.png').then((value) => _image = value);

    _loadValue.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _waveController.stop();
      }
    });
    _waveController.repeat();
    _loadController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _loadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: widget.decoration,
          child: AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) => CustomPaint(
              painter: _WavePainter(
                textKey: _textKey,
                waveValue: _waveController.value,
                loadValue: _loadController.value,
                waveColor: widget.waveColor,
              ),
            ),
          ),
        ),
        ShaderMask(
          blendMode: BlendMode.srcOut,
          shaderCallback: (bounds) {
            if (_image == null) {
              return const LinearGradient(colors: [Colors.transparent], stops: [0]).createShader(bounds);
            }
            return ImageShader(
              _image!,
              TileMode.clamp,
              TileMode.clamp,
              Matrix4.identity().storage,
            );
          },
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Text(
                widget.text,
                key: _textKey,
                style: widget.textStyle,
                textAlign: widget.textAlign,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<ui.Image> _loadImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final list = Uint8List.view(data.buffer);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(list, completer.complete);

    return completer.future;
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({
    required this.textKey,
    required this.waveValue,
    required this.loadValue,
    required this.waveColor,
  });

  final GlobalKey textKey;
  final double waveValue;
  final double loadValue;
  final Color waveColor;

  @override
  void paint(Canvas canvas, Size size) {
    const kWaveMultiply = 20.0;
    final textBox = textKey.currentContext?.findRenderObject() as RenderBox?;
    if (textBox == null) {
      return;
    }
    final width = size.width;
    final height = size.height;
    final textHeight = textBox.size.height;
    final baseHeight = height / 2 + textHeight / 2 - loadValue * textHeight;
    final path = Path();
    for (var i = 0.0; i < width; ++i) {
      path.lineTo(i, baseHeight + math.sin(2 * math.pi * (i / width + waveValue)) * kWaveMultiply);
    }
    path
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    final wavePaint = Paint()..color = waveColor;
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
