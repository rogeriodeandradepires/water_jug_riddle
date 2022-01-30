import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_jug_riddle/helper/enums.dart';
import 'package:water_jug_riddle/state_mgmt/models/buckets_model.dart';
import 'package:water_jug_riddle/state_mgmt/repositories/buckets_repository.dart';

class BucketsNotifier extends StateNotifier<BucketsState> {
  final BucketsRepository _bucketsRepository;
  BucketsModel model = BucketsModel();

  get bucketState => state;

  BucketsNotifier(this._bucketsRepository) : super(const BucketsStateInitial());

  changeAnimateState(bool shouldAnimate){
    if(mounted){
      state = BucketsStateChanged(model..shouldAnimate = shouldAnimate);
    }
  }

  calculateBestSolution() {
    state = BucketsStateChanged(model..isCalculating = true);

    final _stepsList = _bucketsRepository.calculateBestSolution(
        xBucketCapacity: model.bucketsCapacityList[0],
        yBucketCapacity: model.bucketsCapacityList[1],
        zBucketCapacity: model.bucketsCapacityList[2]);

    if (mounted) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        state = BucketsStateChanged(model
          ..stepsList = _stepsList
          ..isCalculating = false);
      });
    }
  }

  changeBucketState(
      {required BucketNameEnum bucket, required BucketStatesEnum newState}) {
    // debugPrint('changeBucketState: $bucket, $newState');
    if (mounted) {
      switch (bucket) {
        case BucketNameEnum.xBucket:
          state = BucketsStateChanged(model
            ..bucketsPreviousStateMap[BucketStateNameEnum.xBucketState] = model
                    .bucketsCurrentStateMap[BucketStateNameEnum.xBucketState] ??
                BucketStatesEnum.empty
            ..bucketsCurrentStateMap[BucketStateNameEnum.xBucketState] =
                newState);
          break;
        case BucketNameEnum.yBucket:
          state = BucketsStateChanged(model
            ..bucketsPreviousStateMap[BucketStateNameEnum.yBucketState] = model
                .bucketsCurrentStateMap[BucketStateNameEnum.yBucketState] ??
                BucketStatesEnum.empty
            ..bucketsCurrentStateMap[BucketStateNameEnum.yBucketState] =
                newState);
          break;
        default:
          state = BucketsStateChanged(model
            ..bucketsPreviousStateMap[BucketStateNameEnum.zBucketState] = model
                .bucketsCurrentStateMap[BucketStateNameEnum.zBucketState] ??
                BucketStatesEnum.empty
            ..bucketsCurrentStateMap[BucketStateNameEnum.zBucketState] =
                newState);
          break;
      }
    }
  }

  changeBucketCapacity(
      {required BucketNameEnum bucket,
      required int value,
      bool? shouldSetNewValue}) {
    if (mounted) {
      if (model.stepsList.isNotEmpty) {
        state = BucketsStateChanged(model..stepsList = []);
      }
      state = BucketsStateChanged(model..isCalculating = true);
      switch (bucket) {
        case BucketNameEnum.xBucket:
          state = (shouldSetNewValue ?? false)
              ? BucketsStateChanged(model
                ..bucketsCapacityList[0] = value
                ..isCalculating = false)
              : BucketsStateChanged(model
                ..bucketsCapacityList[0] += value
                ..isCalculating = false);
          break;
        case BucketNameEnum.yBucket:
          state = (shouldSetNewValue ?? false)
              ? BucketsStateChanged(model
                ..bucketsCapacityList[1] = value
                ..isCalculating = false)
              : BucketsStateChanged(model
                ..bucketsCapacityList[1] += value
                ..isCalculating = false);
          break;
        default:
          state = (shouldSetNewValue ?? false)
              ? BucketsStateChanged(model
                ..bucketsCapacityList[2] = value
                ..isCalculating = false)
              : BucketsStateChanged(model
                ..bucketsCapacityList[2] += value
                ..isCalculating = false);
          break;
      }
    }
  }

  bool checkBucketEmptiness(
      {required BucketNameEnum bucketName, required Map? bucketsStateMap}) {
    if (bucketsStateMap == null) {
      return true;
    }

    final _bucketsStates = [
      bucketsStateMap[BucketStateNameEnum.xBucketState],
      bucketsStateMap[BucketStateNameEnum.yBucketState],
      bucketsStateMap[BucketStateNameEnum.zBucketState]
    ];

    switch (bucketName) {
      case BucketNameEnum.xBucket:
        return _bucketsStates[0] == BucketStatesEnum.empty ? true : false;
      case BucketNameEnum.yBucket:
        return _bucketsStates[1] == BucketStatesEnum.empty ? true : false;
      default:
        return _bucketsStates[2] == BucketStatesEnum.empty ? true : false;
    }
  }
}

enum BucketStatus { initial, changed, error }

abstract class BucketsState {
  const BucketsState();

  BucketsModel? get model => null;
}

class BucketsStateInitial extends BucketsState {
  const BucketsStateInitial();
}

class BucketsStateCalculating extends BucketsState {
  const BucketsStateCalculating();
}

class BucketsStateChanged extends BucketsState {
  @override
  final BucketsModel model;

  BucketsStateChanged(this.model);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BucketsStateChanged && other.model == model;
  }

  @override
  int get hashCode => model.hashCode;
}