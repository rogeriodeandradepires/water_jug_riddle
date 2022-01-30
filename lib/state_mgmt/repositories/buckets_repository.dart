import 'dart:math';

import 'package:water_jug_riddle/helper/enums.dart';

abstract class BucketsRepository {
  List<Map> calculateBestSolution({
    required int xBucketCapacity,
    required int yBucketCapacity,
    required int zBucketCapacity,
  });
}

class PublicBucketsRepository implements BucketsRepository {
  @override
  List<Map> calculateBestSolution({
    required int xBucketCapacity,
    required int yBucketCapacity,
    required int zBucketCapacity,
  }) {
    List<Map> _stepsList =
        calculateSteps(xBucketCapacity, yBucketCapacity, zBucketCapacity);

    return _stepsList;
  }

  // Utility function to return GCD of 'a' and 'b'.
  static int gcd(int a, int b) {
    if (b == 0) {
      return a;
    }
    return gcd(b, a % b);
  }

  /* fromCapacity -- Capacity of bucket from which water is poured
   toCapacity     -- Capacity of bucket to which water is poured
   z              -- Amount to be measured */
  static List<Map> pour(int firstBucket, int secondBucket, int zBucket,
      {BucketNameEnum? smallerBucket}) {
    List<Map> _stepsList = [];
    List<String> _changesList = [];
    // Initialize current amount of water in source and destination buckets
    int from = firstBucket;
    int to = 0;

    // Break the loop when either of the two buckets has z buckets of water
    if (smallerBucket == BucketNameEnum.xBucket) {
      _stepsList.add({
        'action': BucketActionsEnum.fill,
        'bucketName': BucketNameEnum.xBucket,
        'bucketValue': from,
        'bucketValueTo': to
      });
    } else {
      _stepsList.add({
        'action': BucketActionsEnum.fill,
        'bucketName': BucketNameEnum.yBucket,
        'bucketValue': from,
        'bucketValueTo': to
      });
    }

    _changesList.add('$from, $to');

    while (from != zBucket && to != zBucket) {
      // Find the maximum amount that can be
      // poured
      int temp = min(from, secondBucket - to);

      // Pour "temp" buckets "from" to "to"
      to += temp;
      from -= temp;

      _changesList.add('$from, $to');

      if (temp != 0) {
        if (smallerBucket == BucketNameEnum.xBucket) {
          _stepsList.add({
            'action': BucketActionsEnum.transfer,
            'bucketName': BucketNameEnum.xBucket,
            'toBucketName': BucketNameEnum.yBucket,
            'bucketValue': from,
            'bucketValueTo': to
          });
        } else {
          _stepsList.add({
            'action': BucketActionsEnum.transfer,
            'bucketName': BucketNameEnum.yBucket,
            'toBucketName': BucketNameEnum.xBucket,
            'bucketValue': from,
            'bucketValueTo': to
          });
        }
      }

      if (from == zBucket || to == zBucket) break;

      // If first bucket becomes empty, fill it
      if (from == 0) {
        from = firstBucket;

        _changesList.add('$from, $to');

        if (smallerBucket == BucketNameEnum.xBucket) {
          _stepsList.add({
            'action': BucketActionsEnum.fill,
            'bucketName': BucketNameEnum.xBucket,
            'bucketValue': from,
            'bucketValueTo': to
          });
        } else {
          _stepsList.add({
            'action': BucketActionsEnum.fill,
            'bucketName': BucketNameEnum.yBucket,
            'bucketValue': from,
            'bucketValueTo': to
          });
        }
      }

      // If second bucket becomes full, empty it
      if (to == secondBucket) {
        to = 0;

        if (smallerBucket == BucketNameEnum.yBucket) {
          _stepsList.add({
            'action': BucketActionsEnum.empty,
            'bucketName': BucketNameEnum.xBucket,
            'bucketValue': to,
            'bucketValueTo': from
          });
        } else {
          _stepsList.add({
            'action': BucketActionsEnum.empty,
            'bucketName': BucketNameEnum.yBucket,
            'bucketValue': to,
            'bucketValueTo': from
          });
        }

        _changesList.add('$from, $to');
      }
    }

    // if (smallerBucket != null) {
    //   // debugPrint(_stepsList.join('\n'));
    //   debugPrint(_changesList.join(' -> '));
    // }

    return _stepsList;
  }

  // Returns steps needed to measure z buckets
  static List<Map> calculateSteps(
      int xBucketCapacity, int yBucketCapacity, int zBucketCapacity) {
    // If gcd of n and m does not divide d
    // then solution is not possible

    if (zBucketCapacity > max(xBucketCapacity, yBucketCapacity)) {
      return [
        {'action': BucketActionsEnum.error}
      ];
    }

    try {
      if ((zBucketCapacity % gcd(yBucketCapacity, xBucketCapacity)) != 0) {
        return [
          {'action': BucketActionsEnum.error}
        ];
      }
    } catch (e) {
      return [
        {'action': BucketActionsEnum.error}
      ];
    }

    // Return minimum two cases:
    // a) Water of n liter bucket is poured into
    //    m liter bucket
    // b) Vice versa of "a"

    List<Map> firstCaseReturn;

    try {
      firstCaseReturn = pour(yBucketCapacity, xBucketCapacity, zBucketCapacity,
          smallerBucket: BucketNameEnum.yBucket);
    } catch (e) {
      firstCaseReturn = [
        {'action': BucketActionsEnum.error}
      ];
    }

    // debugPrint("First case: $firstCaseReturn");

    List<Map> secondCaseReturn;

    try {
      secondCaseReturn = pour(xBucketCapacity, yBucketCapacity, zBucketCapacity,
          smallerBucket: BucketNameEnum.xBucket);
    } catch (e) {
      secondCaseReturn = [
        {'action': BucketActionsEnum.error}
      ];
    }
    // debugPrint("Second case: $secondCaseReturn");

    if (firstCaseReturn.length < secondCaseReturn.length) {
      return firstCaseReturn;
    } else {
      return secondCaseReturn;
    }
  }
}