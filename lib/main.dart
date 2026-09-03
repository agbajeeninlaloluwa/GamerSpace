
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/game.dart';
import 'providers/backlog_provider.dart';
import 'services/revenuecat_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GameStatusAdapter());
  Hive.registerAdapter(GameAdapter());
  final box = await Hive.openBox<Game>('games');
  
  // Init RevenueCat - safe even with placeholder keys
  await RevenueCatService().init();
  
  // TODO: Init OneSignal after you create app at onesignal.com
  // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // OneSignal.initialize("YOUR_ONESIGNAL_APP_ID");

  runApp(ProviderScope(
    overrides: [
      gamesBoxProvider.overrideWithValue(box),
    ],
    child: const GamerSpaceApp(),
  ));
}

class GamerSpaceApp extends StatelessWidget {
  const GamerSpaceApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GamerSpace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const HomeScreen(),
    );
  }
}

// Hive Adapters - run build_runner later, for now manual
class GameStatusAdapter extends TypeAdapter<GameStatus> {
  @override final typeId = 0;
  @override GameStatus read(BinaryReader reader) => GameStatus.values[reader.readByte()];
  @override void write(BinaryWriter writer, GameStatus obj) => writer.writeByte(obj.index);
}

class GameAdapter extends TypeAdapter<Game> {
  @override final typeId = 1;
  @override Game read(BinaryReader reader) {
    return Game(
      id: reader.readInt(),
      name: reader.readString(),
      backgroundImage: reader.read() as String?,
      rating: reader.read() as double?,
      released: reader.read() as String?,
      genres: (reader.read() as List?)?.cast<String>() ?? [],
      status: GameStatus.values[reader.readByte()],
      userRating: reader.read() as int?,
      addedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      completedAt: reader.read() == null ? null : DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }
  @override void write(BinaryWriter writer, Game obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.write(obj.backgroundImage);
    writer.write(obj.rating);
    writer.write(obj.released);
    writer.write(obj.genres);
    writer.writeByte(obj.status.index);
    writer.write(obj.userRating);
    writer.writeInt(obj.addedAt.millisecondsSinceEpoch);
    writer.write(obj.completedAt?.millisecondsSinceEpoch);
  }
}
