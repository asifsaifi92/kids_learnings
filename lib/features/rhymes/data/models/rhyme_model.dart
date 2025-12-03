// lib/features/rhymes/data/models/rhyme_model.dart

import '../../domain/entities/rhyme_item.dart';

class RhymeModel extends RhymeItem {
  RhymeModel({
    required String id,
    required String title,
    required String durationText,
    required String assetPath,
    required String ttsIntro,
  }) : super(
          id: id,
          title: title,
          durationText: durationText,
          assetPath: assetPath,
          ttsIntro: ttsIntro,
        );
}
