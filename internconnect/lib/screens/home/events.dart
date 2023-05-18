import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:internconnect/screens/home/event_details.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<dynamic> _jsonData = [];
  bool _loading = false;
  int _page = 1;
  String _query = ''; // user's search query
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getDataFromApi();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // user has reached the bottom of the list
      _getDataFromApi();
    }
  }

  Future<void> _getDataFromApi() async {
    if (_loading) {
      // data is already being loaded
      return;
    }

    setState(() => _loading = true);

    final response = await http.get(Uri.parse(
        'https://api.itjobs.pt/event/search.json?api_key=de6360c75f724fa56dca63fcca4dfaed&page=$_page&q=$_query'));

    if (response.statusCode == 200) {
      Map<String, dynamic> temp = jsonDecode(response.body);
      List<dynamic> jsonData = [];
      if (temp['total'] != 0 && temp['results'] != null) {
        jsonData = temp['results'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No results found'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      if (mounted) setState(() => _jsonData.addAll(jsonData));
      _page++;
    } else {
      throw Exception('Failed to load data from API');
    }

    if (mounted) setState(() => _loading = false);
  }

  void _handleSearch(String query) {
    setState(() {
      _query = query;
      _jsonData.clear();
      _page = 1;
    });
    _getDataFromApi();
  }

  List<Widget> displayInfo(List<dynamic>? locations, int index) {
    List<Widget> list = [];
    String isPaid = '', contact = '', cities = '';
    if (locations![index]['isPaid']) {
      isPaid = 'Paid Event';
    } else {
      isPaid = 'Free Event';
    }
    list.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.euro_symbol_rounded, color: Colors.red),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
            child: Text(isPaid),
          )
        ],
      ),
    ));
    if (locations[index]['email'] != '' || locations[index]['url'] != '') {
      if (locations[index]['email'] != '') {
        contact += 'Email';
        if (locations[index]['url'] != '') {
          contact += ' - Website';
        }
      } else if (locations[index]['url'] != '') {
        contact += 'Website';
      }
    }
    list.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.email_outlined, color: Colors.red),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
            child: Text(contact),
          )
        ],
      ),
    ));
    if (locations[index]['locations'] != null) {
      for (int i = 0; i < locations[index]['locations'].length; i++) {
        if (i != 0) cities += ', ';
        cities += locations[index]['locations'][i]['name'];
      }
      if (locations[index]['place'] != '') {
        cities += ' - ';
        cities += locations[index]['place'];
      }
      list.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on_outlined, color: Colors.red),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
              child: Text(cities),
            )
          ],
        ),
      ));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for events',
                fillColor: Colors.white,
                filled: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black12,
                    width: 1.0,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2.0,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _handleSearch(_searchController.text),
                ),
              ),
              onSubmitted: _handleSearch,
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _jsonData.length + (_loading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _jsonData.length) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: const SpinKitFadingCircle(
                      color: Colors.red,
                      size: 50.0,
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EventDetails(id: _jsonData[index]['id']),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                          color: Colors.red,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              ListTile(
                                title: Text(_jsonData[index]['title']),
                                subtitle: Text('${_jsonData[index]['dateStart']} - ${_jsonData[index]['dateEnd']}'),
                              ),
                            ],
                          ),
                          Wrap(children: displayInfo(_jsonData, index)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    widget.onSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        onChanged: _handleSearch,
        decoration: const InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
