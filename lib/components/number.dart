import 'package:flutter/material.dart';

class Number extends StatefulWidget {
  final String number;
  final double fontSize;
  final Color color;

  Number ({Key key, this.number, this.fontSize, this.color}) : super(key:key);

  @override
  _NumberState createState() => _NumberState();
}

class _NumberState extends State<Number> {
  Color disabledColor = Color.fromRGBO(240, 240, 240, 1);

  bool top = false;
  bool northwest = false;
  bool southwest = false;
  bool northeast = false;
  bool southeast = false;
  bool bottom = false;
  bool mid = false;

  void renderNumber(){
    switch (widget.number) {
      case '1':
        setState(() {
          top = false;
          northwest = false;
          southwest = false;
          northeast = true;
          southeast = true;
          bottom = false;
          mid = false;
        });
        break;
      case '2':
        setState(() {
          top = true;
          northwest = false;
          southwest = true;
          northeast = true;
          southeast = false;
          bottom = true;
          mid = true;
        });
        break;
      case '3':
        setState(() {
          top = true;
          northwest = false;
          southwest = false;
          northeast = true;
          southeast = true;
          bottom = true;
          mid = true;
        });
        break;
      case '4':
        setState(() {
          top = false;
          northwest = true;
          southwest = false;
          northeast = true;
          southeast = true;
          bottom = false;
          mid = true;
        });
        break;
      case '5':
        setState(() {
          top = true;
          northwest = true;
          southwest = false;
          northeast = false;
          southeast = true;
          bottom = true;
          mid = true;
        });
        break;
      case '6':
        setState(() {
          top = true;
          northwest = true;
          southwest = true;
          northeast = false;
          southeast = true;
          bottom = true;
          mid = true;
        });
        break;
      case '7':
        setState(() {
          top = true;
          northwest = false;
          southwest = false;
          northeast = true;
          southeast = true;
          bottom = false;
          mid = false;
        });
        break;
      case '8':
        setState(() {
          top = true;
          northwest = true;
          southwest = true;
          northeast = true;
          southeast = true;
          bottom = true;
          mid = true;
        });
        break;
      case '9':
        setState(() {
          top = true;
          northwest = true;
          southwest = false;
          northeast = true;
          southeast = true;
          bottom = true;
          mid = true;
        });
        break;
      default:
        setState(() {
          top = true;
          northwest = true;
          southwest = true;
          northeast = true;
          southeast = true;
          bottom = true;
          mid = false;
        });
    }
  }

  @override
  void initState() {
    super.initState();
    renderNumber();
  }

  @override
  void didUpdateWidget(Number oldWidget){
    super.didUpdateWidget(oldWidget);
    renderNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: widget.fontSize*2,
        width: widget.fontSize,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: ClipPath(
                child: Container(
                  height: widget.fontSize*0.2,
                  width: widget.fontSize,
                  color: top ? widget.color : disabledColor,
                ),
                clipper: SegmentClipper(),
              ),
            ),
            Positioned(
              child: RotatedBox(
                child: ClipPath(
                  child: Container(
                    height: widget.fontSize*0.2,
                    width: widget.fontSize,
                    color: northwest ? widget.color : disabledColor,
                  ),
                  clipper: SegmentClipper(),
                ),
                quarterTurns: 3,
              ),
            ),
            Positioned(
              child: RotatedBox(
                child: ClipPath(
                  child: Container(
                    height: widget.fontSize*0.2,
                    width: widget.fontSize,
                    color: southwest ? widget.color : disabledColor,
                  ),
                  clipper: SegmentClipper(),
                ),
                quarterTurns: 3,
              ),
              bottom: 0,
            ),
            Positioned(
              child: RotatedBox(
                child: ClipPath(
                  child: Container(
                    height: widget.fontSize*0.2,
                    width: widget.fontSize,
                    color: northeast ? widget.color : disabledColor,
                  ),
                  clipper: SegmentClipper(),
                ),
                quarterTurns: 1,
              ),
              right: 0,
            ),
            Positioned(
              child: RotatedBox(
                child: ClipPath(
                  child: Container(
                    height: widget.fontSize*0.2,
                    width: widget.fontSize,
                    color: southeast ? widget.color : disabledColor,
                  ),
                  clipper: SegmentClipper(),
                ),
                quarterTurns: 1,
              ),
              right: 0,
              bottom: 0,
            ),
            Positioned(
              child: RotatedBox(
                child: ClipPath(
                  child: Container(
                    height: widget.fontSize*0.2,
                    width: widget.fontSize,
                    color: bottom ? widget.color : disabledColor,
                  ),
                  clipper: SegmentClipper(),
                ),
                quarterTurns: 2,
              ),
              bottom: 0,
            ),
            Positioned(
              child: ClipPath(
                child: Container(
                  height: widget.fontSize*0.2,
                  width: widget.fontSize,
                  color: mid ? widget.color : disabledColor,
                ),
                clipper: MidSegmentClipper(),
              ),
              top: widget.fontSize*0.9,
            ),
          ],
        ),
      ),
    );
  }
}

class MidSegmentClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    Path path = Path();
    path.moveTo(0.0, size.height/2);
    path.lineTo(size.height, size.height);
    path.lineTo(size.width - size.height, size.height);
    path.lineTo(size.width, size.height/2);
    path.lineTo(size.width - size.height, 0.0);
    path.lineTo(size.height, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldclipper) => false;
}

class SegmentClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    Path path = Path();
    path.lineTo(size.height, size.height);
    path.lineTo(size.width - size.height, size.height);
    path.lineTo(size.width, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}