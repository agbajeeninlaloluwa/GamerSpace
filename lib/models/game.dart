
import 'package:hive/hive.dart';



@HiveType(typeId: 0)
enum GameStatus {
  @HiveField(0) wantToPlay,
  @HiveField(1) playing,
  @HiveField(2) completed,
  @HiveField(3) dropped,
}

@HiveType(typeId: 1)
class Game extends HiveObject {
  @HiveField(0) final int id;
  @HiveField(1) final String name;
  @HiveField(2) final String? backgroundImage;
  @HiveField(3) final double? rating;
  @HiveField(4) final String? released;
  @HiveField(5) final List<String> genres;
  @HiveField(6) GameStatus status;
  @HiveField(7) int? userRating; // 1-5
  @HiveField(8) DateTime addedAt;
  @HiveField(9) DateTime? completedAt;

  Game({
    required this.id,
    required this.name,
    this.backgroundImage,
    this.rating,
    this.released,
    this.genres = const [],
    this.status = GameStatus.wantToPlay,
    this.userRating,
    DateTime? addedAt,
    this.completedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  factory Game.fromRawg(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      backgroundImage: json['background_image'],
      rating: (json['rating'] as num?)?.toDouble(),
      released: json['released'],
      genres: (json['genres'] as List? ?? []).map((g) => g['name'] as String).toList(),
    );
  }
}
