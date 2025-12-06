
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = '';
  String _avatarId = 'boy'; // Default
  bool _hasProfile = false;

  String get name => _name;
  String get avatarId => _avatarId;
  bool get hasProfile => _hasProfile;

  // Available Avatars
  final List<String> avatars = ['boy', 'girl', 'bear', 'cat', 'robot', 'dino'];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('profile_name') ?? '';
    _avatarId = prefs.getString('profile_avatar') ?? 'boy';
    _hasProfile = _name.isNotEmpty;
    notifyListeners();
  }

  Future<void> createProfile(String name, String avatar) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', name);
    await prefs.setString('profile_avatar', avatar);
    
    _name = name;
    _avatarId = avatar;
    _hasProfile = true;
    notifyListeners();
  }

  Future<void> updateProfile(String name, String avatar) async {
    await createProfile(name, avatar);
  }
  
  // Helper to get asset path
  String getAvatarAsset(String id) {
    // Mapping IDs to local assets or emojis/icons if assets missing
    // For now we will return generic paths, assuming assets exist or handled by UI
    return 'assets/images/avatars/$id.png';
  }
}
