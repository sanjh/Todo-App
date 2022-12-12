class TaskModel {
  final String id;
  final String title;
  final String note;
  final String date;
  final String starttime;
  final String endtime;
  final int reminder;
  final int colorindex;
  final String shift;
  final String status;
  TaskModel(
      {required this.id,
      required this.title,
      required this.note,
      required this.date,
      required this.starttime,
      required this.endtime,
      required this.reminder,
      required this.colorindex,
      required this.shift,
      required this.status});

  factory TaskModel.fromjson(Map<String, dynamic> json, String id) {
    return TaskModel(
      id: id,
      title: json['title'],
      note: json['note'],
      date: json['date'],
      starttime: json['starttime'],
      endtime: json['endtime'],
      reminder: json['reminder'],
      colorindex: json['colorindex'],
      shift: json['shift'],
      status: json['status'],
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'title': title,
      'note': note,
      'date': date,
      'starttime': starttime,
      'endtime': endtime,
      'reminder': reminder,
      'colorindex': colorindex,
      'shift': shift,
      'status': status,
    };
  }
}
