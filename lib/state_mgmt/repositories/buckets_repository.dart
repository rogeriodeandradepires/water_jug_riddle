import 'dart:math';

abstract class BucketsRepository {
  List<String> calculateBestSolution({
    required int xBucketCapacity,
    required int yBucketCapacity,
    required int zBucketCapacity,
  });
}

class PublicBucketsRepository implements BucketsRepository {
  final List<String> _stepsList = [];

  @override
  List<String> calculateBestSolution({
    required int xBucketCapacity,
    required int yBucketCapacity,
    required int zBucketCapacity,
  }) {
    List<String> _stepsList =
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

  /* fromCapacity -- Capacity of cucket from which water is poured
   toCapacity     -- Capacity of cucket to which water is poured
   z              -- Amount to be measured */
  static List<String> pour(int firstBucket, int secondBucket, int zBucket,
      {String? smallerBucket}) {
    List<String> _stepsList = [];
    // Initialize current amount of water in source and destination cuckets
    int from = firstBucket;
    int to = 0;

    // Break the loop when either of the two cuckets has z buckets of water
    if (smallerBucket == 'xBucket') {
      _stepsList.add('Fill Bucket X.');
    } else {
      _stepsList.add('Fill Bucket Y.');
    }

    while (from != zBucket && to != zBucket) {
      // Find the maximum amount that can be
      // poured
      int temp = min(from, secondBucket - to);

      // Pour "temp" buckets "from" to "to"
      to += temp;
      from -= temp;

      if (temp != 0) {
        if (smallerBucket == 'xBucket') {
          _stepsList.add('Transfer Bucket X to Bucket Y');
        } else {
          _stepsList.add('Transfer Bucket Y to Bucket X');
        }
      }

      if (from == zBucket || to == zBucket) break;

      // If first cucket becomes empty, fill it
      if (from == 0) {
        if (smallerBucket == 'xBucket') {
          _stepsList.add('Fill Bucket X.');
        } else {
          _stepsList.add('Fill Bucket y.');
        }
        from = firstBucket;
      }

      // If second cucket becomes full, empty it
      if (to == secondBucket) {
        if (smallerBucket == 'yBucket') {
          _stepsList.add('Empty Bucket X.');
        } else {
          _stepsList.add('Empty Bucket y.');
        }
        to = 0;
      }
    }

    // if (smallerBucket != null) {
    //   debugPrint(_changesList.join(' -> '));
    //   debugPrint(_stepsList.join('\n'));
    // }

    return _stepsList;
  }

  // Returns steps needed to measure z buckets
  static List<String> calculateSteps(int xBucket, int yBucket, int z) {
    // If gcd of n and m does not divide d
    // then solution is not possible
    if ((z % gcd(yBucket, xBucket)) != 0) {
      // debugPrint("No Solution!");
      return ['No Solution!'];
    }

    // Return minimum two cases:
    // a) Water of n liter cucket is poured into
    //    m liter cucket
    // b) Vice versa of "a"

    final firstCaseReturn = pour(yBucket, xBucket, z, smallerBucket: 'yBucket');
    // debugPrint("First case: $firstCaseReturn");

    final secondCaseReturn =
        pour(xBucket, yBucket, z, smallerBucket: 'xBucket');
    // debugPrint("Second case: $secondCaseReturn");

    if (firstCaseReturn.length < secondCaseReturn.length) {
      return firstCaseReturn;
    } else {
      return secondCaseReturn;
    }
  }
}