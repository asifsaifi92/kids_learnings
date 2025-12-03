// lib/main.dart
import 'package:flutter/material.dart';
import 'package:kids/features/parent_settings/presentation/pages/parent_settings_page.dart';
import 'package:kids/features/parent_settings/presentation/provider/parent_settings_provider.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const KidsLearningApp());
}

class KidsLearningApp extends StatelessWidget {
  const KidsLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<ColorsProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ShapesProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<RhymesProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<StoriesProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<RewardsProvider>()..load()),
        ChangeNotifierProvider(create: (_) => di.sl<ParentSettingsProvider>()..load()),
      ],
      child: MaterialApp(
        title: 'Kids Learning',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (_) => const HomePage(),
          AlphabetPage.routeName: (_) => const AlphabetPage(),
          NumbersPage.routeName: (_) => const NumbersPage(),
          ColorsPage.routeName: (_) => const ColorsPage(),
          ShapesPage.routeName: (_) => const ShapesPage(),
          RhymesPage.routeName: (_) => const RhymesPage(),
          StoriesPage.routeName: (_) => const StoriesPage(),
          ParentSettingsPage.routeName: (_) => const ParentSettingsPage(),
        },
      ),
    );
  }
}
