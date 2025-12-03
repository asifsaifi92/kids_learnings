// lib/features/rhymes/data/datasources/rhymes_local_data_source.dart

import '../../domain/entities/rhyme_item.dart';

abstract class RhymesLocalDataSource {
  Future<List<RhymeItem>> getRhymes();
}

class RhymesLocalDataSourceImpl implements RhymesLocalDataSource {
  @override
  Future<List<RhymeItem>> getRhymes() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return [
      RhymeItem(
        id: '1',
        title: 'Twinkle Twinkle Little Star',
        durationText: '1:20',
        assetPath: 'assets/audio/rhymes/twinkle_twinkle.mp3', // Placeholder
        ttsIntro: "Let's sing Twinkle Twinkle Little Star!",
      ),
      RhymeItem(
        id: '2',
        title: 'Old MacDonald Had a Farm',
        durationText: '2:05',
        assetPath: 'assets/audio/rhymes/old_macdonald.mp3', // Placeholder
        ttsIntro: 'Here comes Old MacDonald!',
      ),
      RhymeItem(
        id: '3',
        title: 'Itsy Bitsy Spider',
        durationText: '1:05',
        assetPath: 'assets/audio/rhymes/itsy_bitsy.mp3', // Placeholder
        ttsIntro: 'Look! It\'s the Itsy Bitsy Spider!',
      ),
    ];
  }
}
