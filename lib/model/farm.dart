import 'package:cloud_firestore/cloud_firestore.dart';

class Farm {
  String? id;
  final String name;
  final DocumentReference? owner;
  final String? canAccess;

  Farm({
    this.id,
    this.owner,
    required this.name,
    this.canAccess,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (id != null) 'id': id,
        if (owner != null) 'owner': owner,
        if (canAccess != null) 'canAccess': canAccess,
      };

  static Farm fromJson(Map<String, dynamic> json) => Farm(
        id: json['id'],
        name: json['name'],
        owner: json['owner'],
        canAccess: json['canAccess'],
      );
  static Map fromJsonRef(Map<String, dynamic> json) => {'owner': json['user']};
}
