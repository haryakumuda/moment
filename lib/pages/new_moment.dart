import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../database/sqflite_database.dart';
import '../util/my_colors.dart';
import 'package:moment/model/moment.dart';

class NewMoment extends StatefulWidget {
  const NewMoment({super.key});

  @override
  State<NewMoment> createState() => _NewMomentState();
}

class _NewMomentState extends State<NewMoment> {
  late DatabaseHelper databaseHelper;
  late Moment moment;
  DateTime date = DateTime.now();
  String title = "";
  String description = "";

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper(); // Initialize your database helper
  }

  Future<void> initializeDatabase() async {
    // Initialize the database here (use your own database helper class)
    // Example: databaseHelper = DatabaseHelper();
    // db = await databaseHelper.database;

    // Replace the above line with your actual initialization logic
    // databaseHelper should be an instance of your database helper class
    // that creates and manages the SQLite database.
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (title == "" && description == "") {
          return true;
        }
        return await _onWillPop(); // Allow the user to pop the screen if there are changes
      },
      child: Scaffold(
          backgroundColor: MyColors.background,
          appBar: AppBar(
            title: Text(
              'Detail Moment',
              style: TextStyle(color: MyColors.textMain),
            ),
            backgroundColor: MyColors.appBar,
            foregroundColor: MyColors.textMain,
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

  Future<void> _saveChanges() async {
    // Implement your save logic here
    moment = Moment(
        title: title,
        latestUpdate: date,
        description: description,
        dateList: [date],
        type: 'HISTORY',
        id: Uuid().v4());

    print("MOMENT TO BE SAVED: ${moment.toString()}");

    int result = await databaseHelper.insertMoment(moment);
    print("IS MOMENT SAVED? $result");

    if (result != 0) {
      final snackBar = SnackBar(
          content: Text("Insert Moment Completed..."),
          duration: Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // Insert successful, you can navigate back or perform other actions
      Navigator.pop(context, null);
    } else {
      final snackBar = SnackBar(
          content: Text("Error Inserting Moment..."),
          duration: Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
