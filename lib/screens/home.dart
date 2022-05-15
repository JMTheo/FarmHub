import 'package:flutter/material.dart';

import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:automacao_horta/components/bottom_card.dart';
import 'package:automacao_horta/components/card_plant.dart';

import '../controller/controller.dart';

final controller = Controller();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Automação da horta')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Observer(builder: (_) {
                    return CardPlant(
                      urlImg: 'assets/img/hortela.png',
                      apelidoPlanta: 'Cleitinho',
                      especiePlanta: 'Hortelã',
                      estadoLampada: controller.estadoLampada,
                      umidadeDoSolo: 20,
                      functionA: controller.acionarAgua,
                      functionL: controller.mudarEstadoLampada,
                    );
                  }),
                  CardPlant(
                    urlImg: 'assets/img/planta-carnivora.png',
                    apelidoPlanta: 'Maria',
                    especiePlanta: 'Planta Carnívora',
                    estadoLampada: controller.estadoLampada,
                    umidadeDoSolo: 15,
                  ),
                  CardPlant(
                    urlImg: 'assets/img/tomate.png',
                    apelidoPlanta: 'Matilda',
                    especiePlanta: 'Tomate',
                    estadoLampada: controller.estadoLampada,
                    umidadeDoSolo: 50,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Observer(builder: (_) {
                  return BottomCard(
                    titulo: 'Temperatura \ndo Ambiente',
                    valor: '${controller.temperatura}ºC',
                  );
                }),
                Observer(builder: (_) {
                  return BottomCard(
                    titulo: 'Umidade \ndo Ar',
                    valor: '${controller.umidadeAr}%',
                  );
                }),
                Observer(builder: (_) {
                  return BottomCard(
                    titulo: 'Luminosidade',
                    valor: '${controller.luminosidade}',
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
