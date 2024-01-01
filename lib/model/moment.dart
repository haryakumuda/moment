import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'moment.g.dart';

@HiveType(typeId: 1)
class Moment {
  @HiveField(0)
  late String id = Uuid().v1();
  @HiveField(1)
  late String title;
  @HiveField(2)
  late DateTime latestUpdate;
  @HiveField(3)
  late String description;
  @HiveField(4)
  late List<DateTime> dateList;

  Moment(
      {required this.title,
      required this.latestUpdate,
      required this.description,
      required this.dateList});

  @override
  String toString() {
    String dateListString = dateList.map((date) => date.toString()).join(', ');
    return " title: $title, latestUpdate: ${latestUpdate.toString()}, description: $description, List of Moment: $dateListString";
  }
}
