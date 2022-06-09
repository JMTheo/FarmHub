import 'package:automacao_horta/controller/iot_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class ScheduleWaterPage extends StatefulWidget {
  const ScheduleWaterPage(
      {Key? key, required this.ground, required this.id, required this.stream})
      : super(key: key);

  final String ground;
  final String id;
  final Stream<QuerySnapshot<Object?>> stream;

  @override
  State<ScheduleWaterPage> createState() => _ScheduleWaterPageState();
}

class _ScheduleWaterPageState extends State<ScheduleWaterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.ground),
        ),
        body: Center(
          child: Column(
            children: [
              const Expanded(
                child: Text(
                  'Agendamento',
                  style: kHighTitle,
                ),
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: widget.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                              'Erro ao receber dados: ${snapshot.error}');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return const Text(
                              'Não há agendamentos cadastrados nessa região');
                        }
//TODO:Falta finalizar
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot docSnap =
                                  snapshot.data!.docs[index];
                              int indexDisplay = index + 1;
                              return Obx(
                                () => GestureDetector(
                                  onTap: () => {},
                                  child: Card(
                                    margin: const EdgeInsets.all(10.0),
                                    child: ListTile(
                                      title: Text(
                                          '$indexDisplay - Dias: ${docSnap['data'][0]['days']}'),
                                      subtitle: const Text('Dono: '),
                                      trailing: const Text('opa'),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kDefaultColorGreen,
          onPressed: () => IoTController.to.releaseWater(widget.id, 5),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
