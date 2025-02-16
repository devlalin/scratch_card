import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:scratch_card/enum.dart';

class ScratchCardSrc extends StatefulWidget {
  final Widget child;
  final Color scratchColor;
  final String? scratchImage;
  final ImageType imageType;
  final double stockSize;

  const ScratchCardSrc(
      {super.key,
      this.imageType = ImageType.asset,
      this.scratchColor = Colors.grey,
      this.scratchImage,
      this.stockSize = 20,
      required this.child,
      });

  @override
  State<ScratchCardSrc> createState() => _ScratchCardScreenState();
}

class _ScratchCardScreenState extends State<ScratchCardSrc> {
  final List<Offset> _points = [];


  @override
  void initState() {
    super.initState();
    initialFunction();
  }

  

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        widget.child,
        GestureDetector(
           behavior: HitTestBehavior.translucent, 
          onPanUpdate: onScratch,
          child: IgnorePointer(
            ignoring: true,
            child: CustomPaint(
              size: Size.infinite,
              painter: ScratchCardPainter(
        
                  points: _points,
                  scratchCardColor: widget.scratchColor,
                  scratchImage: _scratchImage,
                  stockSize: widget.stockSize),
            ),
          ),
        ),
      ],
    );
  }

  bool _isLoading = false;

  set setIsLoading(bool loading) {
    _isLoading = loading;
    setState(() {});
  }

  Future<void> initialFunction() async {
    setIsLoading = true;
    await _setImage();
    setIsLoading = false;
  }

  ///scratch functions
  void onScratch(DragUpdateDetails details) {
    setState(() {
      RenderBox box = context.findRenderObject() as RenderBox;
      _points.add(box.globalToLocal(details.globalPosition));
    });
  }

  ///scratch image functions and variables

  ui.Image? _scratchImage;

  Future<void> _setImage() async {
    if (widget.scratchImage == null) return;
    switch (widget.imageType) {
      case ImageType.network:
        _scratchImage = await _loadNetworkImage();

        return;
      case ImageType.asset:
        _scratchImage = await _loadAssetImage();
        return;
      case ImageType.file:
        _scratchImage = await _loadFileImage();
        return;
    }
  }

  ///loads asset image to ui image for scratching
  Future<ui.Image> _loadAssetImage() async {
    final data =
        await DefaultAssetBundle.of(context).load(widget.scratchImage!);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  ///loads network image to ui image for scratching
  Future<ui.Image?> _loadNetworkImage() async {
    Uri? uri = Uri.tryParse(widget.scratchImage.toString());
    if (uri == null) return null;

    final ByteData imageData = await NetworkAssetBundle(uri).load("");
    final codec =
        await ui.instantiateImageCodec(imageData.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  ///loads file image to ui image for scratching
  Future<ui.Image> _loadFileImage() async {
    final file = File(widget.scratchImage!);
    final imageData = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(imageData);
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}

class ScratchCardPainter extends CustomPainter {
  final List<Offset> points;
  final ui.Image? scratchImage;

  final Color scratchCardColor;
  final double stockSize;


  ScratchCardPainter(
      {
      required this.points,
      this.scratchImage,
      this.scratchCardColor = Colors.grey,
      this.stockSize = 20.00});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Create a transparent layer

    // Draw a background layer with transparency
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    if (scratchImage != null) {
      Paint imagePaint = Paint();
      canvas.drawImageRect(
        scratchImage!,
        Rect.fromLTWH(0, 0, scratchImage!.width.toDouble(),
            scratchImage!.height.toDouble()),
        Rect.fromLTWH(0, 0, size.width, size.height),
        imagePaint,
      );
    } else {
      Paint imagePaint = Paint()..color = scratchCardColor;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), imagePaint);
    }

    // 2. Set up the eraser (the brush that "removes" the layer)
    Paint eraser = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..blendMode = BlendMode.clear
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stockSize
      ..strokeCap = StrokeCap.square;

    // 3. Draw paths where the user has scratched
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i], eraser);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
