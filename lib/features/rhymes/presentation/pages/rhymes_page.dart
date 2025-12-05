// lib/features/rhymes/presentation/pages/rhymes_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/rhymes_provider.dart';
import 'rhyme_detail_page.dart';
import '../widgets/rhyme_card.dart';

class RhymesPage extends StatefulWidget {
  const RhymesPage({super.key});
  static const routeName = '/rhymes';

  @override
  State<RhymesPage> createState() => _RhymesPageState();
}

class _RhymesPageState extends State<RhymesPage> {
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<RhymesProvider>(context, listen: false).load();
      });
      _didInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<RhymesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nursery Rhymes'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF81C7F5), Color(0xFFB3E5FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6AE398), Color(0xFF50C878)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemCount: prov.items.length,
                itemBuilder: (context, index) {
                  final item = prov.items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: RhymeCard(
                      rhyme: item,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RhymeDetailPage(rhyme: item),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
