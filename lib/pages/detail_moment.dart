import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../database/boxes.dart';
import '../model/moment.dart';
import '../util/my_colors.dart';

class DetailMoment extends StatefulWidget {
  const DetailMoment({super.key});

  @override
  State<DetailMoment> createState() => _DetailMomentState();
}

class _DetailMomentState extends State<DetailMoment>
    with TickerProviderStateMixin {
  Box<Moment> momentBox = Boxes.getMomentBox();
  late Moment moment;
  Timer? timer;
  Moment? receivedMoment;
  late int days;
  late int hours;
  late int minutes;
  late int seconds;
  double? progress;

  @override
  void initState() {
    print('INITSTATE IS STARTING');
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {
          DateTime now = DateTime.now();
          Duration difference = now.difference(receivedMoment!.latestUpdate);
          days = difference.inDays;
          hours = difference.inHours % 24;
          minutes = difference.inMinutes % 60;
          seconds = difference.inSeconds % 60;
          progress = (difference.inSeconds % 86400) / 86400;
        });
      } else {
        // Widget is not mounted, cancel the timer
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    print('DISPOSE IS STARTING');
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('BUILD IS STARTING');
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    receivedMoment = arguments?['moment'];
    DateTime now = DateTime.now();
    Duration difference = now.difference(receivedMoment!.latestUpdate);
    days = difference.inDays;
    hours = difference.inHours % 24;
    minutes = difference.inMinutes % 60;
    seconds = difference.inSeconds % 60;
    progress = (difference.inSeconds % 86400) / 86400;

    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        title: Text(
          receivedMoment!.title,
          style: TextStyle(color: MyColors.textMain),
        ),
        backgroundColor: MyColors.appBar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                receivedMoment!.title,
                style: TextStyle(color: MyColors.textMain, fontSize: 30),
              ),
              SizedBox(
                height: 50,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "${days.toString()} days",
                        style: TextStyle(
                            color: MyColors.textMain,
                            fontSize: 30,
                            fontFamily: 'EspressoShow'),
                      ),
                      Text(
                          style: TextStyle(color: MyColors.textMain),
                          "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}"),
                    ],
                  ),
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(MyColors.pallete2),
                      backgroundColor: MyColors.pallete4,
                      value: progress,
                      semanticsLabel: 'Circular progress indicator',
                      strokeWidth: 20,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(MyColors.textMain)),
                  onPressed: () {
                    receivedMoment?.latestUpdate = DateTime.now();
                    receivedMoment?.dateList.add(DateTime.now());
                    momentBox.put(receivedMoment?.id, receivedMoment!);
                  },
                  child: Icon(Icons.refresh)),
              SizedBox(
                height: 50,
              ),
              Text(
                "\"${receivedMoment!.description}\"",
                style: TextStyle(color: MyColors.textMain, fontSize: 15),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
