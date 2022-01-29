import 'package:water_jug_riddle/helper/extensions.dart';

class ApplicationKeys {
  static const String _pageMainKey = 'application';

  static String mainKey({String? suffix}) {
    return _pageMainKey.append(suffix);
  }
}

class HomePageKeys {
  static const String _pageMainKey = 'home';

  static String mainKey({String? suffix}) {
    return _pageMainKey.append(suffix);
  }
}

class ErrorPageKeys {
  static const String _pageMainKey = 'error';

  static String mainKey({String? suffix}) {
    return _pageMainKey.append(suffix);
  }
}