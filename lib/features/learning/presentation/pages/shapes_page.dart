import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/shapes_provider.dart';
import '../widgets/shape_tile.dart';

class ShapesPage extends StatefulWidget {
  static const routeName = '/shapes';

  const ShapesPage({Key? key}) : super(key: key);

  @override
  State<ShapesPage> createState() => _ShapesPageState();
}

class _ShapesPageState extends State<ShapesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShapesProvider>(context, listen: false).loadShapes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shapes'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Consumer<ShapesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.gameState != ShapeGameState.none) {
            return _buildGameUI(context, provider);
          }

          return _buildShapeGridUI(context, provider);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            final provider = Provider.of<ShapesProvider>(context, listen: false);
            if (provider.gameState == ShapeGameState.none) {
                provider.startMiniGame();
            } else {
                provider.resetGame();
            }
        },
        child: Consumer<ShapesProvider>(builder: (context, provider, child) {
            return Icon(provider.gameState == ShapeGameState.none ? Icons.play_arrow : Icons.close);
        }),
      ),
    );
  }

  Widget _buildShapeGridUI(BuildContext context, ShapesProvider provider) {
    return GridView.builder(
      padding: const EdgeInsets.all(24.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: provider.items.length,
      itemBuilder: (context, index) {
        final item = provider.items[index];
        return ShapeTile(
          item: item,
          onTap: () => provider.speakShape(item),
        );
      },
    );
  }

  Widget _buildGameUI(BuildContext context, ShapesProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            provider.gameState == ShapeGameState.correct 
                ? 'You found it!' 
                : 'Find the ${provider.currentTarget?.name}!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        if(provider.gameState == ShapeGameState.correct) 
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
        if(provider.gameState != ShapeGameState.correct) 
            GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(24.0),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                ),
                itemCount: provider.gameChoices.length,
                itemBuilder: (context, index) {
                    final item = provider.gameChoices[index];
                    return ShapeTile(
                        item: item,
                        onTap: () => provider.checkAnswer(item),
                    );
                },
            ),
      ],
    );
  }
}
