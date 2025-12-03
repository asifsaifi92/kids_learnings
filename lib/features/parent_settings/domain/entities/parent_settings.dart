// lib/features/parent_settings/domain/entities/parent_settings.dart

class ParentSettings {
  final bool isMusicEnabled;
  final double voiceSpeed;
  final Set<String> disabledModules;

  ParentSettings({
    this.isMusicEnabled = true,
    this.voiceSpeed = 1.0,
    this.disabledModules = const {},
  });

  ParentSettings copyWith({
    bool? isMusicEnabled,
    double? voiceSpeed,
    Set<String>? disabledModules,
  }) {
    return ParentSettings(
      isMusicEnabled: isMusicEnabled ?? this.isMusicEnabled,
      voiceSpeed: voiceSpeed ?? this.voiceSpeed,
      disabledModules: disabledModules ?? this.disabledModules,
    );
  }
}
