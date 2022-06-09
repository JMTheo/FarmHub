import 'dart:async';

import 'package:automacao_horta/model/schedule.dart';
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
  //Guarda os dados do usuário logado
  Rx<UserData> userData =
      UserData(name: '', surname: '', cpf: '', email: '').obs;
  //Ids das fazendas compartilhadas
  RxList sharedFarmsIDs = [].obs;
  //Ids das fazendas onde o usuário é dono
  RxList ownerFarmsIDs = [].obs;
  //Ids contendo todos os que possuem acesso em determinada fazenda
  RxList usersInFarm = [].obs;
  //Lista de usuários disponíveis para serem selecionados no widget de edição de fazenda
  RxList<String> selectedUsersList = [''].obs;
  //Lista de usuários selecionados pelo widget de edição
  RxList<SelectedListItem> allUsersList = [SelectedListItem(false, '')].obs;

  //Ref banco de dados
  final FirebaseFirestore _db = DBFirestore.get();

  //Singleton
  static DBController get to => Get.find<DBController>();

  //Usuário
  setUserDataLocal(Map<String, dynamic>? data) {
    userData.value = UserData.fromJson(data!);
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

  Future addUser(UserData userObj) async {
    final json = userObj.toJson();

    await _db.collection("users").add(json).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  Stream<QuerySnapshot> getFarms(String email) {
    final Stream<QuerySnapshot> farm = _db
        .collection('farm')
        .where('canAccess', arrayContains: email)
        .snapshots();
    return farm;
  }

  //Fazenda

  Future addFarm(Farm farmObj) async {
    final json = farmObj.toJson();
    await _db.collection('farm').add(json);
    await getAllOwnerFarms(farmObj.owner!);
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

  Future<void> getUsersAccessFarm(String farmID) async {
    if (farmID.isNotEmpty) {
      var docSnapshot = await _db.collection('farm').doc(farmID).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        List<dynamic> users = data?['canAccess'];
        usersInFarm.value = users;
      }
    }
  }

  Future<void> deleteFarm(String farmID) async {
    await _db.collection('farm').doc(farmID).delete();
    ToastUtil(
      text: 'Sucesso ao deletar fazenda!',
      type: ToastOption.success,
    ).getToast();
  }

  //Região

  Stream<QuerySnapshot> getGrounds(String farmID) {
    final Stream<QuerySnapshot> ground =
        _db.collection('ground').where('farm', isEqualTo: farmID).snapshots();
    return ground;
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

  //Schedule
  Stream<QuerySnapshot> getSchedules(String groundID) {
    final Stream<QuerySnapshot> schedule = _db
        .collection('schedule')
        .where('groundID', isEqualTo: groundID)
        .snapshots();
    return schedule;
  }

  Future addSchedule(Schedule scheduleObj) async {
    final json = scheduleObj.toJson();
    await _db.collection('schedule').add(json);
  }

  Future updateSchedule(Schedule scheduleObj) async {
    final json = scheduleObj.toJson();
    await _db.collection('schedule').doc(scheduleObj.id).update(json);
  }

  Future<void> deleteScheduled(String scheduleID) async {
    await _db.collection('schedule').doc(scheduleID).delete();
    ToastUtil(
      text: 'Sucesso ao deletar agendamento!',
      type: ToastOption.success,
    ).getToast();
  }

  eraseDataOnLogout() {
    ownerFarmsIDs.clear();
    sharedFarmsIDs.clear();
  }

  setToListShared(String email) {
    bool selected = usersInFarm.contains(email);

    SelectedListItem user = SelectedListItem(selected, email);
    if (!allUsersList.any((element) => element.name == email)) {
      allUsersList.add(user);
    }
  }
}
