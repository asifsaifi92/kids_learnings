
import 'package:flutter/material.dart';
import 'package:kids/core/audio/sound_manager.dart';
import 'package:kids/features/learning/presentation/pages/home_page.dart';
import 'package:kids/features/parent_settings/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class CreateProfilePage extends StatefulWidget {
  static const routeName = '/create-profile';
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedAvatar = 'boy';

  final Map<String, String> _avatarEmojis = {
    'boy': '👦',
    'girl': '👧',
    'bear': '🐻',
    'cat': '🐱',
    'robot': '🤖',
    'dino': '🦖',
  };

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    SoundManager().playSuccess();
    
    Provider.of<ProfileProvider>(context, listen: false).createProfile(name, _selectedAvatar);

    // Navigate to Home Page directly
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF81C7F5), Color(0xFFB3E5FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Let\'s setup your profile.',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 40),

                  // Name Input
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                    ),
                    child: TextField(
                      controller: _nameController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'What is your name?',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Avatar Picker
                  const Text(
                    'Pick your character:',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: _avatarEmojis.entries.map((entry) {
                      final isSelected = _selectedAvatar == entry.key;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedAvatar = entry.key);
                          SoundManager().playClick();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: Colors.orange, width: 4) : null,
                            boxShadow: isSelected ? [const BoxShadow(color: Colors.black26, blurRadius: 10)] : [],
                          ),
                          child: Text(entry.value, style: const TextStyle(fontSize: 40)),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 40),

                  // Start Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                      ),
                      child: const Text('Let\'s Play!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
