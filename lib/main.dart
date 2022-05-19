import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

bool firstWash = true;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room Allocator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              document['name'],
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    document.reference
                        .update({'val_wash': !document['val_wash']});
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    fixedSize: Size(130, 70),
                    primary: document['val_wash']
                        ? Colors.blue
                        : Colors.red, // This is what you need!
                  ),
                  child: Text(
                    document['wash'],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    // firstWash = !firstWash;
                    document.reference
                        .update({'val_bath': !document['val_bath']});
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    fixedSize: Size(130, 70),
                    primary: document['val_bath']
                        ? Colors.blue
                        : Colors.red, // This is what you need!
                  ),
                  child: Text(
                    document['bath'],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    // firstWash = !firstWash;
                    document.reference
                        .update({'val_both': !document['val_both']});
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    fixedSize: Size(260, 70),
                    primary: document['val_both']
                        ? Colors.blue
                        : Colors.red, // This is what you need!
                  ),
                  child: Text(
                    document['both'],
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Allocator'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('room').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
              // itemExtent: 80.0,
              itemCount: (snapshot.data! as QuerySnapshot).docs.length,
              itemBuilder: (context, index) => _buildListItem(
                  context, (snapshot.data! as QuerySnapshot).docs[index]));
        },
      ),
    );
  }
}
