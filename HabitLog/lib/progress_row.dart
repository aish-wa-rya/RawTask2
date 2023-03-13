import 'package:flutter/material.dart';
import 'models/habit.dart';
import 'services/database.dart';
import 'dart:math';

//class ProgressRow extends StatelessWidget {
//  Habit habit;
//  ProgressRow(this.habit, {Key key}) : super(key: key);
//
//  @override
//  _ProgressRow createState() => _ProgressRow(habit);
//}


class ProgressRow extends StatelessWidget{
  Habit habit;
  final int rowLen = 7;

  ProgressRow(this.habit);

  @override
  Widget build(BuildContext context) {

    List prevdates = habit.getPreviousDates(Database().getToday());
//    print(prevdates);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ..._buildRow(context, habit.new_getPreviousDates(Database().getToday())),
      ],
    );
  }

  List<Widget> _buildRow(BuildContext context, List previousDates){
    List<Widget> circles = [];
    double density = 0.1;
    while (previousDates.length < rowLen){
      previousDates.add(false);
    }
    List<bool> revDates = previousDates.sublist(0,rowLen).reversed.toList();
//    print(revDates);

    for(var i = 0; i < rowLen; i++){
      if(i<revDates.length){
        if(revDates[i]){
          density+=0.2;
        }else{
          density*=0;
          density+=.1;
        }
        circles.add(_buildCircle(context, revDates[i], density));
        }
      else{
        circles.add(_buildCircle(context, false, 0.1));
      }
    }
//    print(circles);

    return circles;

  }

  Widget _buildCircle(BuildContext context, bool completed, double density){
    return Container(
      padding: EdgeInsets.all(2.0),
      child: SizedBox(
        width: 18,
        height: 18,
        child: CustomPaint(
          painter: CirclePainter(completed, density),
        ),
      ),
    );
  }

}

class CirclePainter extends CustomPainter {
  bool completed;
  double density;
  final _paint = Paint();

  CirclePainter(bool completed, double density) {
    this.completed = completed;
    this.density = density;
    _paint.style = PaintingStyle.stroke;
    if (completed) {
      _paint.style = PaintingStyle.fill;
    }
    _paint.color = Color.fromRGBO(111, 220, 150, min(density,1));
    _paint.strokeWidth = 3;
  // Use [PaintingStyle.fill] if you want the circle to be filled.

  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}