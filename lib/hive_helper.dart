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

  Future reOrder(int oldIndex, int newIndex) async {
    List<Task> newList = [];
    newList.addAll(tasksBox!.values);

    final Task item = newList.removeAt(oldIndex);
    newList.insert(newIndex, item);

    await tasksBox!.clear();
    await tasksBox!.addAll(newList);

    return;
  }

  Future openBox() async {
    tasksBox = await Hive.openBox(TASK_BOX);
  }

  Future create(Task newTask) async {
    return tasksBox!.add(newTask);
  }

  Future<List<Task>> read() async {
    return tasksBox!.values.toList();
  }

  Future update(int index, Task updatedTask) async {
    tasksBox!.putAt(index, updatedTask);
  }

  Future delete(int index) async {
    tasksBox!.deleteAt(index);
  }
}
