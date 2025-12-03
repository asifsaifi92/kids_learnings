// lib/features/parent_settings/presentation/provider/parent_settings_provider.dart

import 'package:flutter/material.dart';
import '../../domain/entities/parent_settings.dart';
import '../../domain/usecases/get_parent_settings.dart';
import '../../domain/usecases/update_parent_settings.dart';

class ParentSettingsProvider extends ChangeNotifier {
  final GetParentSettings getParentSettings;
  final UpdateParentSettings updateParentSettings;

  ParentSettingsProvider({
    required this.getParentSettings,
    required this.updateParentSettings,
  });

  ParentSettings _settings = ParentSettings();
  ParentSettings get settings => _settings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _settings = await getParentSettings();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateMusic(bool isEnabled) async {
    _settings = _settings.copyWith(isMusicEnabled: isEnabled);
    await updateParentSettings(_settings);
    notifyListeners();
  }

  Future<void> updateVoiceSpeed(double speed) async {
    _settings = _settings.copyWith(voiceSpeed: speed);
    await updateParentSettings(_settings);
    notifyListeners();
  }

  Future<void> toggleModule(String moduleId, bool isEnabled) async {
    final disabled = Set<String>.from(_settings.disabledModules);
    if (isEnabled) {
      disabled.remove(moduleId);
    } else {
      disabled.add(moduleId);
    }
    _settings = _settings.copyWith(disabledModules: disabled);
    await updateParentSettings(_settings);
    notifyListeners();
  }
}
