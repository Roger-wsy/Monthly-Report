import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:monthly_report/input_page.dart';
import 'firebase_options.dart';
import 'graph.dart';
import 'diastolic_graph.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controllerName = TextEditingController();
  final controllerHeight = TextEditingController();
  final controllerWeight = TextEditingController();
  final controllerDate = TextEditingController();

  int index = 0;

  final screens = [
    InputPage(title: 'Flutter Demo Home Page'),
    Graph_monthly(),
    Diatolic_graph(),
  ];

  final navigationKey = GlobalKey<CurvedNavigationBarState>();

  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(
      Icons.analytics_outlined,
      size: 30,
    ),
    Icon(
      Icons.analytics_sharp,
      size: 30,
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: screens[index],
        bottomNavigationBar: Theme(
          data: Theme.of(context)
              .copyWith(iconTheme: IconThemeData(color: Colors.white)),
          child: CurvedNavigationBar(
            key: navigationKey,
            backgroundColor: Colors.transparent,
            color: Colors.blue.shade700,
            buttonBackgroundColor: Colors.blue,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 300),
            items: items,
            height: 60,
            onTap: (index) => setState(() => this.index = index),
          ),
        ),
      );

  Future createUser(User user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;

    final json = user.toJson();
    await docUser.set(json);
  }
}

class User {
  String id;
  final String name;
  final double height;
  final double weight;
  final DateTime birthday;

  User({
    this.id = '',
    required this.name,
    required this.height,
    required this.weight,
    required this.birthday,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'height': height,
        'weight': weight,
        'birthday': birthday,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        height: json['height'],
        weight: json['weight'],
        birthday: (json['birthday'] as Timestamp).toDate(),
      );
}
