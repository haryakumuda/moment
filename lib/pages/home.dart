import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../util/my_colors.dart';
import '../database/boxes.dart';
import '../model/moment.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Moment> moments = [];
  Box<Moment> momentBox = Boxes.getMomentBox();
  late Moment moment;
  late int index;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    Box<Moment> momentBox = Boxes.getMomentBox();
    setState(() {
      moments = momentBox.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: MyColors.textMain,
            ), // 3-dots icon
            onSelected: (String result) {
              // Handle the selected option
              if (result == 'option1') {
                Navigator.pushNamed(context, '/about');
              } else if (result == 'option2') {
                final snackBar = SnackBar(
                  content: Text("Thanks, but I don't need it!"),
                  duration: Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              // Add more conditions for other options
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'option1',
                child:
                    Text('About', style: TextStyle(color: MyColors.textMain)),
              ),
              PopupMenuItem<String>(
                value: 'option2',
                child: Text(
                  'Donate',
                  style: TextStyle(color: MyColors.textMain),
                ),
              ),
              // Add more PopupMenuItem widgets for additional options
            ],
            color: MyColors.background,
          ),
        ],
        toolbarOpacity: 0.5,
        title: Text(
          "Moment App",
          style: TextStyle(color: MyColors.textMain),
        ),
        backgroundColor: MyColors.appBar,
        foregroundColor: MyColors.textMain,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
            child: Card(
              color: MyColors.pallete1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    style: ListTileStyle.list,
                    onTap: () {
                      Navigator.pushNamed(context, '/detailMoment',
                          arguments: {'moment': moments[index]});
                    },
                    title: Text(
                      moments[index].title,
                      style: TextStyle(color: MyColors.textMain),
                    ),
                    subtitle: Text(
                      moments[index].description,
                      style: TextStyle(color: MyColors.textMain),
                    ),
                    leading: Icon(
                      Icons.check,
                      color: MyColors.pallete4,
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: MyColors.pallete4,
                      ),
                      onPressed: () {
                        this.index = index;
                        _showConfirmationDialog();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: moments.length,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.pallete2,
        child: Icon(
          Icons.add,
          color: MyColors.textMain,
        ),
        onPressed: () async {
          await Navigator.pushNamed(context, '/newMoment');
          _loadData();
        },
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Do you want to delete this moment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteMoment();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMoment() {
    // Implement your save logic here
    momentBox.delete(moments[index].id);
    _loadData();
  }
}
