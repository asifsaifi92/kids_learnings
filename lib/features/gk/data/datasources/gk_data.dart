import 'package:flutter/material.dart';
import '../models/gk_model.dart';

final List<GKTopic> gkTopics = [
  GKTopic(
    title: 'Solar System',
    icon: Icons.public,
    color: Colors.indigo,
    items: [
      GKItem(name: 'Sun', imagePath: 'assets/images/gk/sun.png', description: 'The Star at the center of our Solar System.'),
      GKItem(name: 'Mercury', imagePath: 'assets/images/gk/mercury.png', description: 'The smallest planet and closest to the Sun.'),
      GKItem(name: 'Earth', imagePath: 'assets/images/gk/earth.png', description: 'Our home! The only planet known to support life.'),
      GKItem(name: 'Mars', imagePath: 'assets/images/gk/mars.png', description: 'The Red Planet, known for its red dust.'),
      GKItem(name: 'Jupiter', imagePath: 'assets/images/gk/jupiter.png', description: 'The largest planet in our Solar System.'),
    ],
  ),
  GKTopic(
    title: 'Seasons',
    icon: Icons.ac_unit,
    color: Colors.blue,
    items: [
      GKItem(name: 'Spring', imagePath: 'assets/images/gk/spring.png', description: 'Flowers bloom and trees grow new leaves.'),
      GKItem(name: 'Summer', imagePath: 'assets/images/gk/summer.png', description: 'The hottest season, perfect for the beach!'),
      GKItem(name: 'Autumn', imagePath: 'assets/images/gk/autumn.png', description: 'Leaves change color and fall from trees.'),
      GKItem(name: 'Winter', imagePath: 'assets/images/gk/winter.png', description: 'The coldest season, sometimes with snow!'),
    ],
  ),
  GKTopic(
    title: 'Days of Week',
    icon: Icons.calendar_today,
    color: Colors.orange,
    items: [
      GKItem(name: 'Monday', imagePath: '', description: 'The first day of the school week.'),
      GKItem(name: 'Tuesday', imagePath: '', description: 'The second day of the week.'),
      GKItem(name: 'Wednesday', imagePath: '', description: 'The middle of the work week!'),
      GKItem(name: 'Thursday', imagePath: '', description: 'Almost the weekend!'),
      GKItem(name: 'Friday', imagePath: '', description: 'The last day of the school week.'),
      GKItem(name: 'Saturday', imagePath: '', description: 'The start of the weekend!'),
      GKItem(name: 'Sunday', imagePath: '', description: 'A day for rest and family.'),
    ],
  ),
  GKTopic(
    title: 'Rainbow Colors',
    icon: Icons.palette,
    color: Colors.purple,
    items: [
      GKItem(name: 'Red', imagePath: '', description: 'The first color of the rainbow.'),
      GKItem(name: 'Orange', imagePath: '', description: 'A bright and energetic color.'),
      GKItem(name: 'Yellow', imagePath: '', description: 'The color of sunshine.'),
      GKItem(name: 'Green', imagePath: '', description: 'The color of nature and grass.'),
      GKItem(name: 'Blue', imagePath: '', description: 'The color of the sky and ocean.'),
      GKItem(name: 'Indigo', imagePath: '', description: 'A deep blue-purple color.'),
      GKItem(name: 'Violet', imagePath: '', description: 'A light purple color.'),
    ],
  ),
];
