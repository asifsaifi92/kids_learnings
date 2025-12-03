// lib/features/parent_settings/data/datasources/parent_settings_local_data_source.dart

import '../../domain/entities/parent_settings.dart';

abstract class ParentSettingsLocalDataSource {
  Future<ParentSettings> getParentSettings();
  Future<void> updateParentSettings(ParentSettings settings);
}

class ParentSettingsLocalDataSourceImpl implements ParentSettingsLocalDataSource {
  ParentSettings _settings = ParentSettings();

  @override
  Future<ParentSettings> getParentSettings() async {
    return _settings;
  }

  @override
  Future<void> updateParentSettings(ParentSettings settings) async {
    _settings = settings;
  }
}
