// lib/features/parent_settings/domain/usecases/get_parent_settings.dart

import '../entities/parent_settings.dart';
import '../repositories/parent_settings_repository.dart';

class GetParentSettings {
  final ParentSettingsRepository repository;

  GetParentSettings(this.repository);

  Future<ParentSettings> call() {
    return repository.getParentSettings();
  }
}
