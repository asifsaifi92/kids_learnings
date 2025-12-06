
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids/core/audio/sound_manager.dart';
import 'package:kids/features/challenges/presentation/provider/daily_challenge_provider.dart';
import 'package:kids/features/rewards/presentation/provider/achievements_provider.dart';
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

class _StoryReaderPageState extends State<StoryReaderPage> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _autoPlay = true; // Auto-read when page turns

  // Animation for tapping the image
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    // Hide status bar for immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Initial play delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _autoPlay) _playCurrentPage();
    });
  }

  @override
  void dispose() {
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _bounceController.dispose();
    Provider.of<StoriesProvider>(context, listen: false).stop();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    // Stop previous audio
    Provider.of<StoriesProvider>(context, listen: false).stop();
    
    // Auto-play new page
    if (_autoPlay) {
      _playCurrentPage();
    }
  }

  void _playCurrentPage() {
    final prov = Provider.of<StoriesProvider>(context, listen: false);
    final pageText = widget.story.pages[_currentPage].text;
    prov.playPage(pageText).then((_) {
      if (!prov.isPlaying && _currentPage == widget.story.pages.length - 1) {
        // Story Completed
        _handleStoryCompletion(prov);
      }
    });
  }

  void _handleStoryCompletion(StoriesProvider prov) {
    if (!prov.completedStories.contains(widget.story.title)) {
      context.read<DailyChallengeProvider>().updateProgress(ChallengeType.ReadStories);
      // Achievement: Bookworm
      context.read<AchievementsProvider>().incrementProgress('bookworm');
    }
    prov.markStoryAsCompleted(widget.story);
    SoundManager().playSuccess();
  }

  void _handleImageTap() {
    _bounceController.forward().then((_) => _bounceController.reverse());
    SoundManager().playPop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // 1. Main Page View
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.story.pages.length,
              itemBuilder: (context, index) {
                final page = widget.story.pages[index];
                return _buildStoryPage(page);
              },
            ),

            // 2. Top Bar (Back & Title)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  children: [
                    FloatingActionButton.small(
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.story.title,
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 4, color: Colors.black45)]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Auto-Play Toggle
                    IconButton(
                      icon: Icon(_autoPlay ? Icons.volume_up : Icons.volume_off, color: Colors.white),
                      onPressed: () {
                        setState(() => _autoPlay = !_autoPlay);
                        if (!_autoPlay) {
                          Provider.of<StoriesProvider>(context, listen: false).stop();
                        } else {
                          _playCurrentPage();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 3. Bottom Controls
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: _buildControls(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryPage(StoryPageItem page) {
    return Column(
      children: [
        // Image Area (Top 60%)
        Expanded(
          flex: 6,
          child: GestureDetector(
            onTap: _handleImageTap,
            child: ScaleTransition(
              scale: _bounceAnimation,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 80, 16, 16), // Top margin for header
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 8))
                  ],
                  image: page.imageAsset != null
                      ? DecorationImage(image: AssetImage(page.imageAsset!), fit: BoxFit.cover)
                      : null,
                ),
                child: page.imageAsset == null
                    ? const Center(child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey))
                    : null,
              ),
            ),
          ),
        ),

        // Text Area (Bottom 40%)
        Expanded(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))
              ],
            ),
            child: SingleChildScrollView(
              child: Consumer<StoriesProvider>(
                builder: (context, sp, _) {
                  return RhymeLyrics(
                    text: page.text,
                    activeWordIndex: sp.currentWordIndex,
                    style: const TextStyle(
                      fontSize: 24,
                      height: 1.6,
                      color: Colors.black87,
                      fontFamily: 'Georgia', // Serif font for storybook feel
                    ),
                    activeStyle: const TextStyle(
                      fontSize: 26,
                      height: 1.6,
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Color(0xFFE1BEE7), // Purple highlight
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 100), // Space for controls
      ],
    );
  }

  Widget _buildControls() {
    final prov = Provider.of<StoriesProvider>(context);
    final isLastPage = _currentPage == widget.story.pages.length - 1;
    final isFirstPage = _currentPage == 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous
        FloatingActionButton(
          heroTag: 'prev',
          backgroundColor: isFirstPage ? Colors.grey.shade300 : Colors.white,
          elevation: isFirstPage ? 0 : 4,
          onPressed: isFirstPage ? null : () {
            _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
          },
          child: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
        ),

        // Dots Indicator
        DotsIndicator(
          dotsCount: widget.story.pages.length,
          position: _currentPage.round(),
          decorator: DotsDecorator(
            activeColor: Colors.deepPurple,
            color: Colors.deepPurple.shade100,
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
        ),

        // Next or Finish
        FloatingActionButton(
          heroTag: 'next',
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            if (isLastPage) {
              Navigator.pop(context);
            } else {
              _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
            }
          },
          child: Icon(isLastPage ? Icons.check : Icons.arrow_forward_rounded, color: Colors.white),
        ),
      ],
    );
  }
}
