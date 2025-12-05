// lib/features/rhymes/presentation/pages/rhyme_detail_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/rhymes_provider.dart';
import '../../domain/entities/rhyme_item.dart';
import '../widgets/play_button.dart';
import '../widgets/rhyme_lyrics.dart';

class RhymeDetailPage extends StatelessWidget {
  final RhymeItem rhyme;

  const RhymeDetailPage({super.key, required this.rhyme});

  @override
  Widget build(BuildContext context) {
    // Use Consumer so the lyrics area rebuilds when currentWordIndex changes
    return Scaffold(
      appBar: AppBar(
        title: Text(rhyme.title),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF81C7F5), Color(0xFFB3E5FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6AE398), Color(0xFF50C878)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Consumer<RhymesProvider>(
                builder: (context, prov, _) {
                  return RhymeLyrics(
                    text: rhyme.lyrics,
                    activeWordIndex: prov.currentWordIndex,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                    activeStyle: const TextStyle(
                      fontSize: 26,
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  );
                },
              ),
              Consumer<RhymesProvider>(
                builder: (context, prov, _) {
                  return SwitchListTile.adaptive(
                    value: prov.replayOnResume,
                    onChanged: (v) => prov.replayOnResume = v,
                    title: const Text('Replay last word on resume', style: TextStyle(color: Colors.white)),
                    activeColor: Colors.yellowAccent,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  );
                },
              ),
              const SizedBox(height: 40),
              Consumer<RhymesProvider>(
                builder: (context, prov, _) {
                  return PlayButton(
                    onTap: () {
                      if (prov.isPlaying) {
                        if (prov.isPaused) {
                          prov.resume(rhyme);
                        } else {
                          prov.pause();
                        }
                      } else {
                        prov.playRhyme(rhyme);
                      }
                    },
                    isPlaying: prov.isPlaying,
                    isPaused: prov.isPaused,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
