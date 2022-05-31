import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'graph.dart';
import 'user.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final controllerName = TextEditingController();
  final controllerHeight = TextEditingController();
  final controllerWeight = TextEditingController();
  final controllerDate = TextEditingController();

  int index = 0;

  final navigationKey = GlobalKey<CurvedNavigationBarState>();

  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(
      Icons.analytics_outlined,
      size: 30,
    )
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Add User'),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: controllerName,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(
              height: 24,
            ),
            TextField(
              controller: controllerHeight,
              decoration: InputDecoration(labelText: 'Systolic (mm Hg)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(
              height: 24,
            ),
            TextField(
              controller: controllerWeight,
              decoration: InputDecoration(labelText: 'Diastolic (mm Hg)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(
              height: 24,
            ),
            DateTimeField(
              controller: controllerDate,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(labelText: 'Date'),
              format: DateFormat('yyyy-MM-dd'),
              onShowPicker: (context, currentValue) async {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                final user = User(
                  name: controllerName.text,
                  height: double.parse(controllerHeight.text),
                  weight: double.parse(controllerWeight.text),
                  birthday: DateTime.parse(controllerDate.text),
                );

                createUser(user);

                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text(
                        "You have submitted the info. Remember you are adviced to submit twice a day."),
                    content: Image.asset('assets/doctor.png'),
                  ),
                );
              },
            ),
          ],
        ),
      );

  Future createUser(User user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;

    final json = user.toJson();
    await docUser.set(json);
  }
}
