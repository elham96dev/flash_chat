import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/rounded_button.dart';
import '../constants.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
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
              color: Colors.blueAccent,
              title: 'Register',
              onPressed: () async {
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  if (newUser.user != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                } on FirebaseAuthException catch (e) {
                  String message = '';
                  if (e.code == 'weak-password') {
                    message = 'The password is too weak.';
                  } else if (e.code == 'email-already-in-use') {
                    message = 'The account already exists for that email.';
                  } else {
                    message = e.message ?? 'Registration failed.';
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
