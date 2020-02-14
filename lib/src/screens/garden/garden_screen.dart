import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grateful/src/widgets/full_screen_layout.dart';

// @see https://codepen.io/AshKyd/pen/JYXEpL

class GardenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FullScreenLayout(
      child: Container(
        child: Garden(),
      ),
    );
  }
}

class Garden extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(plant.toStringDeep());
    return Center(
        child: CustomPaint(
      foregroundPainter: GardenPainter(),
      child: Container(
        height: 300,
        width: 100,
      ),
    ));
  }
}

class GardenPainter extends CustomPainter {
  static const double dimensionMultiplier = 0.6;
  @override
  void paint(Canvas canvas, Size size) {
    final Widget plant = SvgPicture.asset('assets/images/plant.svg');

    final Offset canvasCenter = Offset(size.width / 2, size.height / 2);
    final Paint paint = Paint()
      ..color = Colors.yellow[300]
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 10.0;
    canvas.drawCircle(canvasCenter, size.width * 2, paint);
    canvas.drawPicture(plant);
    drawCube(
        canvas,
        paint,
        canvasCenter.dx,
        canvasCenter.dy + (size.height * dimensionMultiplier) / 2,
        size.height * dimensionMultiplier,
        size.height * dimensionMultiplier,
        30,
        Colors.orange);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

void drawCube(Canvas canvas, Paint paint, double startX, double startY,
    double xWidth, double yWidth, double height, Color color) {
  final Path leftFace = Path();
  leftFace.moveTo(startX, startY);
  leftFace.lineTo(startX - xWidth, startY - xWidth * 0.5);
  leftFace.lineTo(startX - xWidth, startY - height - xWidth * 0.5);
  leftFace.lineTo(startX, startY - height * 1);
  leftFace.close();
  canvas.drawPath(leftFace, paint..color = const Color(0xFFB59574));

  final Path rightFace = Path();
  rightFace.moveTo(startX, startY);
  rightFace.lineTo(startX + yWidth, startY - yWidth * 0.5);
  rightFace.lineTo(startX + yWidth, startY - height - yWidth * 0.5);
  rightFace.lineTo(startX, startY - height * 1);
  rightFace.close();
  canvas.drawPath(rightFace, paint..color = const Color(0xFFcfbaa5));

  final Path topFace = Path();
  topFace.moveTo(startX, startY - height);
  topFace.lineTo(startX - xWidth, startY - height - xWidth * 0.5);
  topFace.lineTo(startX - xWidth + yWidth,
      startY - height - (xWidth * 0.5 + yWidth * 0.5));
  topFace.lineTo(startX + yWidth, startY - height - yWidth * 0.5);
  topFace.close();
  canvas.drawPath(topFace, paint..color = Colors.lightGreen[700]);
}
