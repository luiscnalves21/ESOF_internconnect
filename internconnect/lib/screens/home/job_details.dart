import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:internconnect/shared/loading.dart';

class JobDetails extends StatefulWidget {
  final int id;
  const JobDetails({Key? key, required this.id}) : super(key: key);

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
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

  List<Widget> displayLocations(Map<String, dynamic> listMap) {
    if (listMap['locations'] == null) return List.empty();
    List<dynamic> list = listMap['locations'];
    if (list.isEmpty) return List.empty();
    List<Widget> widgets = [];
    String locations = '';
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            Icon(Icons.location_on_outlined, color: Colors.red),
          ],
        ),
      ),
    );
    for (int i = 0; i < list.length; i++) {
      if (i != 0) locations += ', ';
      locations += list.elementAt(i)['name'];
    }
    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            locations,
          )
        ],
      ),
    );
    return widgets;
  }

  List<Widget> displaySchedule(Map<String, dynamic> listMap) {
    if (listMap['types'] == null) return List.empty();
    List<dynamic> list = listMap['types'];
    if (list.isEmpty) return List.empty();
    List<Widget> widgets = [];
    String locations = '';
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            Icon(Icons.timer_outlined, color: Colors.red),
          ],
        ),
      ),
    );
    for (int i = 0; i < list.length; i++) {
      if (i != 0) locations += ', ';
      locations += list.elementAt(i)['name'];
    }
    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Schedule',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            locations,
          )
        ],
      ),
    );
    return widgets;
  }

  List<Widget> displayRemote(Map<String, dynamic> listMap) {
    List<Widget> widgets = [];
    String remote = '';
    if (listMap['allowRemote']) {
      remote = 'Yes';
    } else {
      remote = 'No';
    }
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            Icon(Icons.wifi, color: Colors.red),
          ],
        ),
      ),
    );
    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Remote',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            remote,
          )
        ],
      ),
    );
    return widgets;
  }

  String toHtml(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;
    return parsedString;
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
        title: const Text('Company'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _jsonData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final jsonData = snapshot.data!;
            print(jsonData);
            String myHtml = jsonData['body'];
            var documentHtml = parse(myHtml);
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(
                              color: Color.fromARGB(255, 255, 172, 172),
                              width: 1.0,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.network(jsonData['company']['logo']),
                              const SizedBox(height: 10),
                              Text(jsonData['title'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text(jsonData['company']['name']),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: displayLocations(jsonData),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(children: displaySchedule(jsonData)),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: displayRemote(jsonData),
                              )
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(
                              color: Color.fromARGB(255, 255, 172, 172),
                              width: 1.0,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Company Description:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(jsonData['company']['description']),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Job Description',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Html(
                                  data: documentHtml.body!.outerHtml.substring(
                                      0,
                                      documentHtml.body!.outerHtml.indexOf(
                                          '<p style=\"visibility: hidden;\"'))),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Loading();
        },
      ),
    );
  }
}
