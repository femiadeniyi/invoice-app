import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Shift {
  String date;
  String name;
  double rate;
  String unit;
  String postcode;
  String value;
  String group;
  bool submitted;
  List<String> options;
  String created_at;

  Shift({
    required this.name,
    required this.rate,
    required this.unit,
    required this.postcode,
    required this.date,
    required this.options,
    required this.value,
    required this.group,
    required this.submitted,
    required this.created_at
  });

  Future<void> addShift(String userId) {
    // final now = DateTime.now();
    // now.add(Duration(days: 1));
    // group = "${now.year}${now.weekOfYear}";
    CollectionReference users =
        FirebaseFirestore.instance.collection('springcare-users');
    var shift_col = users.doc(userId).collection("shift");
    return shift_col.add(this.toJson()).catchError((onError) {
      print("whatup $onError");
      throw (onError);
    });
  }

  static List<Shift> defaultValues() {
    return [
      Shift(
          created_at: "",
          group: "",
          submitted: false,
          value: '1',
          date: '',
          rate: 5,
          unit: '',
          postcode: '',
          name: "Domiciliary 30min",
          options: ["1", "2", "3", "4", "5", "6"]),
      Shift(
          created_at: "",
          group: "",
          submitted: false,
          value: '1',
          date: '',
          rate: 7,
          unit: '',
          postcode: '',
          name: "Domiciliary 45min",
          options: ["1", "2", "3", "4", "5", "6"]),
      Shift(
          created_at: "",
          group: "",
          submitted: false,
          value: '1',
          date: '',
          rate: 9,
          unit: '',
          postcode: '',
          name: "Domiciliary 60min",
          options: ["1", "2", "3", "4", "5", "6"]),
      Shift(
          created_at: "",
          group: "",
          submitted: false,
          value: '1',
          date: '',
          rate: 108,
          unit: '',
          postcode: '',
          name: "Long Shift 12 Hours",
          options: ["1"]),
      Shift(
          created_at: "",
          group: "",
          submitted: false,
          value: '1 hour',
          date: '',
          rate: 9,
          unit: '',
          postcode: '',
          name: "Waking Night",
          options: [
            "1 hour",
            "2 hours",
            "3 hours",
            "4 hours",
            "5 hours",
            "6 hours",
            "7 hours",
            "8 hours",
            "9 hours",
            "10 hours",
            "11 hours",
            "12 hours"
          ]),
      Shift(
          created_at: "",
          group: "",
          submitted: false,
          value: '1 day',
          date: '',
          rate: 85.71,
          unit: '',
          postcode: '',
          name: "Live in Care Weekly",
          options: [
            "1 day",
            "2 days",
            "3 days",
            "4 days",
            "5 days",
            "6 days",
            "7 days"
          ]),
      Shift(
          created_at: "",
          group: "",
          submitted: false,
          value: '1 day',
          date: '',
          rate: 150,
          unit: '',
          postcode: '',
          name: "Live in Care Daily",
          options: ["1 day"]),
    ];
  }

  String valueToNum(){
    var num_string = this.value.replaceAll(new RegExp(r'\D'),'');
    var sum = "${(double.parse(num_string)*rate).toDouble().toStringAsFixed(2)}";
    print("$sum");
    return sum.toString();
  }

  Shift.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        date = json["date"],
        rate = json["rate"],
        postcode = json["postcode"],
        options = (json["options"] as List<dynamic>).map((e) => e.toString()).toList(),
        value = json["value"],
        submitted = json["submitted"],
        group = json["group"],
        created_at = json["created_at"],
      unit = json["unit"];

  Map<String, dynamic> toJson() => {
        'name': name,
        'rate': rate,
        'date': date,
        'postcode': postcode,
        'unit': unit,
        'options': options,
        'value':value,
        'submitted':submitted,
        'group':group,
        'created_at':created_at,
  };

  String toString() {
    return "{name:$name,rate:$rate,date:$date,postcode:$postcode,unit:$unit,options:$options,value:$value},group:$group,submitted:$submitted,created_at:$created_at";
  }
}
