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
        title: Text(
          "Moment App",
          style: TextStyle(color: MyColors.textMain),
        ),
        backgroundColor: MyColors.appBar,
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
                        momentBox.delete(moments[index].id);
                        _loadData();
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
          dynamic result = await Navigator.pushNamed(context, '/newMoment');
          _loadData();
        },
      ),
    );
  }
}
