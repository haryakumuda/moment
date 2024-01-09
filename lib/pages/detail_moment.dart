import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

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
        foregroundColor: MyColors.textMain,
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
              Expanded(
                flex: 1,
                child: PageView(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Counter',
                          style:
                              TextStyle(color: MyColors.textMain, fontSize: 25),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        widgetDaysCount(),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Statistic',
                          style:
                              TextStyle(color: MyColors.textMain, fontSize: 25),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        widgetHeatMap(),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'History',
                          style:
                              TextStyle(color: MyColors.textMain, fontSize: 25),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        widgetDateList(),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(MyColors.textMain)),
                  onPressed: () {
                    _showConfirmationDialog();
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

  /// =========================================== WIDGETS =========================================== ///
  widgetDaysCount() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            valueColor: AlwaysStoppedAnimation<Color>(MyColors.pallete2),
            backgroundColor: MyColors.pallete4,
            value: progress,
            semanticsLabel: 'Circular progress indicator',
            strokeWidth: 20,
            strokeCap: StrokeCap.round,
          ),
        ),
      ],
    );
  }

  widgetDateList() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          int reversedIndex = receivedMoment!.dateList.length - 1 - index;

          DateTime date = receivedMoment!.dateList[reversedIndex];
          DateTime? dateBefore = reversedIndex > 0
              ? receivedMoment!.dateList[reversedIndex - 1]
              : date;

          Duration timePassed = date.difference(dateBefore);

          DateFormat formatter = DateFormat('E, d MMM yyyy HH:mm');

          String formattedDate = formatter.format(date);

          bool isFirstIndex = index == receivedMoment!.dateList.length - 1;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
            child: Card(
              color: MyColors.pallete1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    style: ListTileStyle.list,
                    onTap: () {},
                    title: isFirstIndex
                        ? Text(
                            "Start",
                            style: TextStyle(
                              color: MyColors.textMain,
                              fontSize: 16,
                            ),
                          )
                        : Text(
                            "${timePassed.inDays.toString()} Days, ${(timePassed.inHours % 24).toString()} Hours, ${(timePassed.inMinutes % 60).toString()} Minutes, ${(timePassed.inSeconds % 60).toString()} Seconds",
                            style: TextStyle(
                              color: MyColors.textMain,
                              fontSize: 16,
                            ),
                          ),
                    subtitle: Text(
                      formattedDate,
                      style: TextStyle(color: MyColors.textMain),
                    ),
                    leading: null,
                    trailing: null,
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: receivedMoment?.dateList.length,
      ),
    );
  }

  widgetHeatMap() {
    return HeatMap(
      datasets: mapDateTimeColor(receivedMoment!.dateList),
      startDate: DateTime.now().add(Duration(days: -90)),
      endDate: DateTime.now(),
      defaultColor: Colors.grey,
      colorMode: ColorMode.opacity,
      textColor: Colors.white,
      colorTipCount: 5,
      fontSize: 10,
      showText: true,
      showColorTip: false,
      scrollable: true,
      borderRadius: 4.0,
      colorsets: {
        1: MyColors.appBar,
        // 3: Colors.orange,
        // 5: Colors.yellow,
        // 7: Colors.green,
        // 9: Colors.blue,
        // 11: Colors.indigo,
        // 13: Colors.purple,
      },
      onClick: (value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value.toString())));
      },
    );
  }

  /// =========================================== DIALOG

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure want to reset?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _resetDate();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _resetDate() {
    // Implement your save logic here
    receivedMoment?.latestUpdate = DateTime.now();
    receivedMoment?.dateList.add(DateTime.now());
    momentBox.put(receivedMoment?.id, receivedMoment!);
  }

  Map<DateTime, int> mapDateTimeColor(List<DateTime> dateTime) {
    Map<DateTime, int> mapDateTime = {};
    for (DateTime e in dateTime) {
      DateTime newDateTime = DateTime(e.year, e.month, e.day);
      if (mapDateTime.containsKey(newDateTime)) {
        mapDateTime[newDateTime] = (mapDateTime[newDateTime]! + 1);
      } else
        mapDateTime[newDateTime] = 1;
    }

    return mapDateTime;
  }
}
