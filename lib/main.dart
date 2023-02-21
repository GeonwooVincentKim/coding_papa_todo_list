import 'package:coding_papa_flutter_todo_list/hive_helper.dart';
import 'package:coding_papa_flutter_todo_list/task.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

final List<Task> _items = [];

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await HiveHelper().openBox();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Task'),
          content: TextField(
            autofocus: true,
            onSubmitted: (String text) {
              setState(() {
                HiveHelper().create(Task(text));
              });
              Navigator.of(context).pop();
            },
            textInputAction: TextInputAction.send,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: HiveHelper().read(),
      builder: (context, snapshot) {
        List<Task> tasks = snapshot.data ?? [];

        return Scaffold(
          appBar: AppBar(title: const Text('To do')),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showMyDialog();
            },
          ),
          body: ReorderableListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            proxyDecorator: (Widget child, int index, Animation<double> animation) {
              return TaskTile(task: tasks[index], onDeleted: () {});
            },
            children: <Widget>[
              for (int index = 0; index < tasks.length; index += 1)
                Padding(
                  key: Key('$index'),
                  padding: const EdgeInsets.all(8.0),
                  child: TaskTile(
                    task: tasks[index],
                    onDeleted: () {
                      setState(() {
                        tasks.removeAt(index);
                      });
                    },
                  ),
                )
            ],
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final Task item = tasks.removeAt(oldIndex);
                tasks.insert(newIndex, item);
              });
            },
          ),
        );
      }
    );
  }
}

class TaskTile extends StatefulWidget {
  TaskTile({
    Key? key,
    required this.task,
    required this.onDeleted,
  }) : super(key: key);

  final Task task;
  final Function onDeleted;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color evenItemColor = colorScheme.primary;

    return Material(
      child: AnimatedContainer(
        constraints: const BoxConstraints(minHeight: 60),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: widget.task.finished ? Colors.grey : evenItemColor,
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        child: Row(
          children: [
            Checkbox(
              key: widget.key,
              value: widget.task.finished,
              onChanged: (checked) {
                setState(() {
                  widget.task.finished = checked ?? false;
                });
              },
            ),
            Expanded(
              child: Text(
                widget.task.title,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  decoration: widget.task.finished
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () => widget.onDeleted(),
            )
          ],
        ),
      ),
    );
  }
}
