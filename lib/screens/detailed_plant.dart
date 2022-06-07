import 'package:automacao_horta/model/generic_sensor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/bottom_card.dart';
import '../controller/iot_controller.dart';

class DetailedPlantPage extends StatefulWidget {
  final String farmID;
  final String name;
  final Stream<QuerySnapshot<Object?>> stream;

  // ignore: use_key_in_widget_constructors
  const DetailedPlantPage(
      {required this.farmID, required this.name, required this.stream});

  @override
  _DetailedPlantPageState createState() => _DetailedPlantPageState();
}

class _DetailedPlantPageState extends State<DetailedPlantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Fazenda - ${widget.name}'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            //TODO: Arrumar funções de acionamento
            //TODO: DEIXAR DINÂMICO O CARD
            //TODO: CRUD ZONA
            //TODO: REESTRURAR CARD ZONA
            //TODO: LISTAR HISTÓRICO
            child: StreamBuilder<QuerySnapshot>(
                stream: widget.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Erro ao receber dados: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Text('Não há ZONAS cadastradas ao seu perfil');
                  }

                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot docSnap =
                            snapshot.data!.docs[index];
                        List<GenericSensor> temp = (docSnap['temperature']
                                as List)
                            .map((itemTemp) => GenericSensor.fromJson(itemTemp))
                            .toList();
                        print(temp);
                        print(docSnap['temperature'][0]['value']);
                        // final temperature = docSnap['temperature']
                        //     as List<Map<String, dynamic>>;
                        // temperature.map((temp) {
                        //   print('$index - Temperature ${temp['value']}');
                        // });

                        return Card(
                            margin: const EdgeInsets.all(10.0),
                            child: Text('url: ${docSnap['temperature']}'));
                      });
                }),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Obx(() => BottomCard(
                      titulo: 'Temperatura \ndo Ambiente',
                      valor: '${IoTController.to.temperatura.value}ºC',
                    )),
                Obx(() => BottomCard(
                      titulo: 'Umidade \ndo Ar',
                      valor: '${IoTController.to.umidadeAr.value}%',
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
