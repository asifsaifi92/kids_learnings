// lib/features/parent_settings/domain/repositories/parent_settings_repository.dart

import '../entities/parent_settings.dart';

abstract class ParentSettingsRepository {
  Future<ParentSettings> getParentSettings();
  Future<void> updateParentSettings(ParentSettings settings);
}
