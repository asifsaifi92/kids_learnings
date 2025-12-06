
import 'package:flutter/material.dart';
import 'package:kids/features/rewards/presentation/provider/achievements_provider.dart';
import 'package:provider/provider.dart';

class TrophyRoomPage extends StatelessWidget {
  static const routeName = '/trophy-room';
  const TrophyRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trophy Room'),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<AchievementsProvider>(
          builder: (context, prov, _) {
            return GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: prov.achievements.length,
              itemBuilder: (context, index) {
                final ach = prov.achievements[index];
                return _buildAchievementCard(ach);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement ach) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ach.isUnlocked ? Colors.amber : Colors.grey.shade300,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          ColorFiltered(
            colorFilter: ach.isUnlocked
                ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                : const ColorFilter.matrix(<double>[
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0, 0, 0, 1, 0,
                  ]), // Grayscale filter
            child: Image.asset(
              ach.iconAsset,
              width: 80,
              height: 80,
              errorBuilder: (c, o, s) => Icon(
                Icons.emoji_events, 
                size: 80, 
                color: ach.isUnlocked ? Colors.amber : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            ach.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ach.isUnlocked ? Colors.black87 : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            ach.description,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (!ach.isUnlocked)
            LinearProgressIndicator(
              value: ach.progress / ach.target,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(Colors.blueAccent),
              minHeight: 6,
            ),
        ],
      ),
    );
  }
}
