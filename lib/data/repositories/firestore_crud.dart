import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/data/models/resident_model.dart';
import 'package:todo_app/data/models/task_model.dart';

class FireStoreCrud {
  FireStoreCrud();

  final _firestore = FirebaseFirestore.instance;

  Future<void> addTask({required TaskModel task}) async {
    var taskcollection = _firestore.collection('tasks');
    await taskcollection.add(task.tojson());
  }

  Stream<List<TaskModel>> getTasks({required String mydate}) {
    return _firestore
        .collection('tasks')
        .where('date', isEqualTo: mydate)
        .snapshots(includeMetadataChanges: true)
        .map((snapshor) => snapshor.docs
            .map((doc) => TaskModel.fromjson(doc.data(), doc.id))
            .toList());
  }

  Stream<List<ResidentModel>> getResident() {
    return _firestore
        .collection('patients')
        .snapshots(includeMetadataChanges: true)
        .map((snapshor) => snapshor.docs
            .map((doc) => ResidentModel.fromjson(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateTask(
      {required String title,
      note,
      docid,
      date,
      starttime,
      endtime,
      shift,
      status,
      required int reminder,
      colorindex}) async {
    var taskcollection = _firestore.collection('tasks');
    await taskcollection.doc(docid).update({
      'title': title,
      'note': note,
      'date': date,
      'starttime': starttime,
      'endtime': endtime,
      'reminder': reminder,
      'colorindex': colorindex,
      'shift': shift,
      'status': status
    });
  }

  Future<void> deleteTask({required String docid}) async {
    var taskcollection = _firestore.collection('tasks');
    await taskcollection.doc(docid).delete();
  }
}
