// lib/features/rhymes/data/models/rhyme_model.dart
// This file is being forcefully overwritten to resolve a persistent build error.

import '../../domain/entities/rhyme_item.dart';

class RhymeModel extends RhymeItem {
  RhymeModel({
    required String id,
    required String title,
    required String lyrics,
    required String ttsText,
  }) : super(
          id: id,
          title: title,
          lyrics: lyrics,
          ttsText: ttsText,
        );
}
