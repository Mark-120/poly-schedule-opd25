import 'dart:math';

import 'package:hive/hive.dart';

import '../../../core/logger.dart';

final class HiveCache<T, K> {
  final AppLogger logger;
  final int entriesCount;
  final Box<(T, DateTime)> box;

  HiveCache({required this.box, this.entriesCount = 30, required this.logger});

  T? getValue(K key) {
    final value = box.get(key.toString());
    logger.debug(
      '[HiveCache] GET ${key.toString()} - ${value != null ? 'HIT' : 'MISS'}',
    );
    return value?.$1;
  }

  Future<void> addValue(K key, T value) async {
    logger.debug('[HiveCache] SET ${key.toString()}');
    await box.put(key.toString(), (value, DateTime.now()));
    await _removeExtra();
  }

  Future<void> removeValue(K key) async {
    logger.debug('[HiveCache] Delete ${key.toString()}');
    await box.delete(key.toString());
  }

  Future<void> _removeExtra() async {
    final entries = box.toMap().entries.toList();

    entries.sort((a, b) {
      return a.value.$2.compareTo(b.value.$2);
    });

    // Delete oldest
    final keysToRemove = entries
        .take(max(0, box.length - entriesCount))
        .map((e) => e.key);
    logger.debug(
      '[HiveCache] CLEAN removing ${keysToRemove.length} old entries',
    );
    await box.deleteAll(keysToRemove);
    return;
  }
}
