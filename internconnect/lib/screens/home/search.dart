import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:internconnect/screens/home/internship_details.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
        'https://api.itjobs.pt/job/search.json?api_key=de6360c75f724fa56dca63fcca4dfaed&page=$_page&q=$_query'));

    if (response.statusCode == 200) {
      Map<String, dynamic> temp = jsonDecode(response.body);
      List<dynamic> jsonData = [];
      if (temp['total'] != 0) {
        jsonData = temp['results'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No results found'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      setState(() => _jsonData.addAll(jsonData));
      _page++;
    } else {
      throw Exception('Failed to load data from API');
    }

    setState(() => _loading = false);
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
    String cities = '', fulltime = '';
    if (locations![index]['locations'] != null) {
      for (int i = 0; i < locations[index]['locations'].length; i++) {
        if (i != 0) cities += ', ';
        cities += locations[index]['locations'][i]['name'];
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
    if (locations[index]['types'] != null) {
      fulltime = locations[index]['types'][0]['name'];
      list.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer_outlined, color: Colors.red),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
              child: Text(fulltime),
            )
          ],
        ),
      ));
    }
    if (locations[index]['allowRemote']) {
      list.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.wifi, color: Colors.red),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
              child: Text('Remote'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for internships',
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
                          InternshipDetails(id: _jsonData[index]['id']),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              ListTile(
                                title: Text(_jsonData[index]['title']),
                                subtitle: Text(_jsonData[index]['company']['name']),
                                leading: Image.network(
                                  _jsonData[index]['company']['logo'],
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Wrap(
                                children: displayInfo(_jsonData, index)
                              ),
                            ],
                          ),
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
