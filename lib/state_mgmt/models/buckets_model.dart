import 'package:water_jug_riddle/helper/enums.dart';

class BucketsModel {
  Map<BucketStateNameEnum, BucketStatesEnum> bucketsCurrentStateMap = {
    BucketStateNameEnum.xBucketState: BucketStatesEnum.empty,
    BucketStateNameEnum.yBucketState: BucketStatesEnum.empty,
    BucketStateNameEnum.zBucketState: BucketStatesEnum.empty
  };

  Map<BucketStateNameEnum, BucketStatesEnum> bucketsPreviousStateMap = {
    BucketStateNameEnum.xBucketState: BucketStatesEnum.empty,
    BucketStateNameEnum.yBucketState: BucketStatesEnum.empty,
    BucketStateNameEnum.zBucketState: BucketStatesEnum.empty
  };

  bool isCalculating = false;
  bool shouldAnimate = true;

  List<int> bucketsCapacityList = [0, 0, 0];
  List<Map> stepsList = [];

  BucketsModel();

  getFieldByName(String fieldName) {
    switch (fieldName) {
      case "bucketsPreviousStateMap":
        return bucketsPreviousStateMap;
      case "bucketsStateMap":
        return bucketsCurrentStateMap;
      case "bucketsCapacityList":
        return bucketsCapacityList;
      case "stepsList":
        return stepsList;
      case "isCalculating":
        return isCalculating;
      case "shouldAnimate":
        return shouldAnimate;
      default:
        return null;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BucketsModel &&
        other.isCalculating == isCalculating &&
        other.shouldAnimate == shouldAnimate &&
        other.bucketsCurrentStateMap == bucketsCurrentStateMap &&
        other.bucketsPreviousStateMap == bucketsPreviousStateMap &&
        other.bucketsCapacityList == bucketsCapacityList &&
        other.stepsList == stepsList;
  }

  @override
  int get hashCode => bucketsCapacityList.hashCode ^ stepsList.hashCode;

  Set toJson() {
    return {
      'shouldAnimate: $shouldAnimate, '
      'isCalculating: $isCalculating, '
          'bucketsPreviousStateMap: $bucketsPreviousStateMap, '
          'bucketsStateMap: $bucketsCurrentStateMap, '
          'bucketsCapacityList: $bucketsCapacityList, '
          'stepsList: $stepsList, '
    };
  }
}