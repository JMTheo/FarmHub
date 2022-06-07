import 'package:cloud_firestore/cloud_firestore.dart';

class GenericSensor {
  Timestamp? date;
  dynamic value;

  GenericSensor({this.date, this.value});

  // static GenericSensor fromJson(Map<String, dynamic> json) => GenericSensor(
  //       date: json['date'],
  //       value: json['value'],
  //     );
  GenericSensor.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['value'] = value;
    return data;
  }
}
