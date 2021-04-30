import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:invoice_app/model/invoice_item.dart';
import 'package:invoice_app/structs/Shift.dart';

class InvoiceForm extends StatefulWidget {
  @override
  _InvoiceFormState createState() => _InvoiceFormState();
}

class _InvoiceFormState extends State<InvoiceForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _textEditingController = TextEditingController();

  late String shift;
  String units = "1";
  late String description;
  late double rate;


  List<String> units_selection = [];
  var shift_values = Shift.defaultValues().map((e) => e.name).toList();


  setUnitsSelection(){
    switch (name) {
      case "Domil 60":
      case "Domil 45":
      case "Domil 30": {
        setState(() {
          units = "1";
          units_selection = ["1","2","3","4","5","6"];
        });
        break;
      }
      case "Long Shift": {
         setState(() {
           units = "1 - 12 Hours";
           units_selection = ["1 - 12 Hours"];
         });
        break;
      }
      case "Waking Night": {
        setState(() {
          units = "1";
          units_selection = ["1","2","3","4","5","6","7","8","9","10","11","12"];
        });
        break;
      }
      case "Live in Weekly": {
        setState(() {
          units = "1 day";
          units_selection = ["1 day","2 days","3 days","4 days","5 days","6 days","7 - 1 Week"];
        });
        break;
      }
      case "Live in Daily": {
        print("hey");
        setState(() {
          units = "1";
          units_selection = ["1"];
        });
        break;
      }
    }
  }

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

  String name = Shift.defaultValues().first.name;

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
                    onSaved: (value) {
                      shift = value!;
                    },
                    decoration: const InputDecoration(labelText: "Date"),
                    controller: _textEditingController,
                    onTap: () {
                      _selectDate(context);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete';
                      }
                      return null;
                    }),
                DropdownButtonFormField<String>(
                  onSaved: (value){
                    name = value!;
                  },
                  isExpanded: true,
                  value: name,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  onChanged: (String? newValue) {
                    print("you");
                    setState(() {
                      name = newValue!;
                    });
                    setUnitsSelection();
                  },
                  items: Shift.defaultValues()
                      .map<DropdownMenuItem<String>>((Shift value) {
                    return DropdownMenuItem<String>(
                      value: value.name,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField<String>(
                  onSaved: (value){
                    units = value!;
                  },
                  isExpanded: true,
                  value: units,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  onChanged: (String? newValue) {
                    print("you");
                  },
                  items: units_selection
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                Padding(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                      onPressed: () {
                        // if (_formKey.currentState!.validate()) {
                        //   _formKey.currentState!.save();
                        //   var invoiceItem =
                        //       new InvoiceItem(description, shift, units, rate);
                        //   // If the form is valid, display a Snackbar.
                        //   Navigator.of(context).pop(invoiceItem);
                        // }
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
