import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';

void main() {
  runApp(GuessApp());
}

class GuessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess my number',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GuessPage(title: "Guess my number"),
    );
  }
}

class GuessPage extends StatefulWidget {
  GuessPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GuessPageState createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage> {
  TextEditingController _numberController = new TextEditingController();
  final _form = GlobalKey<FormState>();
  String _message = "";
  String _hint = "";

  Random random = new Random();
  int _randomNumber;

  _GuessPageState() {
    _randomNumber = random.nextInt(100) + 1;
  }

  void _guessNumber(BuildContext context) {
    setState(() {
      if (!_form.currentState.validate()) {
        _message = "";
        return;
      }

      _message = "You tried " + int.parse(_numberController.text).toString();

      if (_randomNumber < int.parse(_numberController.text)) {
        _hint = "Try lower!";
      } else if (_randomNumber > int.parse(_numberController.text)) {
        _hint = "Try higher!";
      } else {
        _hint = "You guessed right. Congrats!";
        _showAlertDialog(context);
      }
    });
  }

  void _showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget tryAgainButton = FlatButton(
      child: Text("Try again!"),
      onPressed: () {
        _randomNumber = random.nextInt(100) + 1;
        Navigator.of(context).pop();
      },
    );
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("You guessed right"),
      content: Text("It was $_randomNumber"),
      actions: [
        tryAgainButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Form(
        key: _form,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                    "I'm thinking of a number between 1 and 100.",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30.0),
                child: Text(
                  "It's your turn to guess my number!",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey,
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Try a number!",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 23.0,
                            fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _numberController,
                        validator: (text) {
                          if (text.isEmpty || int.tryParse(text) == null) {
                            return "Please enter a number!";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30.0),
                      child: FlatButton(
                        onPressed: () {_guessNumber(context);},
                        child: Text(
                          'Guess',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 25.0),
                child: Text(
                  '$_message',
                  style: Theme.of(context).textTheme.headline5.apply(color: Colors.black54),
                ),
              ),
              Text(
                '$_hint',
                style: Theme.of(context).textTheme.headline5.apply(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
