// lib/features/parent_settings/data/repositories/parent_settings_repository_impl.dart

import '../../domain/entities/parent_settings.dart';
import '../../domain/repositories/parent_settings_repository.dart';
import '../datasources/parent_settings_local_data_source.dart';

class ParentSettingsRepositoryImpl implements ParentSettingsRepository {
  final ParentSettingsLocalDataSource localDataSource;

  ParentSettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<ParentSettings> getParentSettings() {
    return localDataSource.getParentSettings();
  }

  @override
  Future<void> updateParentSettings(ParentSettings settings) {
    return localDataSource.updateParentSettings(settings);
  }
}
