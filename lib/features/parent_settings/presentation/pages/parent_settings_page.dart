// lib/features/parent_settings/presentation/pages/parent_settings_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        Provider.of<ParentSettingsProvider>(context, listen: false).load();
      });
      _didInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ParentSettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Settings'),
      ),
      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                _buildSettingsCard(
                  context,
                  title: 'Sound & Voice',
                  children: [
                    SwitchListTile(
                      title: const Text('Background Music'),
                      value: prov.settings.isMusicEnabled,
                      onChanged: (value) => prov.updateMusic(value),
                    ),
                    ListTile(
                      title: const Text('Voice Speed'),
                      trailing: DropdownButton<double>(
                        value: prov.settings.voiceSpeed,
                        items: const [
                          DropdownMenuItem(value: 0.5, child: Text('Slow')),
                          DropdownMenuItem(value: 1.0, child: Text('Medium')),
                          DropdownMenuItem(value: 1.5, child: Text('Fast')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            prov.updateVoiceSpeed(value);
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
                      value: !prov.settings.disabledModules.contains('colors'),
                      onChanged: (value) => prov.toggleModule('colors', value),
                    ),
                    SwitchListTile(
                      title: const Text('Shapes'),
                      value: !prov.settings.disabledModules.contains('shapes'),
                      onChanged: (value) => prov.toggleModule('shapes', value),
                    ),
                    SwitchListTile(
                      title: const Text('Rhymes'),
                      value: !prov.settings.disabledModules.contains('rhymes'),
                      onChanged: (value) => prov.toggleModule('rhymes', value),
                    ),
                    SwitchListTile(
                      title: const Text('Stories'),
                      value: !prov.settings.disabledModules.contains('stories'),
                      onChanged: (value) => prov.toggleModule('stories', value),
                    ),
                  ],
                ),
              ],
            ),
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
