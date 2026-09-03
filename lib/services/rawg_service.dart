
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';

// Get free key at https://rawg.io/apidocs - 20k requests/month free
class RawgService {
  static const _base = 'https://api.rawg.io/api';
  final String apiKey;
  
  RawgService(this.apiKey);

  Future<List<Game>> searchGames(String query) async {
    if (apiKey == 'YOUR_RAWG_KEY') {
      // Mock data for dev without key - so you can build immediately
      return _mockGames.where((g) => g.name.toLowerCase().contains(query.toLowerCase())).toList();
    }
    final url = Uri.parse('$_base/games?key=$apiKey&search=$query&page_size=20');
    final res = await http.get(url);
    if (res.statusCode != 200) throw Exception('RAWG error: ${res.statusCode}');
    final data = jsonDecode(res.body)['results'] as List;
    return data.map((j) => Game.fromRawg(j)).toList();
  }

  Future<List<Game>> getTrending() async {
    if (apiKey == 'YOUR_RAWG_KEY') return _mockGames;
    final url = Uri.parse('$_base/games?key=$apiKey&ordering=-added&page_size=20');
    final res = await http.get(url);
    final data = jsonDecode(res.body)['results'] as List;
    return data.map((j) => Game.fromRawg(j)).toList();
  }

  // Mock so you can develop TODAY without waiting for API key
  static final _mockGames = [
    Game(id: 3498, name: 'Grand Theft Auto V', backgroundImage: 'https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg', rating: 4.47, genres: ['Action'], released: '2013-09-17'),
    Game(id: 3328, name: 'The Witcher 3: Wild Hunt', backgroundImage: 'https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bc87.jpg', rating: 4.66, genres: ['RPG']),
    Game(id: 4200, name: 'Portal 2', backgroundImage: 'https://media.rawg.io/media/games/328/3283617cb7d75d672a04291ac20a42f.jpg', rating: 4.62, genres: ['Puzzle']),
    Game(id: 5286, name: 'Tomb Raider', backgroundImage: 'https://media.rawg.io/media/games/021/021c4e21a1824d16c21b32d4f22d11d0.jpg', rating: 4.05, genres: ['Action']),
    Game(id: 5679, name: 'The Elder Scrolls V: Skyrim', backgroundImage: 'https://media.rawg.io/media/games/45d/45d2b8f7d0702d8e4d0a9f6e6aae8c1.jpg', rating: 4.42, genres: ['RPG']),
  ];
}
