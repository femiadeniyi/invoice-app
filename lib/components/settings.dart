import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String invoiceFor;
  String invoiceFrom;

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
            child: Column(
              children: [
                TextFormField(
                    onSaved: (value) {
                      invoiceFor = value;
                    },
                    decoration: const InputDecoration(
                        labelText: "Who is the invoice for?"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please complete';
                      }
                      return null;
                    }),
                TextFormField(
                    onSaved: (value) {
                      invoiceFrom = value;
                    },
                    decoration: const InputDecoration(
                        labelText: "Who is the invoice from?"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please complete';
                      }
                      return null;
                    }),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _saveSettings();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Settings save")));
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
