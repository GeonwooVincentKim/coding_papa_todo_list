/// id : "qwdqwe"
/// title : "Pugh Pittman"
/// finished : false

class Task {
  Task({
    required String title,
  })  : finished = false,
        _id = DateTime.now().millisecondsSinceEpoch.toString(),
        _title = title;

  Task.fromJson(dynamic json)
      : _id = json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        _title = json['title'] ?? "",
        finished = json['finished'] ?? false;

  String _id;
  String _title;
  bool finished;

  String get id => _id;
  String get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['finished'] = finished;
    return map;
  }
}
