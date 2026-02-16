import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final String image;
  final String icon;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.icon,
    required this.color,
  });

  String? get backgroundImage => null;
}
