// lib/features/parent_settings/domain/usecases/update_parent_settings.dart

import '../entities/parent_settings.dart';
import '../repositories/parent_settings_repository.dart';

class UpdateParentSettings {
  final ParentSettingsRepository repository;

  UpdateParentSettings(this.repository);

  Future<void> call(ParentSettings settings) {
    return repository.updateParentSettings(settings);
  }
}
