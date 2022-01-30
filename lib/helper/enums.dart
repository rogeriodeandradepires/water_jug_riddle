import 'package:flutter/foundation.dart';

enum BucketStatesEnum { empty, full, partiallyFull }
enum BucketActionsEnum { empty, fill, transfer, error, solved }
enum AnimProgressEnum { startProgress, endProgress }

extension BucketStatesEnumExtension on BucketStatesEnum {
  double get value => this == BucketStatesEnum.empty
      ? 0.0
      : (this == BucketStatesEnum.partiallyFull ? 60.0 : 100.0);
}

enum BucketNameEnum { xBucket, yBucket, zBucket }
enum BucketStateNameEnum { xBucketState, yBucketState, zBucketState }

extension BucketNameEnumExtension on BucketNameEnum {
  String get value => describeEnum(this);

  String get short => value.substring(0, 1).toUpperCase();
}

enum SupportedPlatformsEnum { web, android, ios }