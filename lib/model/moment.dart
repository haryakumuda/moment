import 'package:uuid/uuid.dart';

class Moment {
  late String id = Uuid().v1();
  late String title;
  late String type;
  late DateTime latestUpdate;
  late String description;
  late List<DateTime> dateList;

  Moment({
    required this.id,
    required this.type,
    required this.title,
    required this.latestUpdate,
    required this.description,
    required this.dateList,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'latestUpdate': latestUpdate.toIso8601String(),
      'description': description,
      'dateList': dateList.map((date) => date.toIso8601String()).join(', '),
    };
  }

  Moment.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    type = map['type'] ??
        ""; // Use the null-aware coalescing operator ?? instead of ??=
    title = map['title'];
    latestUpdate = map['latestUpdate'] != null
        ? DateTime.parse(map['latestUpdate'])
        : DateTime.now();
    description = map['description'];

    // Check if 'dateList' is a String before attempting to cast
    if (map['dateList'] is String) {
      // Handle the case where 'dateList' is a String, e.g., a single date
      dateList = [DateTime.parse(map['dateList'])];
    } else {
      // Otherwise, assume 'dateList' is a List<dynamic> and cast it
      dateList = (map['dateList'] as List<dynamic>?)?.cast<DateTime>() ?? [];
    }
  }

  @override
  String toString() {
    String dateListString = dateList.map((date) => date.toString()).join(', ');
    return " title: $title,\n type: $type,\n latestUpdate: ${latestUpdate.toString()},\n description: $description,\n List of Moment: $dateList";
  }
}
