import 'package:flutter/material.dart';
import 'package:make_graph/main.dart';

class BarBottom extends StatelessWidget {

  final int index;
  final bool isPointed;
  BarBottom({required this.index, required this.isPointed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: barWidth,
      child: CustomPaint(
        painter: BarBottomTextPainter(index,isPointed),
      ),
    );
  }
}


class BarBottomTextPainter extends CustomPainter{
  const BarBottomTextPainter(this.index, this.isPointed);

  final int index;
  final bool isPointed;
  @override
  void paint(Canvas canvas, Size size) {

    final textCenter = Offset(size.width/2 - 4, size.height /2 - 6);
    final eqTextStyle = TextStyle(
      color: Colors.green,
    );
    final neqTextStyle = TextStyle(
      color: Colors.black,
    );

    final textSpan = TextSpan(
      text: index.toString(),
      style: isPointed ? eqTextStyle : neqTextStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 40,
    );

    textPainter.paint(canvas, textCenter);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}