import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:get/get.dart';

import '../components/toast_util.dart';

import '../database/db_firestore.dart';

import '../enums/toast_option.dart';

import '../model/user_data.dart';
import '../model/farm.dart';
import '../model/ground.dart';

class DBController extends GetxController {
  Rx<UserData> userData = UserData(name: '', surname: '', cpf: '', email: '')
      .obs; //Guarda os dados do usuário logado
  RxList sharedFarmsIDs = [].obs; //Ids das fazendas compartilhadas
  RxList ownerFarmsIDs = [].obs; //Ids das fazendas onde o usuário é dono
  RxList usersInFarm =
      [].obs; //Ids contendo todos os que possuem acesso em determinada fazenda
  RxList<String> selectedUsersList = [
    ''
  ].obs; //Lista de usuários disponíveis para serem selecionados no widget de edição de fazenda
  RxList<SelectedListItem> allUsersList = [SelectedListItem(false, '')]
      .obs; //Lista de usuários selecionados pelo widget de edição

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

  Future<void> getUsersAccessFarm(String farmID) async {
    var docSnapshot = await _db.collection('farm').doc(farmID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      List<dynamic> users = data?['canAccess'];
      usersInFarm.value = users;
    }
  }

  Future<void> deleteFarm(String farmID) async {
    await _db.collection('farm').doc(farmID).delete();
    ToastUtil(
      text: 'Sucesso ao deletar fazenda!',
      type: ToastOption.success,
    ).getToast();
  }

  Future addGround(Ground groundObj) async {
    final json = groundObj.toJson();
    await _db.collection('ground').add(json);
  }

  Future updateGround(Ground groundObj) async {
    final json = groundObj.toJson();
    await _db.collection('ground').doc(groundObj.id).update(json);
  }

  Future<void> deleteGround(String groundID) async {
    await _db.collection('ground').doc(groundID).delete();
    ToastUtil(
      text: 'Sucesso ao deletar campo!',
      type: ToastOption.success,
    ).getToast();
  }

  Future getAllUser() async {
    allUsersList.clear();
    selectedUsersList.clear();
    await _db
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              setToListShared(document['email']);
            }));
  }

  setToListShared(String email) {
    bool selected = usersInFarm.contains(email);

    SelectedListItem user = SelectedListItem(selected, email);
    if (!allUsersList.any((element) => element.name == email)) {
      allUsersList.add(user);
    }
  }
}
