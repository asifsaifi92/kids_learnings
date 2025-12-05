// Forcing a final re-read of this file to resolve a stubborn build cache issue.

import '../../domain/entities/rhyme_item.dart';

abstract class RhymesLocalDataSource {
  Future<List<RhymeItem>> getRhymes();
}

class RhymesLocalDataSourceImpl implements RhymesLocalDataSource {
  @override
  Future<List<RhymeItem>> getRhymes() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _rhymes;
  }
}

final List<RhymeItem> _rhymes = [
  RhymeItem(
    id: '1',
    title: 'Twinkle Twinkle Little Star',
    lyrics: 'Twinkle, twinkle, little star,\n'
        'How I wonder what you are!\n'
        'Up above the world so high,\n'
        'Like a diamond in the sky.',
    ttsText: 'Twinkle, twinkle, little star, How I wonder what you are! Up above the world so high, Like a diamond in the sky.',
  ),
  RhymeItem(
    id: '2',
    title: 'Johny Johny Yes Papa',
    lyrics: 'Johny, Johny,\n'
        'Yes, Papa?\n'
        'Eating sugar?\n'
        'No, Papa.\n'
        'Telling lies?\n'
        'No, Papa.\n'
        'Open your mouth,\n'
        'Ha, ha, ha!',
    ttsText: 'Johny, Johny, Yes, Papa? Eating sugar? No, Papa. Telling lies? No, Papa. Open your mouth, Ha, ha, ha!',
  ),
  RhymeItem(
    id: '3',
    title: 'Baa Baa Black Sheep',
    lyrics: 'Baa, baa, black sheep,\n'
        'Have you any wool?\n'
        'Yes, sir, yes, sir,\n'
        'Three bags full.',
    ttsText: 'Baa, baa, black sheep, Have you any wool? Yes, sir, yes, sir, Three bags full.',
  ),
  RhymeItem(
    id: '4',
    title: 'Humpty Dumpty',
    lyrics: 'Humpty Dumpty sat on a wall,\n'
        'Humpty Dumpty had a great fall.\n'
        'All the king\'s horses and all the king\'s men\n'
        'Couldn\'t put Humpty together again.',
    ttsText: "Humpty Dumpty sat on a wall, Humpty Dumpty had a great fall. All the king's horses and all the king's men Couldn't put Humpty together again.",
  ),
  RhymeItem(
    id: '5',
    title: 'Hickory Dickory Dock',
    lyrics: 'Hickory, dickory, dock,\n'
        'The mouse ran up the clock.\n'
        'The clock struck one,\n'
        'The mouse ran down,\n'
        'Hickory, dickory, dock.',
    ttsText: 'Hickory, dickory, dock, The mouse ran up the clock. The clock struck one, The mouse ran down, Hickory, dickory, dock.',
  ),
  RhymeItem(
    id: '6',
    title: 'Wheels On The Bus',
    lyrics: 'The wheels on the bus go round and round,\n'
        'Round and round, round and round.\n'
        'The wheels on the bus go round and round,\n'
        'All through the town.',
    ttsText: 'The wheels on the bus go round and round, Round and round, round and round. The wheels on the bus go round and round, All through the town.',
  ),
  RhymeItem(
    id: '7',
    title: 'Itsy Bitsy Spider',
    lyrics: 'The itsy bitsy spider climbed up the waterspout.\n'
        'Down came the rain and washed the spider out.\n'
        'Out came the sun and dried up all the rain,\n'
        'And the itsy bitsy spider climbed up the spout again.',
    ttsText: 'The itsy bitsy spider climbed up the waterspout. Down came the rain and washed the spider out. Out came the sun and dried up all the rain, And the itsy bitsy spider climbed up the spout again.',
  ),
  RhymeItem(
    id: '8',
    title: 'Rain Rain Go Away',
    lyrics: 'Rain, rain, go away,\n'
        'Come again another day.\n'
        'Little Johny wants to play,\n'
        'Rain, rain, go away.',
    ttsText: 'Rain, rain, go away, Come again another day. Little Johny wants to play, Rain, rain, go away.',
  ),
  RhymeItem(
    id: '9',
    title: 'Head Shoulders Knees and Toes',
    lyrics: 'Head, shoulders, knees, and toes,\n'
        'Knees and toes.\n'
        'Head, shoulders, knees, and toes,\n'
        'Knees and toes.\n'
        'And eyes and ears and mouth and nose,\n'
        'Head, shoulders, knees, and toes,\n'
        'Knees and toes.',
    ttsText: 'Head, shoulders, knees, and toes, Knees and toes. Head, shoulders, knees, and toes, Knees and toes. And eyes and ears and mouth and nose, Head, shoulders, knees, and toes, Knees and toes.',
  ),
  RhymeItem(
    id: '10',
    title: 'London Bridge is Falling Down',
    lyrics: 'London Bridge is falling down,\n'
        'Falling down, falling down.\n'
        'London Bridge is falling down,\n'
        'My fair lady.',
    ttsText: 'London Bridge is falling down, Falling down, falling down. London Bridge is falling down, My fair lady.',
  ),
];
