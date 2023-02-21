import 'package:coding_papa_flutter_todo_list/task.dart';
import 'package:hive/hive.dart';

const String TASK_BOX = "TASK_BOX";

class HiveHelper {
  static final HiveHelper _singleton = HiveHelper._internal();

  factory HiveHelper() {
    return _singleton;
  }

  HiveHelper._internal();

  Box<Task>? tasksBox;

  Future openBox() async {
    tasksBox = await Hive.openBox(TASK_BOX);
  }
}
