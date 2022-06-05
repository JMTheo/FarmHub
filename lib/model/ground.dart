class Ground {
  String id;
  final String name;
  final String type;
  final List<dynamic> farm; //Ref
  final List<dynamic>? soilHumidity; //Ref
  final List<dynamic>? temperature; //Ref
  final List<dynamic>? water; //Ref

  Ground({
    this.id = '',
    required this.farm,
    required this.name,
    required this.type,
    this.soilHumidity,
    this.temperature,
    this.water,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'name': name,
        'farm': farm,
        'soil_humidity': soilHumidity,
        'temperature': temperature,
        'water': water,
      };

  static Ground fromJson(Map<String, dynamic> json) => Ground(
        id: json['id'],
        type: json['type'],
        name: json['name'],
        farm: json['farm'],
        soilHumidity: json['soil_humidity'],
        temperature: json['temperature'],
        water: json['water'],
      );
}
