import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = 'John Doe';
  int _age = 25;
  final String? _email = FirebaseAuth.instance.currentUser?.email;
  List<String> _softSkills = [];
  List<String> _certificates = [];

  TextEditingController _softSkillController = TextEditingController();
  TextEditingController _certificateController = TextEditingController();

  void _addSoftSkill(String skill) {
    if (skill.isNotEmpty) {
      setState(() {
        _softSkills.add(skill);
      });
    }
  }

  void _addCertificate(String certificate) {
    if (certificate.isNotEmpty) {
      setState(() {
        _certificates.add(certificate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $_name', style: TextStyle(fontSize: 18)),
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
