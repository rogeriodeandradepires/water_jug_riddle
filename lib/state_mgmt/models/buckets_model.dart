import 'package:water_jug_riddle/helper/enums.dart';

class BucketsModel {
  Map<String, BucketStatesEnum> bucketsStateMap = {
    'xState': BucketStatesEnum.empty,
    'yState': BucketStatesEnum.empty,
    'zState': BucketStatesEnum.empty
  };

  bool isCalculating = false;

  List<int> bucketsCapacityList = [0, 0, 0];
  List<String> stepsList = [];

  BucketsModel();

  getFieldByName(String fieldName) {
    switch (fieldName) {
      case "bucketsStateMap":
        return bucketsStateMap;
      case "bucketsCapacityList":
        return bucketsCapacityList;
      case "stepsList":
        return stepsList;
      case "isCalculating":
        return isCalculating;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BucketsModel &&
        other.isCalculating == isCalculating &&
        other.bucketsStateMap == bucketsStateMap &&
        other.bucketsCapacityList == bucketsCapacityList &&
        other.stepsList == stepsList;
  }

  @override
  int get hashCode => bucketsCapacityList.hashCode ^ stepsList.hashCode;

  Set toJson() {
    return {
      'isCalculating: $isCalculating, '
          'bucketsStateMap: $bucketsStateMap, '
          'bucketsCapacityList: $bucketsCapacityList, '
          'stepsList: $stepsList, '
    };
  }
}