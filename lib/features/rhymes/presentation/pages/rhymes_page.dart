// lib/features/rhymes/presentation/pages/rhymes_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/rhymes_provider.dart';
import '../widgets/rhyme_card.dart';
import '../widgets/mini_player.dart';

class RhymesPage extends StatefulWidget {
  const RhymesPage({super.key});
  static const routeName = '/rhymes';

  @override
  State<RhymesPage> createState() => _RhymesPageState();
}

class _RhymesPageState extends State<RhymesPage> {
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<RhymesProvider>(context, listen: false).load();
      });
      _didInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<RhymesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nursery Rhymes'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.pinkAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade50, Colors.pink.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(24.0),
                      itemCount: prov.items.length,
                      itemBuilder: (context, index) {
                        final item = prov.items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: RhymeCard(rhyme: item, onPlay: () => prov.play(item)),
                        );
                      },
                    ),
                  ),
                  if (prov.currentlyPlaying != null)
                    MiniPlayer(
                      rhyme: prov.currentlyPlaying!,
                      isPlaying: prov.isPlaying,
                      onPlayPause: () {
                        if (prov.isPlaying) {
                          prov.pause();
                        } else {
                          prov.resume();
                        }
                      },
                      onStop: () => prov.stop(),
                    ),
                ],
              ),
            ),
    );
  }
}
