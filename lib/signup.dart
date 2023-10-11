import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _registerPassController = TextEditingController();
  final _registerPassController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 50.0),
          TextFormField(
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Username',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              final regex = RegExp(r'^(?=.*[a-zA-Z]{3,})(?=.*\d{3,})');
              if (!regex.hasMatch(value)) {
                return 'Username is invalid';
              }
              return null;
            },
          ),
          const SizedBox(height: 15.0),
          TextFormField(
            controller: _registerPassController,
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Password',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            obscureText: true,
          ),
          const SizedBox(height: 15.0),
          TextFormField(
            controller: _registerPassController2,
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Confirm Password',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              if (value != _registerPassController.text) {
                return 'Confirm Password doesn\'t match Password';
              }
              return null;
            },
            obscureText: true,
          ),
          const SizedBox(height: 15.0),
          TextFormField(
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Email Address',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          const SizedBox(height: 15.0),
          OverflowBar(alignment: MainAxisAlignment.end, children: <Widget>[
            ElevatedButton(
              child: const Text('SIGN UP'),
              onPressed: () {
                // Navigator.pop(context);
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                }
              },
            ),
          ])
        ],
      ),
    ));
  }
}
