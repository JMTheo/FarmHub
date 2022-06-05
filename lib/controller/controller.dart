import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:mqtt_client/mqtt_client.dart'; // as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:mobx/mobx.dart';
part 'controller.g.dart';

//A cada alteração no Observable rodar esse comando no terminal
// flutter pub run build_runner watch

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
  String clientIdentifier = 'mobile';
  String topic = 'iot/farm';

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
    Map<String, String> msg = {'action': ''};
    estadoLampada = !estadoLampada;

    if (estadoLampada) {
      msg['action'] = 'lj';
    } else {
      msg['action'] = 'dj';
    }

    enviarMensagem(jsonEncode(msg));
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
    String? deviceId = await _getId();
    client = MqttServerClient(broker, '');
    client.port = port;
    client.keepAlivePeriod = 30;
    client.onDisconnected = _onDisconnected;
    client.onSubscribed = subscribeToTopic;
    client.onAutoReconnect = _onAutoReconnect;
    client.autoReconnect = true;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('$clientIdentifier - $deviceId')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    print('[MQTT client] MQTT client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print(e);
      disconnect();
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

  void _onAutoReconnect() {
    print('[MQTT client] _onAutoReconnect');
  }

  /*
  Desconecta do servidor MQTT
   */
  void disconnect() {
    print('[MQTT client] _disconnect()');
    client.disconnect();
    _onDisconnected();
  }

  /*
  Executa algo quando desconectado, no caso, zera as variáveis e imprime msg no console
   */
  void _onDisconnected() {
    print('[MQTT client] _onDisconnected');
    connectionState = MqttClientConnectionStatus().state;
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

  //Pegando o id do celular para diferenciar na lista de client
  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
    return null;
  }
}
