import './generic_sensor.dart';

class Ground {
  String? id;
  String farm; //Ref
  final String type;
  final String region;
  final String specie;
  final String? urlImg;
  final List<GenericSensor>? soilHumidity; //Ref
  final List<GenericSensor>? temperature; //Ref
  final List<GenericSensor>? water; //Ref

  Ground({
    this.id = '',
    required this.farm,
    required this.specie,
    required this.type,
    required this.region,
    this.urlImg,
    this.soilHumidity,
    this.temperature,
    this.water,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'specie': specie,
        'farm': farm,
        'region': region,
        if (id != null) 'id': id,
        if (soilHumidity != null) 'soilHumidity': soilHumidity,
        if (temperature != null) 'temperature': temperature,
        if (water != null) 'water': water,
      };

  static Ground fromJson(Map<String, dynamic> json) => Ground(
        id: json['id'],
        type: json['type'],
        farm: json['farm'],
        region: json['region'],
        urlImg: json['urlImg'],
        specie: json['specie'],
        soilHumidity: json['soilHumidity'],
        temperature: json['temperature'],
        water: json['water'],
      );
}
