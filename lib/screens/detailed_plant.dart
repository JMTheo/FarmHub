import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/bottom_card.dart';
import '../components/card_plant.dart';
import '../controller/iot_controller.dart';

class DetailedPlantPage extends StatefulWidget {
  final String farmID;

  const DetailedPlantPage({required this.farmID});

  @override
  _DetailedPlantPageState createState() => _DetailedPlantPageState();
}

class _DetailedPlantPageState extends State<DetailedPlantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Fazenda - ${widget.farmID}'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Obx(() => CardPlant(
                        urlImg: 'assets/img/fruits/apple.png',
                        apelidoPlanta: 'Cleitinho',
                        especiePlanta: 'Hortelã',
                        estadoLampada: IoTController.to.estadoLampada.value,
                        umidadeDoSolo: 20,
                        //TODO: Arrumar funções de acionamento
                        //TODO: DEIXAR DINÂMICO O CARD
                        //TODO: CRUD ZONA
                        //TODO: REESTRURAR CARD ZONA
                        //TODO: LISTAR HISTÓRICO
                        //functionA: IoTController.to.acionarAgua(),
                        // functionL: IoTController.to.mudarEstadoLampada(),
                      )),
                  Obx(() => CardPlant(
                        urlImg: 'assets/img/planta-carnivora.png',
                        apelidoPlanta: 'Maria',
                        especiePlanta: 'Planta Carnívora',
                        estadoLampada: IoTController.to.estadoLampada.value,
                        umidadeDoSolo: 15,
                      )),
                  Obx(() => CardPlant(
                        urlImg: 'assets/img/tomate.png',
                        apelidoPlanta: 'Matilda',
                        especiePlanta: 'Tomate',
                        estadoLampada: IoTController.to.estadoLampada.value,
                        umidadeDoSolo: 50,
                      )),
                ],
              ),
            ),
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
