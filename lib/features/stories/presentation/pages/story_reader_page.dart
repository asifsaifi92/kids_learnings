// lib/features/stories/presentation/pages/story_reader_page.dart

import 'package:flutter/material.dart';
import 'package:kids/features/challenges/presentation/provider/daily_challenge_provider.dart';
import 'package:provider/provider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../../domain/entities/story_item.dart';
import '../provider/stories_provider.dart';
import 'package:kids/features/rhymes/presentation/widgets/rhyme_lyrics.dart';

class StoryReaderPage extends StatefulWidget {
  final StoryItem story;

  const StoryReaderPage({super.key, required this.story});

  @override
  State<StoryReaderPage> createState() => _StoryReaderPageState();
}

class _StoryReaderPageState extends State<StoryReaderPage> {
  final PageController _pageController = PageController();
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<StoriesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.lightBlue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.story.pages.length,
                itemBuilder: (context, index) {
                  final page = widget.story.pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                image: page.imageAsset != null
                                    ? DecorationImage(
                                        image: AssetImage(page.imageAsset!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: page.imageAsset == null
                                  ? const Center(
                                      child: Icon(Icons.image, size: 100, color: Colors.grey),
                                    )
                                  : null,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24.0),
                              child: Consumer<StoriesProvider>(
                                builder: (context, sp, _) {
                                  return RhymeLyrics(
                                    text: page.text,
                                    activeWordIndex: sp.currentWordIndex,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      height: 1.5,
                                      color: Colors.black87,
                                    ),
                                    activeStyle: const TextStyle(
                                      fontSize: 24,
                                      height: 1.5,
                                      color: Colors.pinkAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: DotsIndicator(
                dotsCount: widget.story.pages.length,
                position: _currentPage.round(),
                decorator: DotsDecorator(
                  activeColor: Colors.deepPurple,
                  color: Colors.grey.shade400,
                  size: const Size.square(12.0),
                  activeSize: const Size(24.0, 12.0),
                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),
            Consumer<StoriesProvider>(
              builder: (context, prov, _) {
                return SwitchListTile.adaptive(
                  value: prov.replayOnResume,
                  onChanged: (v) => prov.replayOnResume = v,
                  title: const Text('Replay last word on resume'),
                  contentPadding: EdgeInsets.zero,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: 'prev',
                    onPressed: () {
                      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    },
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.arrow_back, color: Colors.deepPurple),
                  ),
                  FloatingActionButton(
                    heroTag: 'play',
                    onPressed: () {
                      final currentPageIndex = _currentPage.round();
                      final pageText = widget.story.pages[currentPageIndex].text;
                      if (prov.isPlaying) {
                        if (prov.isPaused) {
                          prov.resume();
                        } else {
                          prov.pause();
                        }
                      } else {
                        prov.playPage(pageText).then((_) {
                          if (!prov.isPlaying && currentPageIndex == widget.story.pages.length - 1) {
                            if (!prov.completedStories.contains(widget.story.title)) {
                                context.read<DailyChallengeProvider>().updateProgress(ChallengeType.ReadStories);
                            }
                            prov.markStoryAsCompleted(widget.story);
                          }
                        });
                      }
                    },
                    backgroundColor: Colors.pinkAccent,
                    child: Icon(
                      prov.isPlaying ? (prov.isPaused ? Icons.play_arrow : Icons.pause) : Icons.volume_up,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: 'next',
                    onPressed: () {
                      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    },
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.arrow_forward, color: Colors.deepPurple),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
