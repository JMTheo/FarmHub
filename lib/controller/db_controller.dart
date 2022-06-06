import 'dart:async';

import 'package:automacao_horta/model/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../database/db_firestore.dart';

import '../model/farm.dart';
import '../model/ground.dart';

class DBController extends GetxController {
  Rx<UserData> userData =
      UserData(name: '', surname: '', cpf: '', email: '').obs;
  RxList sharedFarmsIDs = [].obs;
  RxList ownerFarmsIDs = [].obs;
  RxList usersList = [].obs;

  final FirebaseFirestore _db = DBFirestore.get();

  static DBController get to => Get.find<DBController>();

  setUserDataLocal(Map<String, dynamic>? data) {
    userData.value = UserData.fromJson(data!);
  }

  Future addUser(UserData userObj) async {
    final json = userObj.toJson();

    _db.collection("users").add(json).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  getUserData(uid) {
    final userRef = _db.collection('users');
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

  Stream<QuerySnapshot> getFarms(String uid) {
    final Stream<QuerySnapshot> farm = _db
        .collection('farm')
        .where('canAccess', arrayContains: uid)
        .snapshots();
    return farm;
  }

  Future updateFarm(Farm farmObj) async {
    final json = farmObj.toJson();
    await _db.collection('farm').doc(farmObj.id).update(json);
  }

  Future getAllSharedFarms(uid) async {
    await _db
        .collection('farm')
        .where('canAccess', arrayContains: uid)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              sharedFarmsIDs.addIf(
                  !sharedFarmsIDs.contains(document.reference.id),
                  document.reference.id);
            }));
  }

  Future getOwnerData(String uid) async {
    await _db
        .collection('users')
        .where('uid_auth', isEqualTo: uid)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              UserData userObj = UserData.fromJson(document.data());
              usersList.addIf(!usersList.contains(userObj), userObj);
            }));
  }

  Future getAllOwnerFarms(uid) async {
    await _db
        .collection('farm')
        .where("owner", isEqualTo: uid)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              ownerFarmsIDs.addIf(
                  !ownerFarmsIDs.contains(document.reference.id),
                  document.reference.id);
            }));
  }

  Future<Stream<List<Ground>>> getAllGround() async {
    final groundRef = _db.collection('ground');
    var query = groundRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Ground.fromJson(doc.data())).toList());
    return query;
  }

  eraseDataOnLogout() {
    ownerFarmsIDs.clear();
    sharedFarmsIDs.clear();
  }
}
