import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(10.0),
        child: formWidget(),
      ),
    );
  }

  Widget formWidget() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/logo.png',
            width: 300,
          ),
          emailField(),
          passwordField(),
          Container(margin: EdgeInsets.only(top: 25.0)),
          Text(
            error,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          submitButton(),
        ],
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: "Email Address", hintText: "you@example.com"),
      onSaved: (String value) {
        this.email = value;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: "Password", hintText: "password"),
      onSaved: (String value) {
        this.password = value;
      },
    );
  }

  Widget submitButton() {
    return RaisedButton(
      color: Colors.lightBlue,
      textColor: Colors.white,
      child: Text("Submit"),
      onPressed: () async {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          try {
            UserCredential userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: this.email, password: this.password);
            if (userCredential.user != null) {
              Navigator.pop(context);
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              print('No user found for that email.');
              setState(() {
                error = 'Inavlid Credentials';
              });
            } else if (e.code == 'wrong-password') {
              print('Wrong password provided for that user.');
              setState(() {
                error = 'Inavlid Credentials';
              });
            } else {
              setState(() {
                error = 'Inavlid Credentials';
              });
              print('Else');
            }
          }
        }
      },
    );
  }
}
