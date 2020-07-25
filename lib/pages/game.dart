import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;

import 'package:studiosol/components/number.dart';
import 'package:studiosol/components/fontSizeDialog.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class ApiNumber {
  final int value;

  ApiNumber({this.value});

  factory ApiNumber.fromJson(Map<String, dynamic> json){
    return ApiNumber(
      value: json['value'] 
    );
  }
}

class _GameState extends State<Game> {
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  Future<ApiNumber> futureNumber;

  Color mainColor = Color.fromRGBO(234,30,99,1.0);
  Color pickerColor = Color.fromRGBO(234,30,99,1.0);

  double fontSize = 50.0;

  String title = 'Nova partida';
  bool buttonVisibility = true;
  bool buttonEnabled = false;

  String palpite = '';
  String lastPalpite = '0';
  String rightNumber = '';
  List stringArray = ['0'];

  void changeColor(Color color){
    setState(() {
      pickerColor = color;
    });
  }

  void sendNumber(){
    textController.clear();
    print(rightNumber);
    setState(() {
      lastPalpite = palpite;
      stringArray = lastPalpite.split('');
    });
    if(int.parse(lastPalpite) > int.parse(rightNumber)){
      setState(() {
        title = 'É menor!';
      });
    }else if (int.parse(lastPalpite) < int.parse(rightNumber)){
      setState(() {
        title = 'É maior!';
      });
    }else{
      setState(() {
        title = 'Acertou!';
        buttonVisibility = true;
        buttonEnabled = false;
      });
    }
  }

  void generateNewNumber(){
    print(rightNumber);
    setState(() {
      title = '';
      buttonVisibility = true;
      buttonEnabled = true;
      stringArray = ['0'];
    });
    futureNumber = fetchNumber();
  }

  Future<ApiNumber> fetchNumber() async {
    final response = await http.get('https://us-central1-ss-devops.cloudfunctions.net/rand?min=1&max=300');
    if(response.statusCode == 200){
      return ApiNumber.fromJson(json.decode(response.body));
    }else{
      setState(() {
        title = 'Erro!';
        buttonVisibility = true;
        buttonEnabled = false;
        stringArray = ['5','0','2'];
      });
      return null;
    }
  }

  String  _validarNumero(String value){
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if(value.length == 0){
      return 'Digite o número';
    }else if (!regExp.hasMatch(value)){
      return 'Digite apenas números';
    }
    return null;
  }

  void showFontSizePickerDialog() async {
    final selectedFontSize = await showDialog<double>(
      context: context,
      builder: (context) => FontSizeDialog(initialFontSize: fontSize,color: mainColor,)
    );

    if(selectedFontSize != null){
      setState(() {
        fontSize = selectedFontSize;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Qual é o número?'),
        backgroundColor: mainColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.format_size),
            tooltip: 'Tamanho',
            onPressed: showFontSizePickerDialog
          ),
          IconButton(
            icon: Icon(Icons.palette),
            tooltip: 'Cor',
            onPressed: () {
              showDialog(
                context: context,
                child: AlertDialog(
                  title: Text('Escolha a cor desejada!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: pickerColor,
                      onColorChanged: changeColor,
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: (){
                        setState(() {
                          mainColor = pickerColor;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),

                  FutureBuilder(
                    future: futureNumber,
                    builder: (context, snapshot){
                      if (snapshot.hasData){
                        rightNumber = snapshot.data.value.toString();
                      }
                      return Text('');
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: stringArray.map((letter) => Number(
                      number: letter,
                      fontSize: fontSize,
                      color: mainColor,
                    )).toList()
                  ),
                  
                  Visibility(
                    child: RaisedButton(
                      child: Text('Nova Partida'),
                      onPressed: (){generateNewNumber();},
                    ),
                    visible: buttonVisibility,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Form(
                key: formKey,
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Digite seu palpite',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: mainColor,
                                width: 4,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(0,0,0, 0.3),
                                width: 4,
                              ),
                            ),
                          ),
                          controller: textController,
                          validator: _validarNumero,
                          cursorColor: mainColor,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          style: TextStyle(fontSize: 25),
                          onChanged: (v){
                            palpite = v;
                          },
                        ),
                      ),
                      width: screenWidth - 108,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RaisedButton(
                        child: Text('ENVIAR'),
                        onPressed: !buttonEnabled ? null :
                        (){
                          if(formKey.currentState.validate()){
                            sendNumber();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
