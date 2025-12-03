// lib/features/rhymes/presentation/widgets/mini_player.dart

import 'package:flutter/material.dart';
import '../../domain/entities/rhyme_item.dart';

class MiniPlayer extends StatelessWidget {
  final RhymeItem rhyme;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;

  const MiniPlayer({
    super.key,
    required this.rhyme,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              rhyme.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: onPlayPause,
            icon: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: Colors.pinkAccent,
              size: 40,
            ),
          ),
          IconButton(
            onPressed: onStop,
            icon: const Icon(
              Icons.stop_circle_outlined,
              color: Colors.grey,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
