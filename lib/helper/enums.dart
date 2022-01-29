import 'package:flutter/foundation.dart';

enum BucketStatesEnum { empty, full, partiallyFull }

extension BucketStatesEnumExtension on BucketStatesEnum {
  String get value => describeEnum(this);
}

enum SupportedPlatformsEnum { web, android, ios }