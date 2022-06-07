import './generic_sensor.dart';

class Ground {
  String? id;
  final String name;
  final String type;
  final String urlImg;
  final String region;
  final String specie;
  final String farm; //Ref
  final List<GenericSensor>? soilHumidity; //Ref
  final List<GenericSensor>? temperature; //Ref
  final List<GenericSensor>? water; //Ref

  Ground({
    this.id = '',
    required this.farm,
    required this.name,
    required this.type,
    required this.region,
    required this.urlImg,
    required this.specie,
    this.soilHumidity,
    this.temperature,
    this.water,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'farm': farm,
        if (id != null) 'id': id,
        if (soilHumidity != null) 'soilHumidity': soilHumidity,
        if (temperature != null) 'temperature': temperature,
        if (water != null) 'water': water,
      };

  static Ground fromJson(Map<String, dynamic> json) => Ground(
        id: json['id'],
        type: json['type'],
        name: json['name'],
        farm: json['farm'],
        region: json['region'],
        urlImg: json['urlImg'],
        specie: json['specie'],
        soilHumidity: json['soilHumidity'],
        temperature: json['temperature'],
        water: json['water'],
      );
}
