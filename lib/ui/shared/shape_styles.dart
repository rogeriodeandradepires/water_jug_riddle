import 'package:flutter/material.dart';

import 'colors.dart';

/////////////////////////////////////
///    GENERAL BACKGROUNDS
////////////////////////////////////

BoxDecoration mainBgDecoration = const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    stops: [0,0.5,1],
    end: FractionalOffset.bottomCenter,
    colors: [Colors.white, Colors.white, mainGradient2],
  ),
);

ShapeDecoration inputLayoutBackground = ShapeDecoration(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: airSuperiorityBlue.withOpacity(0.25));

ShapeDecoration inputButtonLeft = ShapeDecoration(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12))),
    color: airSuperiorityBlue.withOpacity(0.5));

ShapeDecoration inputButtonRight = ShapeDecoration(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(12))),
    color: airSuperiorityBlue.withOpacity(0.5));

ShapeDecoration buttonDefault = ShapeDecoration(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
  color: stPatrickBlue,
);

ShapeDecoration buttonFaded = ShapeDecoration(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
  color: stPatrickBlue.withOpacity(0.15),
);