import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:invoice_app/model/invoice_item.dart';

class InvoiceForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textEditingController = TextEditingController();
  String shift;
  double units;
  String description;
  double rate;

  _selectDate(context) async {
    var selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2022));
    if (selectedDate != null) {
      var dateStr = DateFormat("dd/M/yy").format(selectedDate);
      _textEditingController..text = dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice Form"),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  onSaved: (value){shift=value;},
                    decoration: const InputDecoration(labelText: "Shift"),
                    controller: _textEditingController,
                    onTap: () {
                      _selectDate(context);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please complete';
                      }
                      return null;
                    }),
                TextFormField(
                    onSaved: (value){units=double.parse(value);},
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration:
                        const InputDecoration(labelText: "Unit or Hours"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please complete';
                      }
                      return null;
                    }),
                TextFormField(
                  onSaved: (value){rate=double.parse(value);},
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    hintText: 'Rate',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please complete';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  onSaved: (value){description=value;},
                  decoration: const InputDecoration(
                    labelText: "Work Description",
                    hintText:
                        'e.g - Client A @ Example Address, e.g - Gardening services',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please complete';
                    }
                    return null;
                  },
                ),
                Padding(padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          var invoiceItem = new InvoiceItem(description, shift, units, rate);
                          // If the form is valid, display a Snackbar.
                          Navigator.of(context).pop(invoiceItem);
                        }
                      },
                      child: Text("Submit")
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
