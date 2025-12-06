
import 'package:flutter/material.dart';
import 'package:kids/features/colors/presentation/provider/colors_provider.dart';
import 'package:kids/features/learning/presentation/provider/learning_provider.dart';
import 'package:kids/features/mascot/presentation/provider/mascot_provider.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:kids/features/rhymes/presentation/provider/rhymes_provider.dart';
import 'package:kids/features/shapes/presentation/provider/shapes_provider.dart';
import 'package:kids/features/stories/presentation/provider/stories_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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
      barrierDismissible: false,
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

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
    final rewardsProv = Provider.of<RewardsProvider>(context);

    // Calculate aggregated stats
    final int totalLearned = learningProv.completedAlphabets.length +
        learningProv.completedNumbers.length +
        learningProv.completedColors.length +
        learningProv.completedShapes.length +
        rhymesProv.completedRhymes.length +
        storiesProv.completedStories.length;

    final int totalItems = 26 + 10 + colorsProv.items.length + shapesProv.items.length + rhymesProv.items.length + storiesProv.items.length;
    
    // SAFE DIVISION with CLAMP
    final double overallProgress = (totalItems == 0) ? 0.0 : (totalLearned / totalItems).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.grey.shade100,
      body: settingsProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // 1. Overall Summary Card
                _buildSummaryCard(overallProgress, totalLearned, rewardsProv.rewardState.totalStars),
                const SizedBox(height: 20),

                const Text(
                  'Learning Breakdown',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                const SizedBox(height: 10),

                // 2. Detailed Breakdown Grid
                _buildBreakdownGrid(
                  learningProv, rhymesProv, storiesProv, colorsProv, shapesProv
                ),
                
                const SizedBox(height: 30),
                const Text(
                  'App Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                const SizedBox(height: 10),

                // 3. Settings Section
                _buildSettingsCard(
                  context,
                  children: [
                    SwitchListTile(
                      title: const Text('Background Music'),
                      secondary: const Icon(Icons.music_note),
                      value: settingsProv.settings.isMusicEnabled,
                      onChanged: (value) => settingsProv.updateMusic(value),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Voice Speed'),
                      leading: const Icon(Icons.speed),
                      trailing: DropdownButton<double>(
                        value: settingsProv.settings.voiceSpeed,
                        underline: Container(),
                        items: const [
                          DropdownMenuItem(value: 0.5, child: Text('Slow')),
                          DropdownMenuItem(value: 1.0, child: Text('Normal')),
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
                const SizedBox(height: 20),
                
                // 4. Danger Zone
                Center(
                  child: TextButton.icon(
                    onPressed: _showResetConfirmationDialog,
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    label: const Text('Reset All Progress', style: TextStyle(color: Colors.red)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _buildSummaryCard(double progress, int totalLearned, int stars) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 50.0,
              lineWidth: 10.0,
              percent: progress,
              center: Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              progressColor: Colors.green,
              backgroundColor: Colors.green.shade100,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Mastery",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 8),
                  Text("$totalLearned items learned", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text("$stars Stars Earned", style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownGrid(
    LearningProvider learningProv,
    RhymesProvider rhymesProv,
    StoriesProvider storiesProv,
    ColorsProvider colorsProv,
    ShapesProvider shapesProv,
  ) {
    // Helper to prevent division by zero AND clamp
    double safeDivide(int a, int b) => (b == 0) ? 0.0 : (a / b).clamp(0.0, 1.0);

    final stats = [
      _StatItem('Alphabets', learningProv.completedAlphabets.length, 26, Colors.redAccent, Icons.abc),
      _StatItem('Numbers', learningProv.completedNumbers.length, 10, Colors.blueAccent, Icons.looks_one),
      _StatItem('Colors', learningProv.completedColors.length, colorsProv.items.length, Colors.purpleAccent, Icons.palette),
      _StatItem('Shapes', learningProv.completedShapes.length, shapesProv.items.length, Colors.orangeAccent, Icons.category),
      _StatItem('Rhymes', rhymesProv.completedRhymes.length, rhymesProv.items.length, Colors.green, Icons.music_note),
      _StatItem('Stories', storiesProv.completedStories.length, storiesProv.items.length, Colors.teal, Icons.book),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final item = stats[index];
        final percent = safeDivide(item.current, item.total);
        
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(item.icon, color: item.color, size: 28),
                    const SizedBox(width: 8),
                    Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const Spacer(),
                LinearPercentIndicator(
                  lineHeight: 8.0,
                  percent: percent,
                  progressColor: item.color,
                  backgroundColor: item.color.withOpacity(0.1),
                  barRadius: const Radius.circular(4),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 8),
                Text(
                  '${item.current} / ${item.total} Learned',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsCard(BuildContext context, {required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: children,
      ),
    );
  }
}

class _StatItem {
  final String title;
  final int current;
  final int total;
  final Color color;
  final IconData icon;

  _StatItem(this.title, this.current, this.total, this.color, this.icon);
}
