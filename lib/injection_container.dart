import 'package:get_it/get_it.dart';

import 'package:kids/core/services/text_to_speech_service.dart';
import 'package:kids/core/audio/audio_player_service.dart';

// Learning (existing)
import 'package:kids/features/learning/data/datasources/learning_local_data_source.dart';
import 'package:kids/features/learning/data/repositories/learning_repository_impl.dart';
import 'package:kids/features/learning/domain/repositories/learning_repository.dart';
import 'package:kids/features/learning/domain/usecases/get_alphabet_items.dart';
import 'package:kids/features/learning/domain/usecases/get_number_items.dart';
import 'package:kids/features/learning/presentation/provider/learning_provider.dart';

// Mascot
import 'package:kids/features/mascot/presentation/provider/mascot_provider.dart';

// Quiz
import 'package:kids/features/quiz/presentation/provider/quiz_provider.dart';

// Colors feature
import 'package:kids/features/colors/data/datasources/colors_local_data_source.dart';
import 'package:kids/features/colors/data/repositories/colors_repository_impl.dart';
import 'package:kids/features/colors/domain/repositories/colors_repository.dart';
import 'package:kids/features/colors/domain/usecases/get_colors.dart';
import 'package:kids/features/colors/presentation/provider/colors_provider.dart';

// Shapes feature
import 'package:kids/features/shapes/data/datasources/shapes_local_data_source.dart';
import 'package:kids/features/shapes/data/repositories/shapes_repository_impl.dart';
import 'package:kids/features/shapes/domain/repositories/shapes_repository.dart';
import 'package:kids/features/shapes/domain/usecases/get_shapes.dart';
import 'package:kids/features/shapes/presentation/provider/shapes_provider.dart';

// Rhymes
import 'package:kids/features/rhymes/data/datasources/rhymes_local_data_source.dart';
import 'package:kids/features/rhymes/data/repositories/rhymes_repository_impl.dart';
import 'package:kids/features/rhymes/domain/repositories/rhymes_repository.dart';
import 'package:kids/features/rhymes/domain/usecases/get_rhymes.dart';
import 'package:kids/features/rhymes/presentation/provider/rhymes_provider.dart';

// Stories
import 'package:kids/features/stories/data/datasources/stories_local_data_source.dart';
import 'package:kids/features/stories/data/repositories/stories_repository_impl.dart';
import 'package:kids/features/stories/domain/repositories/stories_repository.dart';
import 'package:kids/features/stories/domain/usecases/get_stories.dart';
import 'package:kids/features/stories/presentation/provider/stories_provider.dart';

// Rewards
import 'package:kids/features/rewards/data/datasources/rewards_local_data_source.dart';
import 'package:kids/features/rewards/data/repositories/rewards_repository_impl.dart';
import 'package:kids/features/rewards/domain/repositories/rewards_repository.dart';
import 'package:kids/features/rewards/domain/usecases/get_rewards.dart';
import 'package:kids/features/rewards/domain/usecases/award_star.dart';
import 'package:kids/features/rewards/domain/usecases/spend_star.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';

// Parent Settings
import 'package:kids/features/parent_settings/data/datasources/parent_settings_local_data_source.dart';
import 'package:kids/features/parent_settings/data/repositories/parent_settings_repository_impl.dart';
import 'package:kids/features/parent_settings/domain/repositories/parent_settings_repository.dart';
import 'package:kids/features/parent_settings/domain/usecases/get_parent_settings.dart';
import 'package:kids/features/parent_settings/domain/usecases/update_parent_settings.dart';
import 'package:kids/features/parent_settings/presentation/provider/parent_settings_provider.dart';

// Challenges
import 'package:kids/features/challenges/presentation/provider/daily_challenge_provider.dart';


final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerSingletonAsync<TextToSpeechService>(() async {
    final service = TextToSpeechService();
    await service.init();
    return service;
  });
  await sl.isReady<TextToSpeechService>();

  // Core Audio Player
  sl.registerLazySingleton<AudioPlayerService>(() => AudioPlayerService());

  // Features - Providers
  sl.registerFactory(() => LearningProvider());
  sl.registerFactory(() => MascotProvider());
  sl.registerFactory(() => DailyChallengeProvider());

  // Colors feature - MUST be Singleton to be accessed by QuizProvider
  sl.registerLazySingleton(() => GetColors(sl()));
  sl.registerLazySingleton<ColorsRepository>(() => ColorsRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<ColorsLocalDataSource>(() => ColorsLocalDataSourceImpl());
  sl.registerLazySingleton(() => ColorsProvider(getColors: sl(), ttsService: sl())); // SINGLETON

  // Shapes feature - MUST be Singleton to be accessed by QuizProvider
  sl.registerLazySingleton(() => GetShapes(sl()));
  sl.registerLazySingleton<ShapesRepository>(() => ShapesRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<ShapesLocalDataSource>(() => ShapesLocalDataSourceImpl());
  sl.registerLazySingleton(() => ShapesProvider(getShapes: sl(), ttsService: sl())); // SINGLETON

  // Quiz Provider (must be registered AFTER its dependencies)
  sl.registerFactory(() => QuizProvider(
    getAlphabetItems: sl(),
    getNumberItems: sl(),
  ));

  // Learning Usecases
  sl.registerLazySingleton(() => GetAlphabetItems(sl()));
  sl.registerLazySingleton(() => GetNumberItems(sl()));

  // Learning Repository
  sl.registerLazySingleton<LearningRepository>(
        () => LearningRepositoryImpl(localDataSource: sl()),
  );

  // Learning Data Sources
  sl.registerLazySingleton<LearningLocalDataSource>(
        () => LearningLocalDataSourceImpl(),
  );

  // Rhymes
  sl.registerFactory(
          () => RhymesProvider(getRhymes: sl(), ttsService: sl()));
  sl.registerLazySingleton(() => GetRhymes(sl()));
  sl.registerLazySingleton<RhymesRepository>(() => RhymesRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<RhymesLocalDataSource>(() => RhymesLocalDataSourceImpl());

  // Stories
  sl.registerLazySingleton<StoriesRepository>(() => StoriesRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<StoriesLocalDataSource>(() => StoriesLocalDataSourceImpl());
  sl.registerLazySingleton(() => GetStories(sl()));
  sl.registerFactory(() => StoriesProvider(getStories: sl(), ttsService: sl()));

  // Rewards
  sl.registerLazySingleton<RewardsRepository>(() => RewardsRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<RewardsLocalDataSource>(() => RewardsLocalDataSourceImpl());
  sl.registerLazySingleton(() => GetRewards(sl()));
  sl.registerLazySingleton(() => AwardStar(sl()));
  sl.registerLazySingleton(() => SpendStar(sl()));
  sl.registerFactory(() => RewardsProvider(
    getRewards: sl(),
    awardStarUseCase: sl(),
    spendStarUseCase: sl(),
  ));

  // Parent Settings
  sl.registerLazySingleton<ParentSettingsRepository>(() => ParentSettingsRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<ParentSettingsLocalDataSource>(() => ParentSettingsLocalDataSourceImpl());
  sl.registerLazySingleton(() => GetParentSettings(sl()));
  sl.registerLazySingleton(() => UpdateParentSettings(sl()));
  sl.registerFactory(() => ParentSettingsProvider(getParentSettings: sl(), updateParentSettings: sl()));
}