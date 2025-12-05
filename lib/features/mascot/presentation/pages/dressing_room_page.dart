// lib/features/mascot/presentation/pages/dressing_room_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kids/features/mascot/presentation/provider/mascot_provider.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class DressingRoomPage extends StatelessWidget {
  const DressingRoomPage({super.key});
  static const routeName = '/dressing-room';

  @override
  Widget build(BuildContext context) {
    final mascotProvider = Provider.of<MascotProvider>(context);
    final rewardsProvider = Provider.of<RewardsProvider>(context);

    final equippedHat = mascotProvider.equippedHatId != null
        ? mascotProvider.availableAccessories.firstWhere((acc) => acc.id == mascotProvider.equippedHatId)
        : null;

    final equippedGlasses = mascotProvider.equippedGlassesId != null
        ? mascotProvider.availableAccessories.firstWhere((acc) => acc.id == mascotProvider.equippedGlassesId)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Learning Buddy'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          // 1. Mascot View with Accessories
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.lightBlue.shade100,
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 3D Shadow/Pedestal
                      Positioned(
                        bottom: 60, 
                        child: Container(
                          width: 200, 
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Lottie.asset('assets/animations/mascot.json'),
                      if (equippedHat != null)
                        Positioned(
                          top: 55, 
                          child: _getAccessoryIcon(equippedHat, 100),
                        ),
                      if (equippedGlasses != null)
                        Positioned(
                          top: 120, 
                          child: _getAccessoryIcon(equippedGlasses, 80),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 2. Accessories Shop
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Star Shop',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Text('Your Stars: ', style: TextStyle(fontSize: 16)),
                            const Icon(Icons.star, color: Colors.amber, size: 24),
                            Text(
                              rewardsProvider.rewardState.totalStars.toString(),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: mascotProvider.availableAccessories.length,
                      itemBuilder: (context, index) {
                        final accessory = mascotProvider.availableAccessories[index];
                        final isUnlocked = mascotProvider.unlockedAccessoryIds.contains(accessory.id);
                        return _buildAccessoryCard(context, accessory, isUnlocked);
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

  Widget _buildAccessoryCard(BuildContext context, MascotAccessory accessory, bool isUnlocked) {
    final mascotProvider = Provider.of<MascotProvider>(context, listen: false);
    final rewardsProvider = Provider.of<RewardsProvider>(context, listen: false);

    return Container(
      width: 150,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.green.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isUnlocked ? Border.all(color: Colors.green, width: 3) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _getAccessoryIcon(accessory, 50),
          Text(accessory.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          isUnlocked
              ? ElevatedButton(
                  onPressed: () => mascotProvider.equipAccessory(accessory),
                  child: const Text('Wear'),
                )
              : ElevatedButton(
                  onPressed: () async {
                    final success = await mascotProvider.buyAccessory(
                      accessory,
                      rewardsProvider.rewardState.totalStars,
                    );
                    if (success) {
                      rewardsProvider.spendStars(accessory.price);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('You unlocked the ${accessory.name}!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Not enough stars!')),
                      );
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 16),
                      const SizedBox(width: 4),
                      Text(accessory.price.toString()),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _getAccessoryIcon(MascotAccessory accessory, double iconSize) {
    if (accessory.id.startsWith('hat')) {
      return Icon(Icons.school, size: iconSize, color: Colors.brown);
    } else if (accessory.id.startsWith('glasses')) {
      return Icon(Icons.visibility, size: iconSize, color: Colors.black);
    }
    return Icon(Icons.error, size: iconSize);
  }
}
