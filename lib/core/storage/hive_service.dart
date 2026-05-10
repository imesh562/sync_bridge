import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
final class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    // Register type adapters here as features are added.
  }

  Future<Box<T>> openBox<T>(String name) => Hive.openBox<T>(name);

  Box<T> box<T>(String name) => Hive.box<T>(name);
}
