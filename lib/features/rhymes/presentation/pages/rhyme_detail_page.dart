// lib/features/rhymes/presentation/pages/rhyme_detail_page.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../provider/rhymes_provider.dart';
import '../../domain/entities/rhyme_item.dart';
import '../widgets/rhyme_lyrics.dart';

class RhymeDetailPage extends StatefulWidget {
  final RhymeItem rhyme;

  const RhymeDetailPage({super.key, required this.rhyme});

  @override
  State<RhymeDetailPage> createState() => _RhymeDetailPageState();
}

class _RhymeDetailPageState extends State<RhymeDetailPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Stop audio when leaving the page
    Provider.of<RhymesProvider>(context, listen: false).stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Pause audio when app goes background
      Provider.of<RhymesProvider>(context, listen: false).pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<RhymesProvider>(
          builder: (context, prov, _) => Text(prov.currentRhyme?.title ?? widget.rhyme.title),
        ),
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
        child: Column(
          children: [
            // 1. Visualizer Area (Top 35%)
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                ),
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/mascot.json',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // 2. Lyrics Area (Middle 45%)
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Consumer<RhymesProvider>(
                    builder: (context, prov, _) {
                      final currentRhyme = prov.currentRhyme ?? widget.rhyme;
                      return RhymeLyrics(
                        text: currentRhyme.lyrics,
                        activeWordIndex: prov.currentWordIndex,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          height: 1.6,
                          letterSpacing: 0.5,
                        ),
                        activeStyle: const TextStyle(
                          fontSize: 24,
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.bold,
                          height: 1.6,
                          shadows: [Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(2, 2))],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // 3. Player Controls (Bottom 20%)
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Consumer<RhymesProvider>(
                  builder: (context, prov, _) {
                    final isPlaying = prov.isPlaying && !prov.isPaused;
                    final hasPrev = prov.items.indexOf(prov.currentRhyme ?? widget.rhyme) > 0;
                    final hasNext = prov.items.indexOf(prov.currentRhyme ?? widget.rhyme) < prov.items.length - 1;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Progress / Settings Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Sing Along Mode', style: TextStyle(color: Colors.white70)),
                            Switch(
                              value: prov.replayOnResume,
                              activeColor: Colors.yellow,
                              onChanged: (v) => prov.replayOnResume = v,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Control Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Previous
                            IconButton(
                              iconSize: 48,
                              icon: Icon(Icons.skip_previous_rounded, color: hasPrev ? Colors.white : Colors.white30),
                              onPressed: hasPrev ? prov.playPrevious : null,
                            ),
                            
                            // Play/Pause (Big)
                            GestureDetector(
                              onTap: () {
                                if (prov.isPlaying) {
                                  prov.isPaused ? prov.resume(prov.currentRhyme ?? widget.rhyme) : prov.pause();
                                } else {
                                  prov.playRhyme(prov.currentRhyme ?? widget.rhyme);
                                }
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: Icon(
                                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  size: 50,
                                  color: const Color(0xFF50C878),
                                ),
                              ),
                            ),

                            // Next
                            IconButton(
                              iconSize: 48,
                              icon: Icon(Icons.skip_next_rounded, color: hasNext ? Colors.white : Colors.white30),
                              onPressed: hasNext ? prov.playNext : null,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
