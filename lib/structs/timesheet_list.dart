import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoice_app/structs/Shift.dart';

class TimesheetList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('springcare-users');
    var data = users.doc(userId).collection("shift");

    return StreamBuilder<QuerySnapshot>(
      stream: data.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No invoices yet. Click to add"),
          );
        }

        return new ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return new ListTile(
              leading: new Text(document.data()!['date']),
              title: new Text("${document.data()!["value"]} | ${Shift.fromJson(document.data()!).valueToNum()}"),
              subtitle: new Text(document.data()!['name']),
              trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {
                data.doc(document.id)
                    .delete()
                    .catchError((onError){
                      final snackBar = SnackBar(content: Text('Error contact support'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
              }),
            );
          }).toList(),
        );
      },
    );
  }
}
