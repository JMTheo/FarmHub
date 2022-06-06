import 'package:cloud_firestore/cloud_firestore.dart';

class Farm {
  String? id;
  final String name;
  final String? fullName;
  final DocumentReference? owner;
  final String? canAccess;

  Farm({
    this.id,
    this.owner,
    this.canAccess,
    this.fullName,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (fullName != null) 'fullName': fullName,
        if (id != null) 'id': id,
        if (owner != null) 'owner': owner,
        if (canAccess != null) 'canAccess': canAccess,
      };

  static Farm fromJson(Map<String, dynamic> json) => Farm(
        id: json['id'],
        name: json['name'],
        owner: json['owner'],
        canAccess: json['canAccess'],
        fullName: json['fullName'],
      );
  static Map fromJsonRef(Map<String, dynamic> json) => {'owner': json['user']};
}
