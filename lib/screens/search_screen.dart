
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/backlog_provider.dart';
import '../widgets/game_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String query = '';
  Future? future;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Games')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search GTA, Witcher, Portal...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
              onSubmitted: (v) {
                setState(() {
                  query = v;
                  future = ref.read(backlogProvider.notifier).search(v);
                });
              },
            ),
          ),
          Expanded(
            child: future == null
              ? const Center(child: Text('Trending games will appear here', style: TextStyle(color: Colors.white54)))
              : FutureBuilder(
                future: future,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
                  final games = snap.data as List;
                  if (games.isEmpty) return const Center(child: Text('No results'));
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: games.length,
                    itemBuilder: (_, i) => GameCard(
                      game: games[i],
                      onTap: () {
                        ref.read(backlogProvider.notifier).addGame(games[i]);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${games[i].name} added to Want to Play!')));
                      },
                    ),
                  );
                },
              ),
          )
        ],
      ),
    );
  }
}
