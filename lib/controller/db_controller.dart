import 'package:automacao_horta/model/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../database/db_firestore.dart';

import '../model/ground.dart';

class DBController extends GetxController {
  Rx<UserData> userData = UserData(name: '', surname: '', cpf: '').obs;

  static DBController get to => Get.find<DBController>();

  setUserDataLocal(Map<String, dynamic>? data) {
    userData.value = UserData.fromJson(data!);
  }

  getUserData(uid) async {
    final FirebaseFirestore db = await DBFirestore.get();
    final userRef = db.collection('users');
    var query =
        userRef.where('uid_auth', isEqualTo: uid).snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            setUserDataLocal(change.doc.data());
            print('Doc inserido: ${change.doc.data()}');
            break;
          case DocumentChangeType.modified:
            print('Doc Modificado: ${change.doc.data()}');
            setUserDataLocal(change.doc.data());
            break;
          case DocumentChangeType.removed:
            print('Doc removido: ${change.doc.data()}');
            break;
        }
      }
    });
    return query;
  }

  Future<Stream<List<Ground>>> getAllGround() async {
    final FirebaseFirestore db = await DBFirestore.get();
    final userRef = db.collection('ground');
    var query = userRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Ground.fromJson(doc.data())).toList());
    return query;
  }

  Future addUser(UserData userObj) async {
    final FirebaseFirestore db = await DBFirestore.get();
    final json = userObj.toJson();

    db.collection("users").add(json).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }
}
