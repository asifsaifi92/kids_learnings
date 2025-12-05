// lib/features/mascot/presentation/provider/mascot_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Represents a single customizable item for the mascot.
class MascotAccessory {
  final String id;
  final String name;
  final String assetPath; // Path to the image asset for the accessory
  final int price;

  const MascotAccessory({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.price,
  });
}

class MascotProvider extends ChangeNotifier {
  MascotProvider();

  // --- Sample Data ---
  final List<MascotAccessory> _availableAccessories = [
    const MascotAccessory(id: 'hat_1', name: 'Top Hat', assetPath: 'assets/images/accessories/hat_1.png', price: 10),
    const MascotAccessory(id: 'glasses_1', name: 'Sunglasses', assetPath: 'assets/images/accessories/glasses_1.png', price: 15),
    const MascotAccessory(id: 'hat_2', name: 'Party Hat', assetPath: 'assets/images/accessories/hat_2.png', price: 20),
  ];
  List<MascotAccessory> get availableAccessories => _availableAccessories;

  // --- State ---

  Set<String> _unlockedAccessoryIds = {};
  Set<String> get unlockedAccessoryIds => _unlockedAccessoryIds;

  String? _equippedHatId;
  String? get equippedHatId => _equippedHatId;

  String? _equippedGlassesId;
  String? get equippedGlassesId => _equippedGlassesId;

  // --- Methods ---

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _unlockedAccessoryIds = (prefs.getStringList('unlocked_accessories') ?? []).toSet();
    _equippedHatId = prefs.getString('equipped_hat');
    _equippedGlassesId = prefs.getString('equipped_glasses');
    notifyListeners();
  }

  Future<bool> buyAccessory(MascotAccessory accessory, int currentStars) async {
    if (currentStars >= accessory.price) {
      _unlockedAccessoryIds.add(accessory.id);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('unlocked_accessories', _unlockedAccessoryIds.toList());
      notifyListeners();
      return true; // Purchase successful
    } 
    return false; // Not enough stars
  }

  Future<void> equipAccessory(MascotAccessory accessory) async {
    if (accessory.id.startsWith('hat')) {
      _equippedHatId = accessory.id;
    } else if (accessory.id.startsWith('glasses')) {
      _equippedGlassesId = accessory.id;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('equipped_hat', _equippedHatId ?? '');
    await prefs.setString('equipped_glasses', _equippedGlassesId ?? '');
    notifyListeners();
  }
}
