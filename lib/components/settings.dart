import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  late String invoiceFor;
  late String invoiceFrom;

  _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("invoiceFor", invoiceFor);
    prefs.setString("invoiceFrom", invoiceFrom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16),
            child:                 Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                  width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {

                    },
                    child: Text("Contact Support")),
              ),
            )

          ),
        ),
      ),
    );
  }
}
