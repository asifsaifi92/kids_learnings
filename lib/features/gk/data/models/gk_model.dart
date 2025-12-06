import 'package:flutter/material.dart';

class GKItem {
  final String name;
  final String imagePath; // Path to image or icon asset
  final String description;

  GKItem({
    required this.name,
    required this.imagePath,
    required this.description,
  });
}

class GKTopic {
  final String title;
  final IconData icon;
  final Color color;
  final List<GKItem> items;

  GKTopic({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
}
