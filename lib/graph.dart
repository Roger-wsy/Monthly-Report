import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/scheduler.dart';
import 'user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Graph_monthly extends StatefulWidget {
  const Graph_monthly({Key? key}) : super(key: key);

  @override
  State<Graph_monthly> createState() => _Graph_monthlyState();
}

class _Graph_monthlyState extends State<Graph_monthly> {
  List<User> chartData = <User>[];

  @override
  void initState() {
    getDataFromFireStore().then(
      (results) => print("Successfully completed"),
      onError: (e) => print("Error completing: $e"),
    );
    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue =
        await FirebaseFirestore.instance.collection('users').get();
    List<User> list = snapShotsValue.docs
        .map((docs) => User(
            birthday: docs.data()['birthday'].toDate(),
            name: docs.data()['name'],
            height: docs.data()['height'],
            weight: docs.data()['weight']))
        .toList();
    setState(() {
      chartData = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis'),
      ),
      body: StreamBuilder<List<User>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;

            return SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                primaryYAxis: NumericAxis(),
                title: ChartTitle(text: 'Systolic Blood Pressure Analysis'),
                series: <ChartSeries<User, DateTime>>[
                  LineSeries<User, DateTime>(
                    dataSource: chartData,
                    xValueMapper: (User users, _) => users.birthday,
                    yValueMapper: (User users, _) => users.height,
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  )
                ]);

            // return ListView(
            //   children: users.map(buildUser).toList(),
            // );
          }
          if (snapshot.hasError) {
            return Text('Error!');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<dynamic>> getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('collectionName').get();
    final alldata = querySnapshot.docs.map((doc) => doc.data()).toList();
    return alldata;
  }

  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
}
