import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = 'John Doe';
  TextEditingController _nameController = TextEditingController();
  int _age = 25;
  final String? _email = FirebaseAuth.instance.currentUser?.email;
  List<String> _softSkills = [];
  List<String> _certificates = [];

  TextEditingController _softSkillController = TextEditingController();
  TextEditingController _certificateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot document = await users.doc(user.uid).get();

    if (document.exists) {
      setState(() {
        _nameController.text = document['name'];
        _age = document['age'];
        _softSkills = List<String>.from(document['softSkills']);
        _certificates = List<String>.from(document['certificates']);
      });
    }
  }

  Future<void> _saveData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(user.uid).set({
      'name': _name,
      'age': _age,
      'email': _email,
      'softSkills': _softSkills,
      'certificates': _certificates,
    });
  }


  void _addSoftSkill(String skill) {
    if (skill.isNotEmpty) {
      setState(() {
        _softSkills.add(skill);
      });
      _saveData();
    }
  }

  void _addCertificate(String certificate) {
    if (certificate.isNotEmpty) {
      setState(() {
        _certificates.add(certificate);
      });
      _saveData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(fontSize: 60.0, color: Colors.red, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 60.0),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _name = value;
                    _saveData();
                  },
                ),
                const SizedBox(height: 16.0),
                Text('Age: $_age', style: TextStyle(fontSize: 18)),
                Text('Email: $_email', style: TextStyle(fontSize: 18)),
                SizedBox(height: 16),
                _buildSectionTitle('Soft Skills'),
                _buildAddItemSection(_softSkillController, 'Add a soft skill', _addSoftSkill),
                _buildItemList(_softSkills),
                SizedBox(height: 16),
                _buildSectionTitle('Certificates'),
                _buildAddItemSection(_certificateController, 'Add a certificate', _addCertificate),
                _buildItemList(_certificates),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold));
  }

  Widget _buildAddItemSection(TextEditingController controller, String hintText, Function(String) onAdd) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_circle),
          onPressed: () {
            onAdd(controller.text);
            controller.clear();
          },
        ),
      ],
    );
  }

  Widget _buildItemList(List<String> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(items[index]),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => setState(() => items.removeAt(index)),
        ),
      ),
    );
  }
}
