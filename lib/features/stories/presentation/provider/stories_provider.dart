// lib/features/stories/presentation/provider/stories_provider.dart

import 'package:flutter/material.dart';
import '../../domain/entities/story_item.dart';
import '../../domain/usecases/get_stories.dart';
import '../../../../core/services/text_to_speech_service.dart';

class StoriesProvider extends ChangeNotifier {
  final GetStories getStories;
  final TextToSpeechService ttsService;

  StoriesProvider({required this.getStories, required this.ttsService});

  List<StoryItem> _items = [];
  List<StoryItem> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _items = await getStories.call();
    _isLoading = false;
    notifyListeners();
  }

  void speak(String text) {
    ttsService.speak(text);
  }
}
