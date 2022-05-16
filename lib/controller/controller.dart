import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:mqtt_client/mqtt_client.dart'; // as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:mobx/mobx.dart';
part 'controller.g.dart';

//A cada alteração no Observable rodar esse comando no terminal
// flutter packages pub run build_runner build

class Controller = ControllerBase with _$Controller;

abstract class ControllerBase with Store {
  ControllerBase() {
    _connect();
  }

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
  String broker = '192.168.3.11';
  int port = 3000;
  String clientIdentifier = 'flutter-mobile';
  String topic = 'iot/casa';

  late MqttServerClient client;
  late MqttConnectionState connectionState;
  late StreamSubscription subscription;

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
    enviarMensagem(msg);
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
    enviarMensagem('a');
  }

  void enviarMensagem(String msg) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    print('Enviando:: <<<< $msg >>>>');
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  /*
    Conecta no servidor MQTT à partir dos dados configurados nos atributos desta classe (broker, port, etc...)
  */
  void _connect() async {
    client = MqttServerClient(broker, '');
    client.port = port;
    client.keepAlivePeriod = 30;
    client.onDisconnected = _onDisconnected;
    client.onSubscribed = subscribeToTopic;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean()
        .keepAliveFor(30)
        .withWillQos(MqttQos.atMostOnce);
    print('[MQTT client] MQTT client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print(e);
      _disconnect();
    }

    /// Checando conexao
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      print('DEBUG::Broker client connected');
      subscribeToTopic(topic);
    } else {
      print(
          'DEBUG::ERRO Falha com a conexão com o broker - desconectando, estado atual: ${client.connectionStatus?.state}');
      client.disconnect();
    }
    client.updates?.listen((dynamic c) {
      final MqttPublishMessage recMess = c[0].payload;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      dynamic parsed = json.decode(pt);
      int tempUmidadeAr = parsed['umi'];
      double tempTemperatura = parsed['temp'];
      int tempUmidadeSolo = parsed['umi_s'];
      int tempLuminosidade = parsed['luz'];
      atualizarDados(
          tempUmidadeAr, tempUmidadeSolo, tempTemperatura, tempLuminosidade);

      print('umi: ${parsed['umi']}');
    });
  }

  /*
  Desconecta do servidor MQTT
   */
  void _disconnect() {
    print('[MQTT client] _disconnect()');
    client.disconnect();
    _onDisconnected();
  }

  /*
  Executa algo quando desconectado, no caso, zera as variáveis e imprime msg no console
   */
  void _onDisconnected() {
    print('[MQTT client] _onDisconnected');
    connectionState = client.connectionState!;
    subscription.cancel();

    print('[MQTT client] MQTT client disconnected');
  }

  /*
  Assina o tópico onde virão os dados de temperatura
   */
  void subscribeToTopic(String topic) {
    client.subscribe(topic, MqttQos.exactlyOnce);
    print('DEBUG::Subscription confirmed for topic $topic');
  }
}
