import 'package:flutter/material.dart';

import '../constants.dart';

class ScheduleWaterPage extends StatefulWidget {
  const ScheduleWaterPage({Key? key, required this.ground}) : super(key: key);

  final String ground;

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
            children: const [
              Text(
                'Agendamento',
                style: kHighTitle,
              )
            ],
          ),
        ));
  }
}
