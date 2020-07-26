import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorDialog extends StatefulWidget {
  final Color initialMainColor;

  ColorDialog({Key key, this.initialMainColor}) : super(key: key);

  @override
  _ColorDialogState createState() => _ColorDialogState();
}

class _ColorDialogState extends State<ColorDialog> {
  Color mainColor;

  void changeColor(Color color) {
    mainColor = color;
  }

  @override
  void initState() {
    super.initState();
    mainColor = widget.initialMainColor;
  }

  //Dependência utilizada: flutter_colorpicker: ^0.3.4
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Escolha a cor desejada!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: mainColor,
          onColorChanged: changeColor,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context, mainColor);
          },
        )
      ],
    );
  }
}
