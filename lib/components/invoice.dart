
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoice_app/components/invoice_form.dart';
import 'package:invoice_app/model/invoice_item.dart';
import 'package:invoice_app/structs/timesheet_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Invoice extends StatefulWidget {

  @override
  InvoiceState createState() => InvoiceState();
}

class InvoiceState extends State<Invoice> {

  List<InvoiceItem> _invoiceItems = [];
  bool _initialized = false;
  bool _error = false;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  void initializeFlutterFire() async {
    bool isProd = const bool.fromEnvironment("dart.vm.product");
    if(!isProd){
      FirebaseFunctions.instance.useFunctionsEmulator(origin: "http://localhost:5001");
    }
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  initState(){

    initializeFlutterFire();
    _setInvoices();
    super.initState();
  }

  _downloadInvoices()async{
    if(_initialized){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var existingInvoices = prefs.getStringList("invoices") ?? [];
      var invoices = existingInvoices.map((e) => jsonDecode(e)).toList();

      if(invoices.length == 0){
        return null;
      };

      var payload = {
        "items":invoices,
      };

      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('helloWorld');
      final results = await callable(jsonEncode(payload));

      String link = results.data["link"];

      if (link != null){
        Clipboard.setData(new ClipboardData(text: link));
        print(link);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invoice link received. Open in browser."))
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Sorry something went wrong"))
        );
      }
    }
  }

  _setInvoices({@optionalTypeArgs invoiceItem})async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var existingInvoices = prefs.getStringList("invoices") ?? [];

    var invoiceItems = existingInvoices.map((e) {
      var json = jsonDecode(e);
      return InvoiceItem.fromJson(json);
    }).toList();

    if(invoiceItem != null){
      invoiceItems.add(invoiceItem);
      var newInvoiceItems = invoiceItems.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList("invoices", newInvoiceItems);
    }

    setState(() {
      _invoiceItems = invoiceItems;
    });
  }


  _openFormDialog()async {
    InvoiceItem invoiceItem = await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context){
        return InvoiceForm();
      }
    ));

    await _setInvoices(invoiceItem: invoiceItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        child: TimesheetList(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // FloatingActionButton.extended(
          //   onPressed: (){_downloadInvoices();},
          //   label: Text("Download"),
          //   icon: Icon(Icons.download_outlined),
          //   backgroundColor: Colors.pink,
          // ),
          // SizedBox(height: 8.0),
          FloatingActionButton.extended(
            onPressed: (){_openFormDialog();},
            label: Text("Add to timesheet"),
            icon: Icon(Icons.add),
            backgroundColor: Colors.pink,
          ),
        ],
      )
    );
  }
}
