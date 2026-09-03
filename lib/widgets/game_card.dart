
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/game.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback? onTap;
  final VoidCallback? onStatusChange;
  const GameCard({super.key, required this.game, this.onTap, this.onStatusChange});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardTheme.color,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
              child: game.backgroundImage != null
                ? CachedNetworkImage(imageUrl: game.backgroundImage!, width: 110, height: 140, fit: BoxFit.cover)
                : Container(width: 110, color: Colors.grey[800], child: const Icon(Icons.videogame_asset)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(game.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(game.genres.join(' • '), style: TextStyle(color: Colors.white60, fontSize: 12)),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 16, color: Colors.amber[400]),
                        const SizedBox(width: 4),
                        Text('${game.rating ?? '--'}', style: const TextStyle(fontSize: 13)),
                        const Spacer(),
                        _statusChip(game.status),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _statusChip(GameStatus s) {
    final map = {
      GameStatus.wantToPlay: ['Want', Color(0xFF7C4DFF)],
      GameStatus.playing: ['Playing', Color(0xFF00E5FF)],
      GameStatus.completed: ['Done', Color(0xFF00E676)],
      GameStatus.dropped: ['Dropped', Color(0xFFFF5252)],
    };
    final entry = map[s]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: (entry[1] as Color).withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
      child: Text(entry[0] as String, style: TextStyle(color: entry[1] as Color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
