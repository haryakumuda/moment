import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/moment.dart';

class Boxes {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MomentAdapter());
    await Hive.openBox<Moment>('momentBox');
  }

  static Box<Moment> getMomentBox() {
    return Hive.box<Moment>('momentBox');
  }
}
