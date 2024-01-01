import 'package:flutter/material.dart';
import 'package:moment/assets/my_colors.dart';
import 'package:moment/model/moment.dart';

import 'package:hive_flutter/hive_flutter.dart';
import '../database/boxes.dart';

class NewMoment extends StatefulWidget {
  const NewMoment({super.key});

  @override
  State<NewMoment> createState() => _NewMomentState();
}

class _NewMomentState extends State<NewMoment> {
  Box<Moment> momentBox = Boxes.getMomentBox();
  late Moment moment;
  DateTime date = DateTime.now();
  String title = "";
  String description = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.background,
        appBar: AppBar(
          title: Text(
            'Detail Moment',
            style: TextStyle(color: MyColors.textMain),
          ),
          backgroundColor: MyColors.appBar,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                maxLength: 20,
                decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(color: MyColors.textShadow),
                    icon: Icon(
                      Icons.title_outlined,
                      color: MyColors.pallete1,
                    )),
                onChanged: (String? value) {
                  if (value != null) {
                    title = value;
                  }
                },
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));

                      // Jika newDate null maka tidak eksekusi code setelah return
                      if (newDate == null) {
                        return;
                      } else {
                        setState(() {
                          DateTime updatedDate = DateTime(
                              newDate.year,
                              newDate.month,
                              newDate.day,
                              date.hour,
                              date.minute);
                          date = updatedDate;
                        });
                      }
                    },
                    child: Text(
                      '${date.year}/${date.month}/${date.day} ',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(MyColors.invisible),
                        foregroundColor:
                            MaterialStatePropertyAll(MyColors.textMain)),
                  ),
                  TextButton(
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                        initialTime:
                            TimeOfDay(hour: date.hour, minute: date.minute),
                      );

                      if (newTime == null) {
                        return;
                      } else {
                        setState(() {
                          DateTime updatedTime = DateTime(date.year, date.month,
                              date.day, newTime.hour, newTime.minute);
                          date = updatedTime;
                        });
                      }
                    },
                    child: Text(
                      '${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(MyColors.invisible),
                        foregroundColor:
                            MaterialStatePropertyAll(MyColors.textMain)),
                  ),
                ],
              ),
              TextField(
                maxLength: 200,
                decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: TextStyle(color: MyColors.textShadow),
                    hintText: " ",
                    hintStyle: TextStyle(color: MyColors.textShadow),
                    icon: Icon(
                      Icons.description,
                      color: MyColors.pallete1,
                    )),
                onChanged: (String? value) {
                  if (value != null) {
                    description = value;
                  }
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyColors.pallete1,
          child: Text(
            "save",
            style: TextStyle(color: MyColors.textMain),
          ),
          onPressed: () async {
            moment = Moment(
                title: title,
                latestUpdate: date,
                description: description,
                dateList: [date]);
            momentBox.put(moment.id, moment);
            Navigator.pop(context, null);
          },
        ));
  }
}
