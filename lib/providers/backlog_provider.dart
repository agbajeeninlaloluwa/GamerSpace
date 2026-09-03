
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/game.dart';
import '../services/rawg_service.dart';

final rawgServiceProvider = Provider((ref) => RawgService('YOUR_RAWG_KEY'));
final gamesBoxProvider = Provider<Box<Game>>((ref) => throw UnimplementedError());

final backlogProvider = StateNotifierProvider<BacklogNotifier, List<Game>>((ref) {
  final box = ref.watch(gamesBoxProvider);
  final rawg = ref.watch(rawgServiceProvider);
  return BacklogNotifier(box, rawg);
});

class BacklogNotifier extends StateNotifier<List<Game>> {
  final Box<Game> box;
  final RawgService rawg;
  BacklogNotifier(this.box, this.rawg) : super(box.values.toList()) {
    box.listenable().addListener(() => state = box.values.toList());
  }

  void addGame(Game game) {
    if (!box.containsKey(game.id)) {
      box.put(game.id, game);
    }
  }

  void updateStatus(int id, GameStatus status) {
    final game = box.get(id);
    if (game != null) {
      game.status = status;
      if (status == GameStatus.completed) game.completedAt = DateTime.now();
      game.save();
    }
  }

  void rateGame(int id, int rating) {
    final game = box.get(id);
    if (game != null) {
      game.userRating = rating;
      game.save();
    }
  }

  void removeGame(int id) => box.delete(id);

  List<Game> gamesByStatus(GameStatus s) => state.where((g) => g.status == s).toList();

  Future<List<Game>> search(String q) => rawg.searchGames(q);
}
