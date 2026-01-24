// lib/main.dart
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids/core/services/notification_service.dart';
import 'package:kids/features/animals/presentation/pages/animals_page.dart';
import 'package:kids/features/challenges/presentation/provider/daily_challenge_provider.dart';
import 'package:kids/features/drawing/presentation/pages/drawing_page.dart';
import 'package:kids/features/fruits/presentation/pages/fruits_page.dart';
import 'package:kids/features/gk/presentation/pages/gk_page.dart';
import 'package:kids/features/learning/presentation/pages/spelling_page.dart';
import 'package:kids/features/learning/presentation/provider/learning_provider.dart';
import 'package:kids/features/mascot/presentation/provider/mascot_provider.dart';
import 'package:kids/features/mascot/presentation/pages/dressing_room_page.dart';
import 'package:kids/features/mascot/presentation/pages/feeding_room_page.dart';
import 'package:kids/features/parent_settings/presentation/pages/create_profile_page.dart';
import 'package:kids/features/parent_settings/presentation/pages/parent_settings_page.dart';
import 'package:kids/features/parent_settings/presentation/provider/parent_settings_provider.dart';
import 'package:kids/features/parent_settings/presentation/provider/profile_provider.dart';
import 'package:kids/features/puzzles/presentation/pages/puzzles_page.dart';
import 'package:kids/features/quiz/presentation/pages/quiz_page.dart';
import 'package:kids/features/quiz/presentation/pages/quiz_selection_page.dart';
import 'package:kids/features/quiz/presentation/provider/quiz_provider.dart';
import 'package:kids/features/rewards/presentation/pages/sticker_album_page.dart';
import 'package:kids/features/rewards/presentation/pages/trophy_room_page.dart';
import 'package:kids/features/rewards/presentation/provider/achievements_provider.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/learning/presentation/pages/alphabet_page.dart';
import 'features/learning/presentation/pages/home_page.dart';
import 'features/learning/presentation/pages/numbers_page.dart';
import 'features/colors/presentation/pages/colors_page.dart';
import 'features/shapes/presentation/pages/shapes_page.dart';
import 'features/rhymes/presentation/pages/rhymes_page.dart';
import 'features/stories/presentation/pages/stories_page.dart';
import 'package:provider/provider.dart';
import 'package:kids/features/colors/presentation/provider/colors_provider.dart';
import 'package:kids/features/shapes/presentation/provider/shapes_provider.dart';
import 'package:kids/features/rhymes/presentation/provider/rhymes_provider.dart';
import 'package:kids/features/stories/presentation/provider/stories_provider.dart';
import 'injection_container.dart' as di;
import 'splash_screen.dart'; // Import SplashScreen
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  
  // Initialize Notifications
  await NotificationService().init();
  await NotificationService().requestPermissions();
  await NotificationService().scheduleDailyRewardReminder();

  await _requestPermissions();

  await di.initDependencies();
  runApp(const KidsLearningApp());
}

Future<void> _requestPermissions() async {
  await [
    Permission.storage,
    Permission.photos,
  ].request();
}

class KidsLearningApp extends StatelessWidget {
  const KidsLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<QuizProvider>()),
        ChangeNotifierProvider(create: (_) {
          final p = di.sl<DailyChallengeProvider>();
          p.init();
          return p;
        }),
        ChangeNotifierProvider(create: (_) {
          final p = di.sl<LearningProvider>();
          p.init();
          return p;
        }),
        ChangeNotifierProvider(create: (_) {
          final p = di.sl<MascotProvider>();
          p.init();
          return p;
        }),
        ChangeNotifierProvider(create: (_) => di.sl<ColorsProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ShapesProvider>()),
        ChangeNotifierProvider(create: (_) {
          final p = di.sl<RhymesProvider>();
          p.init();
          return p;
        }),
        ChangeNotifierProvider(create: (_) {
          final p = di.sl<StoriesProvider>();
          p.init();
          return p;
        }),
        ChangeNotifierProvider(create: (_) => di.sl<RewardsProvider>()..load()),
        ChangeNotifierProvider(create: (_) => di.sl<ParentSettingsProvider>()..load()),
        ChangeNotifierProvider(create: (_) => AchievementsProvider()..init()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()..load()),
      ],
      child: MaterialApp(
        title: 'Kids Learning',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        // Use SplashScreen as the home screen
        home: const SplashScreen(), 
        routes: {
          CreateProfilePage.routeName: (_) => const CreateProfilePage(),
          AlphabetPage.routeName: (_) => const AlphabetPage(),
          NumbersPage.routeName: (_) => const NumbersPage(),
          ColorsPage.routeName: (_) => const ColorsPage(),
          ShapesPage.routeName: (_) => const ShapesPage(),
          RhymesPage.routeName: (_) => const RhymesPage(),
          StoriesPage.routeName: (_) => const StoriesPage(),
          ParentSettingsPage.routeName: (_) => const ParentSettingsPage(),
          DrawingPage.routeName: (_) => const DrawingPage(),
          DressingRoomPage.routeName: (_) => const DressingRoomPage(),
          FeedingRoomPage.routeName: (_) => const FeedingRoomPage(),
          StickerAlbumPage.routeName: (_) => const StickerAlbumPage(),
          TrophyRoomPage.routeName: (_) => const TrophyRoomPage(),
          QuizSelectionPage.routeName: (_) => const QuizSelectionPage(),
          QuizPage.routeName: (_) => const QuizPage(),
          AnimalsPage.routeName: (_) => const AnimalsPage(),
          FruitsPage.routeName: (_) => const FruitsPage(),
          PuzzlesPage.routeName: (_) => const PuzzlesPage(),
          GKPage.routeName: (_) => const GKPage(),
          SpellingPage.routeName: (_) => const SpellingPage(),
        },
      ),
    );
  }
}

class RootDispatcher extends StatelessWidget {
  const RootDispatcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profile, _) {
        if (profile.hasProfile) {
          return const HomePage();
        } else {
          return const CreateProfilePage();
        }
      },
    );
  }
}
