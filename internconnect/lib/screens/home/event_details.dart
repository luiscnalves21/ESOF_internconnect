import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:internconnect/shared/loading.dart';

class EventDetails extends StatefulWidget {
  final int id;
  const EventDetails({Key? key, required this.id}) : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  late Future<Map<String, dynamic>> _jsonData;

  Future<Map<String, dynamic>> _fetchJsonData() async {
    final response = await http.get(Uri.parse(
        'https://api.itjobs.pt/event/get.json?api_key=de6360c75f724fa56dca63fcca4dfaed&id=${widget.id}'));
    if (response.statusCode == 200) {
      final jsonResult = jsonDecode(response.body);
      return jsonResult;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  List<Widget> displayPaid(Map<String, dynamic> listMap) {
    List<Widget> widgets = [];
    String isPaid = '';
    if (listMap['isPaid']) {
      isPaid = 'Paid Event';
    } else {
      isPaid = 'Free Event';
    }
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            Icon(Icons.euro_symbol_rounded, color: Colors.red),
          ],
        ),
      ),
    );
    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cost',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            isPaid,
          )
        ],
      ),
    );
    return widgets;
  }

  List<Widget> displayContact(Map<String, dynamic> listMap) {
    List<Widget> widgets = [];
    String contact = '';
    if (listMap['email'] != '' || listMap['url'] != '') {
      if (listMap['email'] != '') {
        contact += 'Email';
        if (listMap['url'] != '') {
          contact += ' - Website';
        }
      } else if (listMap['url'] != '') {
        contact += 'Website';
      }
    } else {
      return List.empty();
    }
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            Icon(Icons.email_outlined, color: Colors.red),
          ],
        ),
      ),
    );
    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Duration',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            contact,
          )
        ],
      ),
    );
    return widgets;
  }

  List<Widget> displayLocation(Map<String, dynamic> listMap) {
    List<Widget> widgets = [];
    String cities = '';
    for (int i = 0; i < listMap['locations'].length; i++) {
      if (i != 0) cities += ', ';
      cities += listMap['locations'][i]['name'];
    }
    if (cities == '') {
      return List.empty();
    }
    if (listMap['place'] != '') {
      cities += ' - ${listMap['place']}';
    }
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            Icon(Icons.euro_symbol_rounded, color: Colors.red),
          ],
        ),
      ),
    );
    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            cities,
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
        title: const Text('Event'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _jsonData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final jsonData = snapshot.data!;
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
                              const SizedBox(height: 10),
                              Text(jsonData['title'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  '${jsonData['dateStart']} - ${jsonData['dateEnd']}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: displayPaid(jsonData),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: displayContact(jsonData),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: displayLocation(jsonData),
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
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              const Text(
                                'Event Description',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(jsonData['description']),
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
