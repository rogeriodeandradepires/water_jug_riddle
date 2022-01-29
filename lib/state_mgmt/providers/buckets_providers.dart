import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_jug_riddle/state_mgmt/controllers/buckets_notifier.dart';
import 'package:water_jug_riddle/state_mgmt/repositories/buckets_repository.dart';

final bucketsRepositoryProvider = Provider<BucketsRepository>(
  (ref) => PublicBucketsRepository(),
);

final bucketsNotifierProvider =
    StateNotifierProvider.autoDispose<BucketsNotifier, BucketsState>(
  (ref) => BucketsNotifier(ref.watch(bucketsRepositoryProvider)),
);