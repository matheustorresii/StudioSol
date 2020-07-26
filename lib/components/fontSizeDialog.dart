import 'package:flutter/material.dart';

class FontSizeDialog extends StatefulWidget {
  final double initialFontSize;
  final Color color;

  FontSizeDialog({Key key, this.initialFontSize, this.color}) : super(key: key);

  @override
  _FontSizeDialogState createState() => _FontSizeDialogState();
}

class _FontSizeDialogState extends State<FontSizeDialog> {
  double fontSize;

  @override
  void initState() {
    super.initState();
    fontSize = widget.initialFontSize;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Escolha o tamanho de fonte desejado!'),
      content: SliderTheme(
        child: Slider(
          value: fontSize,
          onChanged: (newSize) {
            setState(() => fontSize = newSize);
          },
          divisions: 6,
          label: "$fontSize",
          min: 40,
          max: 100,
        ),
        data: SliderTheme.of(context).copyWith(
            activeTrackColor: widget.color,
            inactiveTrackColor: widget.color.withAlpha(80),
            trackShape: RectangularSliderTrackShape(),
            trackHeight: 4.0,
            thumbColor: widget.color,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
            overlayColor: widget.color.withAlpha(32),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            activeTickMarkColor: widget.color,
            inactiveTickMarkColor: widget.color.withAlpha(80),
            valueIndicatorColor: widget.color),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context, fontSize);
          },
        ),
      ],
    );
  }
}
