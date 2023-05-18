import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:internconnect/shared/loading.dart';

class CourseDetails extends StatefulWidget {
  final int id;
  const CourseDetails({Key? key, required this.id}) : super(key: key);

  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  late Future<Map<String, dynamic>> _jsonData;

  Future<Map<String, dynamic>> _fetchJsonData() async {
    final response = await http.get(Uri.parse(
        'https://api.itjobs.pt/course/get.json?api_key=de6360c75f724fa56dca63fcca4dfaed&id=${widget.id}'));
    if (response.statusCode == 200) {
      final jsonResult = jsonDecode(response.body);
      return jsonResult;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  List<Widget> displayCertified(Map<String, dynamic> listMap) {
    List<Widget> widgets = [];
    String certified = '';
    if (listMap['isCertified']) {
      certified = 'Yes';
    } else {
      certified = 'No';
    }
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            Icon(Icons.text_snippet_outlined, color: Colors.red),
          ],
        ),
      ),
    );
    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Certified',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            certified,
          )
        ],
      ),
    );
    return widgets;
  }

  List<Widget> displayHours(Map<String, dynamic> listMap) {
    List<Widget> widgets = [];
    String hours = '';
    if (listMap['hours'] != null) {
      hours = '${listMap['hours']}h';
    } else {
      return List.empty();
    }
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
    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Duration',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            hours,
          )
        ],
      ),
    );
    return widgets;
  }

  List<Widget> displayPrice(Map<String, dynamic> listMap) {
    List<Widget> widgets = [];
    String price = '';
    if (listMap['price'] != null) {
      price = '€${listMap['price']}';
    } else {
      return List.empty();
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
            'Price',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            price,
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
        title: const Text('Course'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _jsonData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final jsonData = snapshot.data!;
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
                                children: displayCertified(jsonData),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: displayHours(jsonData),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: displayPrice(jsonData),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(jsonData['company']['description']),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Text(
                                'Course Description',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              //Html(data: documentHtml.body!.outerHtml.substring(0,documentHtml.body!.outerHtml.indexOf('<p style=\"visibility: hidden;\"'))),
                              Html(data: documentHtml.body!.outerHtml),
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
