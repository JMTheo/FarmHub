import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../components/toast_util.dart';

import '../database/db_firestore.dart';

import '../enums/ToastOptions.dart';

import '../model/user_data.dart';
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

    await _db.collection("users").add(json).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  Future addFarm(Farm farmObj) async {
    final json = farmObj.toJson();
    await _db.collection('farm').add(json);
    await getAllOwnerFarms(farmObj.owner!);
  }

  Future getUserData(String uid) async {
    await _db
        .collection('users')
        .where('uid_auth', isEqualTo: uid)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              UserData user = UserData(
                  name: document['name'],
                  surname: document['surname'],
                  cpf: document['cpf'],
                  email: document['email'],
                  uidAuth: uid);
              userData.value = user;
            }));
  }

  Stream<QuerySnapshot> getFarms(String email) {
    final Stream<QuerySnapshot> farm = _db
        .collection('farm')
        .where('canAccess', arrayContains: email)
        .snapshots();
    return farm;
  }

  Stream<QuerySnapshot> getGrounds(String farmID) {
    final Stream<QuerySnapshot> ground =
        _db.collection('ground').where('farm', isEqualTo: farmID).snapshots();
    return ground;
  }

  Future<Stream<List<Ground>>> getAllGround() async {
    final groundRef = _db.collection('ground');
    var query = groundRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Ground.fromJson(doc.data())).toList());
    return query;
  }

  Future updateFarm(Farm farmObj) async {
    final json = farmObj.toJson();
    await _db.collection('farm').doc(farmObj.id).update(json);
  }

  Future getAllSharedFarms(String email) async {
    await _db
        .collection('farm')
        .where('canAccess', arrayContains: email)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              sharedFarmsIDs.addIf(
                  !sharedFarmsIDs.contains(document.reference.id),
                  document.reference.id);
            }));
  }

  Future getOwnerData(String email) async {
    await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              UserData userObj = UserData.fromJson(document.data());
              usersList.addIf(!usersList.contains(userObj), userObj);
            }));
  }

  Future getAllOwnerFarms(String email) async {
    await _db
        .collection('farm')
        .where("owner", isEqualTo: email)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              ownerFarmsIDs.addIf(
                  !ownerFarmsIDs.contains(document.reference.id),
                  document.reference.id);
            }));
  }

  eraseDataOnLogout() {
    ownerFarmsIDs.clear();
    sharedFarmsIDs.clear();
  }

  Future<void> deleteFarm(String farmID) async {
    await _db.collection('farm').doc(farmID).delete();
    ToastUtil(
      text: 'Sucesso ao deletar fazenda!',
      type: ToastOption.success,
    ).getToast();
  }
}
