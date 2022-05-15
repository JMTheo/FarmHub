import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';

import 'package:mobx/mobx.dart';
part 'controller.g.dart';

//A cada alteração no Observable rodar esse comando no terminal
// flutter packages pub run build_runner build

class Controller = ControllerBase with _$Controller;

abstract class ControllerBase with Store {
  ControllerBase();
  //tipo da variavel |Nome Var   | Valor a ser iniciado
  @observable
  double temperatura = 28;
  @observable
  bool estadoLampada = false;
  @observable
  int umidadeSolo = 80;
  @observable
  int umidadeAr = 99;
  @observable
  int luminosidade = 100; //980 escuro - mais iluminado tende a 0

  //Variaveis para se conectar ao broker
  /*String broker = '127.0.0.1';
  int port = 3000;
  String clientIdentifier = 'flutter-mobile';
  String topic = 'iot/casa';*/

  //Função a ser executada
  @action
  atualizarDados(int umi, int umiS, double temp, int luz) {
    umidadeAr = umi;
    umidadeSolo = umiS;
    temperatura = temp;
    luminosidade = luz;
  }

  @action
  mudarEstadoLampada() {
    String msg = '';
    estadoLampada = !estadoLampada;

    if (estadoLampada) {
      msg = 'lj';
    } else {
      msg = 'dj';
    }
    //enviarMensagem(msg);
  }

  @action
  acionarAgua() {
    BotToast.showLoading(
        duration: const Duration(seconds: 1),
        onClose: () {
          BotToast.showText(
              text: 'Enviando sinal para acionar a água',
              align: const Alignment(0, 0),
              animationDuration: const Duration(seconds: 1),
              textStyle: const TextStyle(fontSize: 25.0));
        });
    //enviarMensagem('a');
  }
}
