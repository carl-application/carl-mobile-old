import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CarlFace extends StatelessWidget {
  CarlFace({@required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: CarlFaceCustomPainter(),
      child: Hero(
        tag: "carl_face",
        child: Image.asset(
          "assets/carl_face.png",
          width: size * 0.6,
          height: size * 0.6,
        ),
      ),
    );
  }
}

class CarlFaceCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = Color.fromRGBO(255, 255, 255, 0.4);

    final bottomBack = Offset(size.width / 2, size.height * 0.65);
    final topBack = Offset(size.width / 2, size.height * 0.35);
    final leftBack = Offset(size.width * 0.35, size.height / 2);
    final rightBack = Offset(size.width * 0.65, size.height / 2);

    //bottom circle
    canvas.drawCircle(bottomBack, 80.0, paint);
    //top circle
    canvas.drawCircle(topBack, 80.0, paint);
    // left circle
    canvas.drawCircle(leftBack, 80.0, paint);
    // right circle
    canvas.drawCircle(rightBack, 80.0, paint);


    paint.color = Colors.white;

    final center1 = Offset(size.width / 2, size.height * 0.65);
    final center2 = Offset(size.width / 2, size.height * 0.35);
    final center3 = Offset(size.width * 0.35, size.height / 2);
    final center4 = Offset(size.width * 0.65, size.height / 2);

    //bottom circle
    canvas.drawCircle(center1, 70.0, paint);
    //top circle
    canvas.drawCircle(center2, 70.0, paint);
    // left circle
    canvas.drawCircle(center3, 70.0, paint);
    // right circle
    canvas.drawCircle(center4, 70.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
