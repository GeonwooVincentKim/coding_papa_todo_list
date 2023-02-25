import 'package:coding_papa_flutter_todo_list/old_task.dart';
import 'package:coding_papa_flutter_todo_list/task_tile.dart';
import 'package:flutter/material.dart';

final List<Task> _items = [];

void main() => runApp(const MyApp());

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
                _items.add(Task(title: text));
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
          return TaskTile(itemIndex: index, onDeleted: () {});
        },
        children: <Widget>[
          for (int index = 0; index < _items.length; index += 1)
            Padding(
              key: Key('$index'),
              padding: const EdgeInsets.all(8.0),
              child: TaskTile(
                itemIndex: index,
                onDeleted: () {
                  setState(() {
                    _items.removeAt(index);
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
            final Task item = _items.removeAt(oldIndex);
            _items.insert(newIndex, item);
          });
        },
      ),
    );
  }
}
