class Schedule {
  String? id;
  List<Map<String, dynamic>> data;
  final String farmID; //Ref

  Schedule({
    this.id = '',
    required this.data,
    required this.farmID,
  });

  Map<String, dynamic> toJson() => {
        'data': data,
        'farmID': farmID,
        if (id != null) 'id': id,
      };

  static Schedule fromJson(Map<String, dynamic> json) => Schedule(
        id: json['id'],
        farmID: json['farmID'],
        data: json['data'],
      );
}
