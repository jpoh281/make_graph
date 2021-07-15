import 'package:flutter/material.dart';
import 'package:make_graph/main.dart';
class Bar extends StatelessWidget {

  const Bar({required this.value,required this.index});

  final double value;
  final int index;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: barWidth,
      height: barHeight,
      child: CustomPaint(
        painter : BarPainter(value, index),
      ),
    );
  }
}


class BarPainter extends CustomPainter{
  const BarPainter(this.value, this.index);

  final int index;
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 12.0;
    final center = Offset(size.width/2, size.height - 20);
    final end = Offset(size.width/2, size.height - 20 - value);

    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..color = (index == nowIndex) ? Colors.green : Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center,end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}