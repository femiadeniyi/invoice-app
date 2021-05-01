import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:invoice_app/model/invoice_item.dart';
import 'package:invoice_app/structs/Shift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week_of_year/week_of_year.dart';


class InvoiceForm extends StatefulWidget {
  @override
  _InvoiceFormState createState() => _InvoiceFormState();
}

class _InvoiceFormState extends State<InvoiceForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _textEditingController = TextEditingController();

  List<Shift> shifts = Shift.defaultValues();
  Shift shift = Shift.defaultValues().first;

  setUnitsSelection(){
    setState(() {
      shift = shifts.where((element) => element.name == shift.name).single;
    });

  }

  _selectDate(context) async {
    var selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2022));
    if (selectedDate != null) {
      var dateStr = DateFormat("dd/M/yy").format(selectedDate);
      print("data $dateStr");
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
                    onSaved: (value) {
                      shift.date = value!;
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
                    shift.name = value!;
                  },
                  isExpanded: true,
                  value: shift.name,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  onChanged: (String? newValue) {
                    setState(() {
                      shift.name = newValue!;
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
                    setState(() {
                      shift.value = value!;
                    });
                  },
                  isExpanded: true,
                  value: shift.value,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  onChanged: (String? newValue) {
                    print("you11");
                    // shift.value = newValue!;
                  },
                  items: shift.options
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
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          showDialog<bool>(
                              context: context,
                              builder: (builder){
                                return AlertDialog(
                                  title: Text('Tax Confirmation Statement'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text('I confirm I am responsible for paying my NI and Tax'),
                                        Text('Please confirm'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Approve'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                  ],
                                );
                              }
                          ).then((value){
                            if( value! == true ){
                              shift.created_at = DateTime.now().toUtc().toString();
                              DateTime now = DateTime.now();
                              now.add(Duration(days: 1));
                              shift.group = "${now.year}${now.weekOfYear}";
                              shift.addShift(FirebaseAuth.instance.currentUser!.uid)
                                  .then((value){
                                Navigator.of(context).pop();
                              })
                                  .catchError((onError){
                                final snackBar = SnackBar(content: Text('Error contact support'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              });
                            }
                          })
                          .onError((error, stackTrace){
                            print("error $error");
                          });
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
