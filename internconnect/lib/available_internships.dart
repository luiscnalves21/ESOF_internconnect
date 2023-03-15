import 'package:flutter/material.dart';

class AvailableInternshipsPage extends StatefulWidget {
  const AvailableInternshipsPage({super.key});

  @override
  State<AvailableInternshipsPage> createState() =>
      _AvailableInternshipsPageState();
}

class _AvailableInternshipsPageState extends State<AvailableInternshipsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Internships'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: Column(children: [
        Image.asset('images/firstImage.jpg'),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          color: Colors.black,
        ),
        Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          color: Colors.blue,
          child: const Center(
            child: Text(
              'Name of company',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: (){},
          child: const Text('Next')
        ),
        OutlinedButton(
          onPressed: (){},
          child: const Text('Previous')
        ),
      ]),
    );
  }
}
