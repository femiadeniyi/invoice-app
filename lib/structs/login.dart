import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:invoice_app/components/invoice.dart';

import '../main.dart';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  Future<String?> _authUser(String email, String pass, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email:email,
          password: pass
      );
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder:
              (_) => MyHomePage(title: 'Create Invoice'),
          )
      );
      print(userCredential);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                    onSaved: (value) {
                      email = value!;
                    },
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete';
                      }
                      return null;
                    }),
                TextFormField(
                    onSaved: (value) {
                      password = value!;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete';
                      }
                      return null;
                    }),
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _authUser(email, password, context);
                          //
                          // var invoiceItem =
                          //     new InvoiceItem(description, shift, units, rate);
                          // // If the form is valid, display a Snackbar.
                          // Navigator.of(context).pop(invoiceItem);
                        }
                      },
                      child: Text("Submit")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
