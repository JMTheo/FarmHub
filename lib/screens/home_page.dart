import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../controller/db_controller.dart';

import '../model/farm.dart';
import '../services/auth_service.dart';

import '../components/avatar_card.dart';
import '../screens/detailed_plant.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _userController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
      if (documentSnapshot != null) {
        _nameController.text = documentSnapshot['name'];
        _userController.text = documentSnapshot['canAccess'].toString();
      }

      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext ctx) {
            return Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration:
                        const InputDecoration(labelText: 'Nome da fazenda'),
                  ),
                  TextField(
                    controller: _userController,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 25,
                    decoration: const InputDecoration(
                      labelText: 'Quem pode acessar',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text('Atualizar'),
                    onPressed: () async {
                      final String name = _nameController.text;
                      final String users = _userController.text;
                      final Farm farm =
                          Farm(id: documentSnapshot!.id, name: name);
                      print('usuários: $users');
                      DBController.to.updateFarm(farm);
                      _nameController.text = '';
                      _userController.text = '';
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            );
          });
    }

    DBController.to.getUserData(AuthService.to.user!.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                AuthService.to.logout();
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
              child: Text(
            'Fazendas disponíveis',
            style: kTitleMedium,
          )),
          Expanded(
              child: Obx(() => Text(
                  '[DEBUG]email: ${DBController.to.userData.value.email}'))),
          Expanded(
            flex: 3,
            child: StreamBuilder<QuerySnapshot>(
                stream: DBController.to.getFarms(AuthService.to.user!.uid),
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
                        return Card(
                          margin: const EdgeInsets.all(10.0),
                          child: ListTile(
                            title: Text(docSnap['name']),
                            subtitle: Text(docSnap['owner']),
                            trailing: SizedBox(
                              width: 50.0,
                              child: Row(children: <Widget>[
                                IconButton(
                                    onPressed: () {
                                      _update(docSnap);
                                    },
                                    icon: const Icon(Icons.edit)),
                              ]),
                            ),
                          ),
                        );
                      });
                }),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                Get.to(() => DetailedPlantPage());
              },
              child: const Text('Ir para fazenda x'),
            ),
          )
        ],
      ),
    );
  }
}
