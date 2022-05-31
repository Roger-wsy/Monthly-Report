import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  String toString() {
    // TODO: implement toString
    return 'Record<$name:$height:$weight>';
  }
}
