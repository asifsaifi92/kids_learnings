// lib/features/parent_settings/presentation/pages/parent_settings_page.dart

import 'package:flutter/material.dart';
import 'package:kids/features/colors/presentation/provider/colors_provider.dart';
import 'package:kids/features/learning/presentation/provider/learning_provider.dart';
import 'package:kids/features/mascot/presentation/provider/mascot_provider.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:kids/features/rhymes/presentation/provider/rhymes_provider.dart';
import 'package:kids/features/shapes/presentation/provider/shapes_provider.dart';
import 'package:kids/features/stories/presentation/provider/stories_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/parent_settings_provider.dart';

class ParentSettingsPage extends StatefulWidget {
  const ParentSettingsPage({super.key});
  static const routeName = '/parent-settings';

  @override
  State<ParentSettingsPage> createState() => _ParentSettingsPageState();
}

class _ParentSettingsPageState extends State<ParentSettingsPage> {
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Initialize all necessary providers
        context.read<ParentSettingsProvider>().load();
        context.read<LearningProvider>().init();
        context.read<RhymesProvider>().init();
        context.read<StoriesProvider>().init();
        context.read<MascotProvider>().init();
        context.read<RewardsProvider>().load();
        context.read<ColorsProvider>().load();
        context.read<ShapesProvider>().load();
      });
      _didInit = true;
    }
  }

  Future<void> _showResetConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset All Progress?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This will erase all learning progress, earned stars, and unlocked accessories.'),
                Text('This action cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Reset Everything'),
              onPressed: () {
                _resetAllProgress();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetAllProgress() async {
    // A more robust way to clear all app-specific data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Reload all providers to update the UI
    context.read<LearningProvider>().init();
    context.read<RhymesProvider>().init();
    context.read<StoriesProvider>().init();
    context.read<MascotProvider>().init();
    context.read<RewardsProvider>().load();
    context.read<ParentSettingsProvider>().load();
    context.read<ColorsProvider>().load();
    context.read<ShapesProvider>().load();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All progress has been reset.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProv = Provider.of<ParentSettingsProvider>(context);
    final learningProv = Provider.of<LearningProvider>(context);
    final rhymesProv = Provider.of<RhymesProvider>(context);
    final storiesProv = Provider.of<StoriesProvider>(context);
    final colorsProv = Provider.of<ColorsProvider>(context);
    final shapesProv = Provider.of<ShapesProvider>(context);

    // Helper to prevent division by zero
    double safeDivide(int a, int b) => (b == 0) ? 0.0 : a / b;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
      ),
      body: settingsProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildSettingsCard(
            context,
            title: 'Learning Progress Report',
            children: [
              _buildProgressExpansionTile(
                context: context,
                title: 'Alphabets',
                percent: safeDivide(learningProv.completedAlphabets.length, 26),
                progressText: '${learningProv.completedAlphabets.length} / 26',
                completedItems: learningProv.completedAlphabets.toList()..sort(),
                color: Colors.redAccent,
              ),
              _buildProgressExpansionTile(
                context: context,
                title: 'Numbers',
                percent: safeDivide(learningProv.completedNumbers.length, 10),
                progressText: '${learningProv.completedNumbers.length} / 10',
                completedItems: learningProv.completedNumbers.toList()..sort(),
                color: Colors.blueAccent,
              ),
              _buildProgressExpansionTile(
                context: context,
                title: 'Colors',
                percent: safeDivide(learningProv.completedColors.length, colorsProv.items.length),
                progressText: '${learningProv.completedColors.length} / ${colorsProv.items.length}',
                completedItems: learningProv.completedColors.toList()..sort(),
                color: Colors.purpleAccent,
              ),
              _buildProgressExpansionTile(
                context: context,
                title: 'Shapes',
                percent: safeDivide(learningProv.completedShapes.length, shapesProv.items.length),
                progressText: '${learningProv.completedShapes.length} / ${shapesProv.items.length}',
                completedItems: learningProv.completedShapes.toList()..sort(),
                color: Colors.orangeAccent,
              ),
              _buildProgressExpansionTile(
                context: context,
                title: 'Rhymes',
                percent: safeDivide(rhymesProv.completedRhymes.length, rhymesProv.items.length),
                progressText: '${rhymesProv.completedRhymes.length} / ${rhymesProv.items.length}',
                completedItems: rhymesProv.completedRhymes.toList()..sort(),
                color: Colors.green,
              ),
              _buildProgressExpansionTile(
                context: context,
                title: 'Stories',
                percent: safeDivide(storiesProv.completedStories.length, storiesProv.items.length),
                progressText: '${storiesProv.completedStories.length} / ${storiesProv.items.length}',
                completedItems: storiesProv.completedStories.toList()..sort(),
                color: Colors.teal,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsCard(
            context,
            title: 'Sound & Voice',
            children: [
              SwitchListTile(
                title: const Text('Background Music'),
                value: settingsProv.settings.isMusicEnabled,
                onChanged: (value) => settingsProv.updateMusic(value),
              ),
              ListTile(
                title: const Text('Voice Speed'),
                trailing: DropdownButton<double>(
                  value: settingsProv.settings.voiceSpeed,
                  items: const [
                    DropdownMenuItem(value: 0.5, child: Text('Slow')),
                    DropdownMenuItem(value: 1.0, child: Text('Medium')),
                    DropdownMenuItem(value: 1.5, child: Text('Fast')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      settingsProv.updateVoiceSpeed(value);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsCard(
            context,
            title: 'Modules',
            children: [
              SwitchListTile(
                title: const Text('Colors'),
                value: !settingsProv.settings.disabledModules.contains('colors'),
                onChanged: (value) => settingsProv.toggleModule('colors', value),
              ),
              SwitchListTile(
                title: const Text('Shapes'),
                value: !settingsProv.settings.disabledModules.contains('shapes'),
                onChanged: (value) => settingsProv.toggleModule('shapes', value),
              ),
              SwitchListTile(
                title: const Text('Rhymes'),
                value: !settingsProv.settings.disabledModules.contains('rhymes'),
                onChanged: (value) => settingsProv.toggleModule('rhymes', value),
              ),
              SwitchListTile(
                title: const Text('Stories'),
                value: !settingsProv.settings.disabledModules.contains('stories'),
                onChanged: (value) => settingsProv.toggleModule('stories', value),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsCard(
            context,
            title: 'Danger Zone',
            children: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
                  onPressed: _showResetConfirmationDialog,
                  child: const Text('Reset All Progress'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressExpansionTile({
    required BuildContext context,
    required String title,
    required double percent,
    required String progressText,
    required List<String> completedItems,
    required Color color,
  }) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: LinearPercentIndicator(
          percent: percent,
          lineHeight: 12.0,
          barRadius: const Radius.circular(6),
          center: Text(progressText, style: const TextStyle(color: Colors.white, fontSize: 10)),
          progressColor: color,
          backgroundColor: color.withOpacity(0.2),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: completedItems.isNotEmpty
                ? completedItems.map((item) => Chip(label: Text(item))).toList()
                : [const Text('No items completed yet.')],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context, {required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }
}