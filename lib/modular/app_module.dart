import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:water_jug_riddle/ui/pages_keys/general_keys.dart';
import 'package:water_jug_riddle/ui/screens/error_page.dart';
import 'package:water_jug_riddle/ui/screens/home_page.dart';

import 'routes/routes.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  late List<ModularRoute> routes = _getAllPaths();

  _getAllPaths() {
    final _allPaths = [
      ChildRoute(RoutePaths.start(),
          child: (_, args) => HomePage(key: ValueKey(HomePageKeys.mainKey()))),
    ];

    _allPaths.add(WildcardRoute(
        child: (context, args) =>
            ErrorPage(key: ValueKey(ErrorPageKeys.mainKey()))));

    return _allPaths;
  }
}