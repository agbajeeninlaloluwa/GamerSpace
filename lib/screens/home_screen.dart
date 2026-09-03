
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game.dart';
import '../providers/backlog_provider.dart';
import '../widgets/game_card.dart';
import 'search_screen.dart';
import 'paywall_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allGames = ref.watch(backlogProvider);
    final tabs = [GameStatus.wantToPlay, GameStatus.playing, GameStatus.completed];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GamerSpace', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          actions: [
            IconButton(icon: const Icon(Icons.workspace_premium_rounded), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaywallScreen()))),
            const SizedBox(width: 8),
          ],
          bottom: TabBar(
            tabs: tabs.map((s) {
              final label = {GameStatus.wantToPlay: 'WANT', GameStatus.playing: 'PLAYING', GameStatus.completed: 'DONE'}[s]!;
              final count = allGames.where((g) => g.status == s).length;
              return Tab(text: '$label ($count)');
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: tabs.map((status) {
            final games = allGames.where((g) => g.status == status).toList();
            if (games.isEmpty) return _emptyState(status, context);
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: games.length,
              itemBuilder: (_, i) => GameCard(
                game: games[i],
                onTap: () => _showStatusSheet(context, ref, games[i]),
              ),
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Game'),
        ),
      ),
    );
  }

  Widget _emptyState(GameStatus s, BuildContext context) {
    final msg = {
      GameStatus.wantToPlay: ['Your backlog is empty', 'Tap Add Game to save games you discover on TikTok, YouTube, anywhere.'],
      GameStatus.playing: ['Nothing playing', 'Move a game from Want to Playing when you start it.'],
      GameStatus.completed: ['No wins yet', 'Finish a game and it will show here with confetti + stats.'],
    }[s]!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videogame_asset_outlined, size: 64, color: Colors.white24),
            const SizedBox(height: 16),
            Text(msg[0], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(msg[1], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60)),
          ],
        ),
      ),
    );
  }

  void _showStatusSheet(BuildContext context, WidgetRef ref, Game game) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(game.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            for (var s in GameStatus.values)
              ListTile(
                leading: Icon(s == game.status ? Icons.check_circle : Icons.circle_outlined),
                title: Text(s.name),
                onTap: () {
                  ref.read(backlogProvider.notifier).updateStatus(game.id, s);
                  Navigator.pop(context);
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text('Remove', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                ref.read(backlogProvider.notifier).removeGame(game.id);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
