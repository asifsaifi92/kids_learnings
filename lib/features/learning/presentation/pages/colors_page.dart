import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/colors_provider.dart';
import '../widgets/color_tile.dart';

class ColorsPage extends StatefulWidget {
  static const routeName = '/colors';

  const ColorsPage({Key? key}) : super(key: key);

  @override
  State<ColorsPage> createState() => _ColorsPageState();
}

class _ColorsPageState extends State<ColorsPage> {
  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to ensure the provider is available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ColorsProvider>(context, listen: false).loadColors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colors'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.blue, Colors.green, Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Consumer<ColorsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.gameState == GameState.asking || provider.gameState == GameState.correct || provider.gameState == GameState.wrong) {
            return _buildGameUI(context, provider);
          }

          return _buildColorGridUI(context, provider);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            final provider = Provider.of<ColorsProvider>(context, listen: false);
            if (provider.gameState == GameState.none) {
                provider.startMiniGame();
            } else {
                provider.resetGame();
            }
        },
        child: Consumer<ColorsProvider>(builder: (context, provider, child) {
            return Icon(provider.gameState == GameState.none ? Icons.play_arrow : Icons.close);
        }),
      ),
    );
  }

  Widget _buildColorGridUI(BuildContext context, ColorsProvider provider) {
    return GridView.builder(
      padding: const EdgeInsets.all(24.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.0,
      ),
      itemCount: provider.items.length,
      itemBuilder: (context, index) {
        final item = provider.items[index];
        return ColorTile(
          item: item,
          onTap: () => provider.speakColor(item),
        );
      },
    );
  }

  Widget _buildGameUI(BuildContext context, ColorsProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            provider.gameState == GameState.correct 
                ? 'Correct!' 
                : 'Tap the ${provider.currentTarget?.name} color!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        if(provider.gameState == GameState.correct) 
            const Icon(Icons.star, color: Colors.amber, size: 100),
        if(provider.gameState != GameState.correct) 
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: provider.gameChoices.map((item) {
                    return Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ColorTile(
                                item: item,
                                onTap: () => provider.checkAnswer(item),
                                isSelected: provider.gameState == GameState.wrong && provider.currentTarget != item, // Dim non-answers on wrong guess
                            ),
                        ),
                    );
                }).toList(),
            ),
      ],
    );
  }
}
