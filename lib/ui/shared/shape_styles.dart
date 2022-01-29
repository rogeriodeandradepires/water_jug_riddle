import 'package:flutter/material.dart';

import 'colors.dart';

/////////////////////////////////////
///    GENERAL BACKGROUNDS
////////////////////////////////////

BoxDecoration mainBgDecoration = const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: FractionalOffset.bottomCenter,
    colors: [mainGradient1, mainGradient2],
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
  color: primaryColor,
);

ShapeDecoration buttonFaded = ShapeDecoration(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
  color: primaryColor.withOpacity(0.4),
);