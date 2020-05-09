import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String userName;
  final _formKey =GlobalKey<FormState>();
  submit() {
  _formKey.currentState.save();
  Navigator.pop(context, userName);
}
  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar: header(context, title: "set up your profile"),
      body: ListView(
        children: <Widget>[
          Container(
            height: 50,
            width: 350,
              child: Form(
              key: _formKey,
                  child: TextFormField(
                    onSaved: (val)=> userName = val,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "username",
                labelStyle: TextStyle(fontSize: 15.0),
                hintText: "must have 8 char"),
          ))),
          GestureDetector(
            onTap: submit(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(7.0)
              ),
              child: Center(
                child: Text("Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
