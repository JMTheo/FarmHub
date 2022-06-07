import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../enums/FarmTypeOperation.dart';

import '../controller/db_controller.dart';
import '../services/auth_service.dart';
import '../modal/farm_modal.dart';

import '../screens/detailed_plant.dart';
import '../components/avatar_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.stream}) : super(key: key);

  final Stream<QuerySnapshot<Object?>> stream;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    DBController.to.getAllOwnerFarms(DBController.to.userData.value.email!);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  AuthService.to.logout();
                  //Get.to(() => const ProfilePage());
                },
                icon: const Icon(Icons.person)),
          ],
        ),
        body: Column(
          children: <Widget>[
            const Expanded(
              child: Center(
                child: AvatarCard(),
              ),
            ),
            const Expanded(
                child: Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                'Fazendas disponíveis',
                style: kTitleMedium,
              ),
            )),
            Expanded(
              flex: 4,
              child: StreamBuilder<QuerySnapshot>(
                  stream: widget.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Erro ao receber dados: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return const Text(
                          'Não há fazendas cadastradas ao seu perfil');
                    }

                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot docSnap =
                              snapshot.data!.docs[index];
                          return Obx(() => GestureDetector(
                                onTap: () => {
                                  Get.to(() => DetailedPlantPage(
                                        farmID: docSnap.id,
                                        name: docSnap['name'],
                                        stream: DBController.to
                                            .getGrounds(docSnap.id),
                                      ))
                                },
                                child: Card(
                                  margin: const EdgeInsets.all(10.0),
                                  child: ListTile(
                                    title: Text(docSnap['name']),
                                    subtitle:
                                        Text('Dono: ${docSnap['fullName']}'),
                                    trailing: DBController.to.ownerFarmsIDs
                                            .contains(docSnap.id)
                                        ? SizedBox(
                                            width: 100.0,
                                            child: Row(children: <Widget>[
                                              IconButton(
                                                onPressed: () async {
                                                  await getModal(
                                                      context,
                                                      FarmTypeOperation.update,
                                                      docSnap);
                                                },
                                                icon: const Icon(Icons.edit),
                                              ),
                                              IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: () => DBController
                                                      .to
                                                      .deleteFarm(docSnap.id)),
                                            ]),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ),
                              ));
                        });
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kDefaultColorGreen,
          onPressed: () async =>
              await getModal(context, FarmTypeOperation.create),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
