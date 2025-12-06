
import 'package:flutter/material.dart';
import 'package:kids/core/audio/sound_manager.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:provider/provider.dart';

class StickerAlbumPage extends StatefulWidget {
  static const routeName = '/sticker-album';
  const StickerAlbumPage({super.key});

  @override
  State<StickerAlbumPage> createState() => _StickerAlbumPageState();
}

class _StickerAlbumPageState extends State<StickerAlbumPage> {
  // List of stickers and cost (total stars needed to unlock)
  final List<StickerItem> _allStickers = [
    StickerItem('🌟', 1, 'Star'),
    StickerItem('🐶', 5, 'Puppy'),
    StickerItem('🐱', 10, 'Kitty'),
    StickerItem('🚀', 15, 'Rocket'),
    StickerItem('🌈', 20, 'Rainbow'),
    StickerItem('🦄', 25, 'Unicorn'),
    StickerItem('🦕', 30, 'Dino'),
    StickerItem('🍦', 35, 'Ice Cream'),
    StickerItem('⚽', 40, 'Ball'),
    StickerItem('🎸', 45, 'Guitar'),
    StickerItem('🚗', 50, 'Car'),
    StickerItem('👑', 60, 'Crown'),
  ];

  // Canvas State
  final List<PlacedSticker> _placedStickers = [];

  @override
  Widget build(BuildContext context) {
    final rewardsProv = Provider.of<RewardsProvider>(context);
    final totalStars = rewardsProv.rewardState.totalStars;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sticker Album'),
        backgroundColor: Colors.purpleAccent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.white),
                const SizedBox(width: 4),
                Text('$totalStars', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // 1. Creative Canvas (Top 60%)
          Expanded(
            flex: 6,
            child: DragTarget<StickerItem>(
              onAcceptWithDetails: (details) {
                // Calculate relative position
                final RenderBox box = context.findRenderObject() as RenderBox;
                final Offset localOffset = box.globalToLocal(details.offset);
                // Adjust for app bar height roughly if needed, but standard drag target works
                
                setState(() {
                  _placedStickers.add(PlacedSticker(
                    emoji: details.data.emoji,
                    position: details.offset - const Offset(0, 80), // Adjust for app bar roughly
                  ));
                });
                SoundManager().playPop();
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/stories/park.png'), // Placeholder or use gradient
                      fit: BoxFit.cover,
                      opacity: 0.3,
                    ),
                    border: Border(bottom: BorderSide(color: Colors.purple.shade100, width: 4)),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Text(
                          'Drag stickers here!',
                          style: TextStyle(color: Colors.black12, fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ..._placedStickers.map((sticker) => Positioned(
                        left: sticker.position.dx,
                        top: sticker.position.dy,
                        child: Draggable(
                          feedback: Text(sticker.emoji, style: const TextStyle(fontSize: 60)),
                          childWhenDragging: Container(),
                          onDragEnd: (details) {
                            setState(() {
                              sticker.position = details.offset - const Offset(0, 80);
                            });
                          },
                          child: Text(sticker.emoji, style: const TextStyle(fontSize: 60)),
                        ),
                      )),
                    ],
                  ),
                );
              },
            ),
          ),

          // 2. Sticker Collection (Bottom 40%)
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.purple.shade50,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Collection', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _allStickers.length,
                      itemBuilder: (context, index) {
                        final sticker = _allStickers[index];
                        final isUnlocked = totalStars >= sticker.cost;

                        if (isUnlocked) {
                          return Draggable<StickerItem>(
                            data: sticker,
                            feedback: Material(
                              color: Colors.transparent,
                              child: Text(sticker.emoji, style: const TextStyle(fontSize: 60)),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                              ),
                              child: Center(child: Text(sticker.emoji, style: const TextStyle(fontSize: 40))),
                            ),
                          );
                        } else {
                          // Locked State
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock, color: Colors.grey),
                                Text('${sticker.cost} ⭐', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StickerItem {
  final String emoji;
  final int cost;
  final String name;
  StickerItem(this.emoji, this.cost, this.name);
}

class PlacedSticker {
  final String emoji;
  Offset position;
  PlacedSticker({required this.emoji, required this.position});
}
