import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_jug_riddle/helper/constants.dart';
import 'package:water_jug_riddle/helper/enums.dart';
import 'package:water_jug_riddle/helper/screen_size.dart';
import 'package:water_jug_riddle/state_mgmt/providers/buckets_providers.dart';
import 'package:water_jug_riddle/ui/pages_keys/general_keys.dart';
import 'package:water_jug_riddle/ui/shared/colors.dart';
import 'package:water_jug_riddle/ui/shared/shape_styles.dart';
import 'package:water_jug_riddle/ui/widgets/default_button.dart';

class HomePage extends ConsumerWidget {
  const HomePage({required ValueKey key}) : super(key: key);

  static final TextEditingController _xBucketTfController =
      TextEditingController();
  static final TextEditingController _yBucketTfController =
      TextEditingController();
  static final TextEditingController _zBucketTfController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScreenSize.recalculate(context);

    final _bucketsModel = ref.watch(bucketsNotifierProvider).model;

    final _xBucketCapacity = _bucketsModel?.bucketsCapacityList[0] ?? 0;
    final _yBucketCapacity = _bucketsModel?.bucketsCapacityList[1] ?? 0;
    final _zBucketCapacity = _bucketsModel?.bucketsCapacityList[2] ?? 0;

    _xBucketTfController.text = '$_xBucketCapacity';
    _xBucketTfController.selection = TextSelection.fromPosition(
        TextPosition(offset: _xBucketTfController.text.length));

    _yBucketTfController.text = '$_yBucketCapacity';
    _yBucketTfController.selection = TextSelection.fromPosition(
        TextPosition(offset: _yBucketTfController.text.length));

    _zBucketTfController.text = '$_zBucketCapacity';
    _zBucketTfController.selection = TextSelection.fromPosition(
        TextPosition(offset: _zBucketTfController.text.length));

    final _xBucketState =
        _bucketsModel?.bucketsStateMap['xState'] ?? BucketStatesEnum.empty;
    final _yBucketState =
        _bucketsModel?.bucketsStateMap['yState'] ?? BucketStatesEnum.empty;
    final _zBucketState =
        _bucketsModel?.bucketsStateMap['zState'] ?? BucketStatesEnum.empty;

    final _stepsList =
        ref.watch(bucketsNotifierProvider.notifier.select((state) {
      return state.model.stepsList;
    }));

    final _stepsCount =
        _stepsList.length == 1 && _stepsList[0] == 'No Solution!'
            ? 0
            : _stepsList.length;

    final _isWebLargerLayout = kIsWeb && 100.wb >= Constants.tabletWidthScreen;

    return Scaffold(
      backgroundColor: backgroundBottom,
      body: Container(
        decoration: mainBgDecoration,
        height: 100.hb,
        child: Column(
          children: [
            //Bucket's Session
            SizedBox(
                height: 60.hb,
                width: 100.wb,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Buckets
                    SizedBox(
                      height: 25.hb,
                    ),
                    //Buckets' Inputs
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SizedBox(
                        width: _isWebLargerLayout ? 500 : 100.wb,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, right: 5, left: 5),
                                child: Container(
                                  decoration: inputLayoutBackground,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextFormField(
                                        key: ValueKey(
                                            '${(key as ValueKey).value}_xBucketTf'),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        maxLines: 1,
                                        minLines: 1,
                                        controller: _xBucketTfController,
                                        onEditingComplete: () {
                                          ref
                                              .read(bucketsNotifierProvider
                                                  .notifier)
                                              .calculateBestSolution();
                                        },
                                        onChanged: (value) {
                                          {
                                            _manageTextControllerPosition(
                                                'xBucket', value);

                                            if (double.tryParse(value) !=
                                                null) {
                                              ref
                                                  .read(bucketsNotifierProvider
                                                      .notifier)
                                                  .changeBucketCapacity(
                                                      bucket: 'x',
                                                      value: int.parse(value),
                                                      shouldSetNewValue: true);
                                            }
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        keyboardAppearance: Brightness.light,
                                        textInputAction: TextInputAction.done,
                                        cursorColor: primaryColor,
                                        textAlign: TextAlign.center,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              child: Container(
                                                decoration: inputButtonLeft,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    if (_xBucketCapacity > 0) {
                                                      ref
                                                          .read(
                                                              bucketsNotifierProvider
                                                                  .notifier)
                                                          .changeBucketCapacity(
                                                              bucket: 'x',
                                                              value: -1);
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5.0),
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .home_page_bucket_x_label,
                                                    textAlign: TextAlign.center,
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 50,
                                              child: Container(
                                                decoration: inputButtonRight,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    ref
                                                        .read(
                                                            bucketsNotifierProvider
                                                                .notifier)
                                                        .changeBucketCapacity(
                                                            bucket: 'x',
                                                            value: 1);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, right: 5, left: 5),
                                child: Container(
                                  decoration: inputLayoutBackground,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextFormField(
                                        key: ValueKey(
                                            '${(key as ValueKey).value}_yBucketTf'),
                                        // initialValue: '${0}',
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        maxLines: 1,
                                        minLines: 1,
                                        controller: _yBucketTfController,
                                        onChanged: (value) {
                                          {
                                            _manageTextControllerPosition(
                                                'yBucket', value);
                                            if (double.tryParse(value) !=
                                                null) {
                                              ref
                                                  .read(bucketsNotifierProvider
                                                      .notifier)
                                                  .changeBucketCapacity(
                                                      bucket: 'y',
                                                      value: int.parse(value),
                                                      shouldSetNewValue: true);
                                            }
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        keyboardAppearance: Brightness.light,
                                        textInputAction: TextInputAction.done,
                                        cursorColor: primaryColor,
                                        textAlign: TextAlign.center,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              child: Container(
                                                decoration: inputButtonLeft,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    if (_yBucketCapacity > 0) {
                                                      ref
                                                          .read(
                                                              bucketsNotifierProvider
                                                                  .notifier)
                                                          .changeBucketCapacity(
                                                              bucket: 'y',
                                                              value: -1);
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .home_page_bucket_y_label,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                              child: Container(
                                                decoration: inputButtonRight,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    ref
                                                        .read(
                                                            bucketsNotifierProvider
                                                                .notifier)
                                                        .changeBucketCapacity(
                                                            bucket: 'y',
                                                            value: 1);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, right: 5, left: 5),
                                child: Container(
                                  decoration: inputLayoutBackground,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextFormField(
                                        key: ValueKey(
                                            '${(key as ValueKey).value}_zBucketTf'),
                                        // initialValue: '${0}',
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        maxLines: 1,
                                        minLines: 1,
                                        controller: _zBucketTfController,
                                        onChanged: (value) {
                                          {
                                            _manageTextControllerPosition(
                                                'zBucket', value);
                                            if (double.tryParse(value) !=
                                                null) {
                                              ref
                                                  .read(bucketsNotifierProvider
                                                      .notifier)
                                                  .changeBucketCapacity(
                                                      bucket: 'z',
                                                      value: int.parse(value),
                                                      shouldSetNewValue: true);
                                            }
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        keyboardAppearance: Brightness.light,
                                        textInputAction: TextInputAction.done,
                                        cursorColor: primaryColor,
                                        textAlign: TextAlign.center,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              child: Container(
                                                decoration: inputButtonLeft,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    if (_zBucketCapacity > 0) {
                                                      ref
                                                          .read(
                                                              bucketsNotifierProvider
                                                                  .notifier)
                                                          .changeBucketCapacity(
                                                              bucket: 'z',
                                                              value: -1);
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .home_page_bucket_z_label,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                              child: Container(
                                                decoration: inputButtonRight,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    ref
                                                        .read(
                                                            bucketsNotifierProvider
                                                                .notifier)
                                                        .changeBucketCapacity(
                                                            bucket: 'z',
                                                            value: 1);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Goal Info
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Text(
                          AppLocalizations.of(context)!.home_page_goal_label),
                    ),
                    //Button
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: DefaultButton(
                        key: ValueKey(
                            HomePageKeys.mainKey(suffix: ':xBucketTf')),
                        providerToWatch: bucketsNotifierProvider,
                        fieldToWatch: 'isCalculating',
                        width: _isWebLargerLayout ? 380 : 250,
                        label: AppLocalizations.of(context)!
                            .home_page_button_label,
                        onTapCallback: () {
                          ref
                              .read(bucketsNotifierProvider.notifier)
                              .calculateBestSolution();
                        },
                      ),
                    ),
                    //Steps
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                          "${AppLocalizations.of(context)!.home_page_steps_label} ${_stepsCount.toString()}"),
                    ),
                  ],
                )),
            //Steps List
            SizedBox(
              height: 40.hb,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(rect.width, 25, 0, 0));
                },
                blendMode: BlendMode.dstIn,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                    scrollbars: false,
                  ),
                  child: SingleChildScrollView(
                    clipBehavior: Clip.antiAlias,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _stepsList.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(_stepsList[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _manageTextControllerPosition(String bucket, String value) {
    switch (bucket) {
      case 'xBucket':
        if (value.isEmpty) {
          _xBucketTfController.text = '0';
          _xBucketTfController.selection = TextSelection.fromPosition(
              TextPosition(offset: _xBucketTfController.text.length));
        }

        if (value.length > 1 && value.startsWith('0')) {
          _xBucketTfController.text = value.substring(1, 2);
          _xBucketTfController.selection = TextSelection.fromPosition(
              TextPosition(offset: _xBucketTfController.text.length));
        } else {
          _xBucketTfController.selection = TextSelection.fromPosition(
              TextPosition(offset: _xBucketTfController.text.length));
        }
        break;
      case 'yBucket':
        if (value.isEmpty) {
          _yBucketTfController.text = '0';
          _yBucketTfController.selection = TextSelection.fromPosition(
              TextPosition(offset: _yBucketTfController.text.length));
        }

        if (value.length > 1 && value.startsWith('0')) {
          _yBucketTfController.text = value.substring(1, 2);
          _yBucketTfController.selection = TextSelection.fromPosition(
              TextPosition(offset: _yBucketTfController.text.length));
        } else {
          _yBucketTfController.selection = TextSelection.fromPosition(
              TextPosition(offset: _yBucketTfController.text.length));
        }
        break;
      default:
        if (value.isEmpty) {
          _zBucketTfController.text = '0';
          _zBucketTfController.selection = TextSelection.fromPosition(
              TextPosition(offset: _zBucketTfController.text.length));
        }

        if (value.length > 1 && value.startsWith('0')) {
          _zBucketTfController.text = value.substring(1, 2);
          _zBucketTfController.selection = TextSelection.fromPosition(
              TextPosition(offset: _zBucketTfController.text.length));
        } else {
          _zBucketTfController.selection = TextSelection.fromPosition(
              TextPosition(offset: _zBucketTfController.text.length));
        }
        break;
    }
  }
}