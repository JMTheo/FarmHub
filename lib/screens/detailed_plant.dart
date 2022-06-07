import 'package:automacao_horta/enums/FarmTypeOperation.dart';
import 'package:automacao_horta/modal/add_ground_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/iot_controller.dart';

import '../components/bottom_button.dart';
import '../components/bottom_card.dart';
import '../components/card_plant.dart';

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
            flex: 5,
            //TODO: Arrumar funções de acionamento
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
                        //TODO: Ajustar para pegar dados de histórico
                        // List<GenericSensor> tempList = (docSnap['temperature']
                        //         as List)
                        //     .map((itemTemp) => GenericSensor.fromJson(itemTemp))
                        //     .toList();
                        //print(tempList.toString());
                        return CardPlant(
                          specie: docSnap['specie'],
                          region: docSnap['region'],
                          umidadeDoSolo: 10,
                          id: docSnap.id,
                          groundObj: docSnap,
                        );
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
          BottomButton(
            //TODO: AJUSTAR NOME DO BOTÃO (ASSEMBLEIA)
            buttonTitle: 'Adicionar Região',
            onTap: () async {
              await addGroundModal('Adicionar Região', context,
                  FarmTypeOperation.create, widget.farmID);
            },
          ),
        ],
      ),
    );
  }
}
