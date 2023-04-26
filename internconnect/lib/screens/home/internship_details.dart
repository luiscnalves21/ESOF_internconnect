import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internconnect/shared/loading.dart';

class InternshipDetails extends StatefulWidget {
  final int id;
  const InternshipDetails({Key? key, required this.id}) : super(key: key);

  @override
  _InternshipDetailsState createState() => _InternshipDetailsState();
}

class _InternshipDetailsState extends State<InternshipDetails> {
  late Future<Map<String, dynamic>> _jsonData;

  Future<Map<String, dynamic>> _fetchJsonData() async {
    final response = await http.get(Uri.parse(
        'https://api.itjobs.pt/job/get.json?api_key=de6360c75f724fa56dca63fcca4dfaed&id=${widget.id}'));
    if (response.statusCode == 200) {
      final jsonResult = jsonDecode(response.body);
      return jsonResult;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    _jsonData = _fetchJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON Data'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _jsonData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final jsonData = snapshot.data!;
            final fileName = jsonData['slug'];
            return Text('File name: $fileName');
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Loading();
        },
      ),
    );
  }
}
