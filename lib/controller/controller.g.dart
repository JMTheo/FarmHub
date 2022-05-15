// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Controller on ControllerBase, Store {
  late final _$temperaturaAtom =
      Atom(name: 'ControllerBase.temperatura', context: context);

  @override
  double get temperatura {
    _$temperaturaAtom.reportRead();
    return super.temperatura;
  }

  @override
  set temperatura(double value) {
    _$temperaturaAtom.reportWrite(value, super.temperatura, () {
      super.temperatura = value;
    });
  }

  late final _$estadoLampadaAtom =
      Atom(name: 'ControllerBase.estadoLampada', context: context);

  @override
  bool get estadoLampada {
    _$estadoLampadaAtom.reportRead();
    return super.estadoLampada;
  }

  @override
  set estadoLampada(bool value) {
    _$estadoLampadaAtom.reportWrite(value, super.estadoLampada, () {
      super.estadoLampada = value;
    });
  }

  late final _$umidadeSoloAtom =
      Atom(name: 'ControllerBase.umidadeSolo', context: context);

  @override
  int get umidadeSolo {
    _$umidadeSoloAtom.reportRead();
    return super.umidadeSolo;
  }

  @override
  set umidadeSolo(int value) {
    _$umidadeSoloAtom.reportWrite(value, super.umidadeSolo, () {
      super.umidadeSolo = value;
    });
  }

  late final _$umidadeArAtom =
      Atom(name: 'ControllerBase.umidadeAr', context: context);

  @override
  int get umidadeAr {
    _$umidadeArAtom.reportRead();
    return super.umidadeAr;
  }

  @override
  set umidadeAr(int value) {
    _$umidadeArAtom.reportWrite(value, super.umidadeAr, () {
      super.umidadeAr = value;
    });
  }

  late final _$luminosidadeAtom =
      Atom(name: 'ControllerBase.luminosidade', context: context);

  @override
  int get luminosidade {
    _$luminosidadeAtom.reportRead();
    return super.luminosidade;
  }

  @override
  set luminosidade(int value) {
    _$luminosidadeAtom.reportWrite(value, super.luminosidade, () {
      super.luminosidade = value;
    });
  }

  late final _$ControllerBaseActionController =
      ActionController(name: 'ControllerBase', context: context);

  @override
  dynamic atualizarDados(int umi, int umiS, double temp, int luz) {
    final _$actionInfo = _$ControllerBaseActionController.startAction(
        name: 'ControllerBase.atualizarDados');
    try {
      return super.atualizarDados(umi, umiS, temp, luz);
    } finally {
      _$ControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudarEstadoLampada() {
    final _$actionInfo = _$ControllerBaseActionController.startAction(
        name: 'ControllerBase.mudarEstadoLampada');
    try {
      return super.mudarEstadoLampada();
    } finally {
      _$ControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic acionarAgua() {
    final _$actionInfo = _$ControllerBaseActionController.startAction(
        name: 'ControllerBase.acionarAgua');
    try {
      return super.acionarAgua();
    } finally {
      _$ControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
temperatura: ${temperatura},
estadoLampada: ${estadoLampada},
umidadeSolo: ${umidadeSolo},
umidadeAr: ${umidadeAr},
luminosidade: ${luminosidade}
    ''';
  }
}
