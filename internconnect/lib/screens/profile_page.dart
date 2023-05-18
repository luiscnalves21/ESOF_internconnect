import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/firebase_user.dart';
import '../models/users.dart';
import '../services/database.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _type;
  String? _name;
  String? _email;
  List<String> _softSkills = [];
  List<String> _certificates = [];

  final TextEditingController _softSkillController = TextEditingController();
  final TextEditingController _certificateController = TextEditingController();

  bool nameEditable = false;

  bool isButtonClicked = true;

  @override
  void initState() {
    super.initState();
  }

  void _editableName() {
    setState(() {
      nameEditable = !nameEditable;
    });
  }

  void _handleClick() {
    setState(() {
      isButtonClicked = !isButtonClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser?>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data!;
              _type = userData.type;
              _name = userData.name;
              _email = userData.email;
              _softSkills = userData.softSkills;
              _certificates = userData.certificates;
              return Scaffold(
                body: SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: (_type == 'user') ? const Icon(
                              Icons.person_outline_rounded,
                              size: 150,
                            ) : const Icon(
                              Icons.business_center_outlined,
                              size: 150,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Name:',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller:
                                      TextEditingController(text: _name),
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  onChanged: (val) => _name = val.trim(),
                                  enabled: nameEditable,
                                ),
                              ),
                              IconButton(
                                icon: isButtonClicked
                                    ? const Icon(Icons.edit)
                                    : const Icon(Icons.check),
                                onPressed: () {
                                  if (_name!.isNotEmpty) {
                                    DatabaseService(uid: user!.uid)
                                        .updateUserName(_name!);
                                    _handleClick();
                                    _editableName();
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          const Text('Email:', style: TextStyle(fontSize: 18)),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller:
                                      TextEditingController(text: _email),
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                  ),
                                  enabled: false,
                                ),
                              ),
                              const IconButton(
                                  icon: Icon(Icons.lock_outline),
                                  onPressed: null),
                            ],
                          ),
                          const SizedBox(height: 64),
                          (_type == 'user') ? _buildSectionTitle('Soft Skills') : Container(),
                          const SizedBox(height: 16),
                          (_type == 'user') ? _buildAddItemSection(_softSkillController,
                              'Add a soft skill', user!.uid) : Container(),
                          const SizedBox(height: 16),
                          (_type == 'user') ? _buildItemList(_softSkills, user!.uid, 'softSkills') : Container(),
                          const SizedBox(height: 32),
                          (_type == 'user') ? _buildSectionTitle('Certificates') : Container(),
                          const SizedBox(height: 16),
                          (_type == 'user') ? _buildAddItemSection(_certificateController,
                              'Add a certificate', user!.uid) : Container(),
                          const SizedBox(height: 16),
                          (_type == 'user') ? _buildItemList(
                              _certificates, user!.uid, 'certificates') : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
          } else {
            return const Center(
              child: Icon(
                Icons.question_mark_outlined,
                size: 300
              ),
            );
          }
        });
  }

  Widget _buildSectionTitle(String title) {
    if (_name == 'Anonymous') return Container();
    return Text(title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold));
  }

  Widget _buildAddItemSection(
      TextEditingController controller, String hintText, String uid) {
    if (_name == 'Anonymous') return Container();
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: () {
            if (hintText == 'Add a soft skill') {
              _softSkills.add(controller.text);
              DatabaseService(uid: uid).updateUserSoftSkills(_softSkills);
            } else {
              _certificates.add(controller.text);
              DatabaseService(uid: uid).updateUserCertificates(_certificates);
            }
            controller.clear();
          },
        ),
      ],
    );
  }

  Widget _buildItemList(List<String> items, String uid, String type) {
    return Expanded(
      child: Container(
        color: Colors.grey[200],
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(items[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  if (type == 'softSkills') {
                    _softSkills.removeAt(index);
                    DatabaseService(uid: uid).updateUserSoftSkills(_softSkills);
                  } else {
                    _certificates.removeAt(index);
                    DatabaseService(uid: uid)
                        .updateUserCertificates(_certificates);
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
