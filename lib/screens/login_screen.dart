import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

import '../components/rounded_button.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance; // Firebase Auth
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(height: 48.0),
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(height: 24.0),
            RoundedButton(
              color: Colors.lightBlueAccent,
              title: 'Log In',
              onPressed: () async {
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  if (user.user != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                } on FirebaseAuthException catch (e) {
                  String message = '';
                  if (e.code == 'user-not-found') {
                    message = 'No user found for that email.';
                  } else if (e.code == 'wrong-password') {
                    message = 'Wrong password provided.';
                  } else {
                    message = e.message ?? 'Login failed.';
                  }
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(message)));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
