import 'package:flutter/material.dart';
import '../util/my_colors.dart';
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                  style: TextStyle(color: MyColors.textMain),
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
                TextField(
                  readOnly: true,
                  style: TextStyle(color: MyColors.textMain),
                  decoration: InputDecoration(
                    prefixIcon: Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: MyColors.pallete1,
                        ),
                        SizedBox(width: 8),
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
                            style: TextStyle(fontSize: 17),
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
                              initialTime: TimeOfDay(
                                  hour: date.hour, minute: date.minute),
                            );

                            if (newTime == null) {
                              return;
                            } else {
                              setState(() {
                                DateTime updatedTime = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    newTime.hour,
                                    newTime.minute);
                                date = updatedTime;
                              });
                            }
                          },
                          child: Text(
                            '${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(fontSize: 17),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(MyColors.invisible),
                              foregroundColor:
                                  MaterialStatePropertyAll(MyColors.textMain)),
                        ),
                      ],
                    ),
                  ),
                ),
                TextField(
                  style: TextStyle(color: MyColors.textMain),
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
              // Show the confirmation dialog before saving
              _showConfirmationDialog();
            },
          )),
    );
  }

// ====================================================================== //

  Future<bool> _onWillPop() async {
    // Handle back button press
    return await _showConfirmationDialogOnBack();
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Save'),
          content: Text('Do you want to save the changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _saveChanges();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showConfirmationDialogOnBack() async {
    bool wantToPop = false;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Discard'),
          content: Text('Do you want to discard the changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                wantToPop = false;
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                wantToPop = true;
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Discard'),
            ),
          ],
        );
      },
    );

    return wantToPop;
  }

  void _saveChanges() {
    // Implement your save logic here
    moment = Moment(
      title: title,
      latestUpdate: date,
      description: description,
      dateList: [date],
    );
    momentBox.put(moment.id, moment);
    Navigator.pop(context, null);
  }
}
