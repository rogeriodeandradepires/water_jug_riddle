import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:water_jug_riddle/ui/shared/text_styles.dart';
import 'package:water_jug_riddle/ui/widgets/default_button.dart';
import 'package:water_jug_riddle/ui/widgets/liquidify/liquid_fill.dart';

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

    final _stepsList =
        ref.watch(bucketsNotifierProvider.notifier.select((state) {
      return state.model.stepsList;
    }));

    final _stepsCount = _stepsList.length == 1 &&
            _stepsList[0]['action'] == BucketActionsEnum.none
        ? 0
        : _stepsList.length;

    final _isWebLargerLayout = kIsWeb && 100.wb >= Constants.tabletWidthScreen;

    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      if (_stepsList.isNotEmpty && _stepsCount > 0) {
        if (_bucketsModel != null && _bucketsModel.shouldAnimate) {
          ref.read(bucketsNotifierProvider.notifier).changeAnimateState(false);
          for (Map _stepMap in _stepsList) {
            bool _isFirstIndex = _stepsList.indexOf(_stepMap) == 0;
            bool _isLastIndex =
                _stepsList.indexOf(_stepMap) == _stepsList.length - 1;

            BucketActionsEnum action = _stepMap['action'];
            BucketNameEnum _bucketName =
                _stepMap['bucketName'] ?? BucketNameEnum.zBucket;
            BucketNameEnum _toBucketName;

            switch (action) {
              case BucketActionsEnum.fill:
                Future.delayed(Duration(milliseconds: _isFirstIndex ? 0 : 2000),
                    () {
                  ref.read(bucketsNotifierProvider.notifier).changeBucketState(
                      bucket: _bucketName, newState: BucketStatesEnum.full);

                  if (_isLastIndex) {
                    Future.delayed(const Duration(milliseconds: 2000), () {
                      ref
                          .read(bucketsNotifierProvider.notifier)
                          .changeAnimateState(true);
                    });
                  }
                });
                break;
              case BucketActionsEnum.transfer:
                _toBucketName = _stepMap['toBucketName'];
                Future.delayed(Duration(milliseconds: _isFirstIndex ? 0 : 2000),
                    () {
                  switch (_bucketsModel.bucketsPreviousStateMap[_bucketName]) {
                    case BucketStatesEnum.empty:
                      if (_bucketsModel.bucketsCurrentStateMap[_bucketName] ==
                          BucketStatesEnum.partiallyFull) {
                        ref.read(bucketsNotifierProvider.notifier).changeBucketState(
                            bucket: _bucketName,
                            newState: BucketStatesEnum.partiallyFull);
                      }else if (_bucketsModel.bucketsCurrentStateMap[_bucketName] ==
                          BucketStatesEnum.full) {
                        ref.read(bucketsNotifierProvider.notifier).changeBucketState(
                            bucket: _bucketName,
                            newState: BucketStatesEnum.full);
                      }
                      break;
                    case BucketStatesEnum.partiallyFull:
                      if (_bucketsModel.bucketsCurrentStateMap[_bucketName] ==
                          BucketStatesEnum.empty) {
                        ref.read(bucketsNotifierProvider.notifier).changeBucketState(
                            bucket: _bucketName,
                            newState: BucketStatesEnum.empty);
                      }else if (_bucketsModel.bucketsCurrentStateMap[_bucketName] ==
                          BucketStatesEnum.full) {
                        ref.read(bucketsNotifierProvider.notifier).changeBucketState(
                            bucket: _bucketName,
                            newState: BucketStatesEnum.full);
                      }

                      switch(_bucketsModel.bucketsPreviousStateMap[_toBucketName]){
                        case BucketStatesEnum.empty:
                          if (_bucketsModel.bucketsCurrentStateMap[_toBucketName] ==
                              BucketStatesEnum.partiallyFull) {
                            ref.read(bucketsNotifierProvider.notifier).changeBucketState(
                                bucket: _toBucketName,
                                newState: BucketStatesEnum.partiallyFull);
                          }else if (_bucketsModel.bucketsCurrentStateMap[_toBucketName] ==
                              BucketStatesEnum.full) {
                            ref.read(bucketsNotifierProvider.notifier).changeBucketState(
                                bucket: _toBucketName,
                                newState: BucketStatesEnum.full);
                          }
                          break;
                        case BucketStatesEnum.partiallyFull:
                          if (_bucketsModel.bucketsCurrentStateMap[_toBucketName] ==
                              BucketStatesEnum.empty) {
                            ref.read(bucketsNotifierProvider.notifier).changeBucketState(
                                bucket: _toBucketName,
                                newState: BucketStatesEnum.empty);
                          }else if (_bucketsModel.bucketsCurrentStateMap[_toBucketName] ==
                              BucketStatesEnum.full) {
                            ref.read(bucketsNotifierProvider.notifier).changeBucketState(
                                bucket: _toBucketName,
                                newState: BucketStatesEnum.full);
                          }
                          break;
                        default://FULL
                          if (_bucketsModel.bucketsCurrentStateMap[_toBucketName] ==
                              BucketStatesEnum.partiallyFull) {
                            ref.read(bucketsNotifierProvider.notifier).changeBucketState(
                                bucket: _toBucketName,
                                newState: BucketStatesEnum.partiallyFull);
                          }else if (_bucketsModel.bucketsCurrentStateMap[_toBucketName] ==
                              BucketStatesEnum.empty) {
                            ref.read(bucketsNotifierProvider.notifier).changeBucketState(
                                bucket: _toBucketName,
                                newState: BucketStatesEnum.empty);
                          }
                          break;
                      }

                      break;
                    default: //FULL
                      if (_bucketsModel.bucketsCurrentStateMap[_bucketName] ==
                          BucketStatesEnum.partiallyFull) {
                        ref.read(bucketsNotifierProvider.notifier).changeBucketState(
                            bucket: _bucketName,
                            newState: BucketStatesEnum.partiallyFull);
                      }else if (_bucketsModel.bucketsCurrentStateMap[_bucketName] ==
                          BucketStatesEnum.empty) {
                        ref.read(bucketsNotifierProvider.notifier).changeBucketState(
                            bucket: _bucketName,
                            newState: BucketStatesEnum.empty);
                      }
                      break;
                  }


                  // ref.read(bucketsNotifierProvider.notifier).changeBucketState(
                  //     bucket: _toBucketName,
                  //     newState: BucketStatesEnum.partiallyFull);

                  if (_isLastIndex) {
                    Future.delayed(const Duration(milliseconds: 2000), () {
                      ref
                          .read(bucketsNotifierProvider.notifier)
                          .changeAnimateState(true);
                    });
                  }
                });
                break;
              case BucketActionsEnum.empty:
                Future.delayed(Duration(milliseconds: _isFirstIndex ? 0 : 2000),
                    () {
                  ref.read(bucketsNotifierProvider.notifier).changeBucketState(
                      bucket: _bucketName, newState: BucketStatesEnum.empty);

                  if (_isLastIndex) {
                    Future.delayed(const Duration(milliseconds: 2000), () {
                      ref
                          .read(bucketsNotifierProvider.notifier)
                          .changeAnimateState(true);
                    });
                  }
                });
                break;
              default:
                break;
            }
          }
        }

        // final _timer =
        //     Timer.periodic(const Duration(milliseconds: 1500), (Timer t) {});
      }
    });

    return Scaffold(
      backgroundColor: backgroundBottom,
      body: Container(
        decoration: mainBgDecoration,
        height: 100.hb,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
            scrollbars: false,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildBucketsSession(context, _stepsCount, _isWebLargerLayout,
                    _bucketsModel, _stepsList),
                //Steps List
                ShaderMask(
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
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _stepsList.length,
                      itemBuilder: (context, index) {
                        final _stepText = getStepText(context,
                            index: index + 1, currentMap: _stepsList[index]);

                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Text(
                              _stepText,
                              style: balooRegular.copyWith(
                                  fontSize: kIsWeb ? 16 : 13,
                                  color: primaryColor,
                                  height: 1),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _manageTextControllerPosition(BucketNameEnum bucket, String value) {
    switch (bucket) {
      case BucketNameEnum.xBucket:
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
      case BucketNameEnum.yBucket:
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

  String getStepText(context, {required int index, required Map currentMap}) {
    BucketActionsEnum action = currentMap['action'];
    BucketNameEnum _bucketName =
        currentMap['bucketName'] ?? BucketNameEnum.zBucket;
    BucketNameEnum _toBucketName;

    switch (action) {
      case BucketActionsEnum.fill:
        return '$index. ${AppLocalizations.of(context)!.action_fill.replaceAll('{bucket}', _bucketName.short)}';
      case BucketActionsEnum.transfer:
        _toBucketName = currentMap['toBucketName'];
        return '$index. ${AppLocalizations.of(context)!.action_transfer.replaceAll('{from}', _bucketName.short).replaceAll('{to}', _toBucketName.short)}';
      case BucketActionsEnum.empty:
        return '$index. ${AppLocalizations.of(context)!.action_empty.replaceAll('{bucket}', _bucketName.short)}';
      default:
        return AppLocalizations.of(context)!.action_no_solution;
    }
  }

  List<Map> _getFillingProgresses(
    List<Map> stepsList,
    Map<BucketStateNameEnum, BucketStatesEnum> bucketsCurrentStateMap,
    Map<BucketStateNameEnum, BucketStatesEnum> bucketsPreviousStateMap,
  ) {
    final _xBucketPreviousState =
        bucketsPreviousStateMap[BucketStateNameEnum.xBucketState] ??
            BucketStatesEnum.empty;
    final _yBucketPreviousState =
        bucketsPreviousStateMap[BucketStateNameEnum.yBucketState] ??
            BucketStatesEnum.empty;
    final _zBucketPreviousState =
        bucketsPreviousStateMap[BucketStateNameEnum.zBucketState] ??
            BucketStatesEnum.empty;

    final _xBucketCurrentState =
        bucketsCurrentStateMap[BucketStateNameEnum.xBucketState] ??
            BucketStatesEnum.empty;
    final _yBucketCurrentState =
        bucketsCurrentStateMap[BucketStateNameEnum.yBucketState] ??
            BucketStatesEnum.empty;
    final _zBucketCurrentState =
        bucketsCurrentStateMap[BucketStateNameEnum.zBucketState] ??
            BucketStatesEnum.empty;

    return [
      {
        AnimProgressEnum.startProgress: _xBucketPreviousState.value,
        AnimProgressEnum.endProgress: _xBucketCurrentState.value
      },
      {
        AnimProgressEnum.startProgress: _yBucketPreviousState.value,
        AnimProgressEnum.endProgress: _yBucketCurrentState.value
      },
      {
        AnimProgressEnum.startProgress: _zBucketPreviousState.value,
        AnimProgressEnum.endProgress: _zBucketCurrentState.value
      },
    ];
  }

  _buildBucketsSession(BuildContext context, _stepsCount, _isWebLargerLayout,
      _bucketsModel, _stepsList) {
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

    List<Map> _fillingProgresses = _getFillingProgresses(
        _stepsList,
        _bucketsModel?.bucketsCurrentStateMap ?? {},
        _bucketsModel?.bucketsPreviousStateMap ?? {});

    return //Bucket's Session Column
        Consumer(builder: (context, ref, child) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Buckets Session's Step Info
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 22, right: 22),
              child: Text(
                _stepsCount == 0
                    ? AppLocalizations.of(context)!.home_page_info
                    : AppLocalizations.of(context)!.bucket_session_step_label,
                style: balooRegular.copyWith(
                    fontSize: kIsWeb ? 19 : 16, color: primaryColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          //Buckets Session
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
                      padding:
                          const EdgeInsets.only(top: 50.0, right: 5, left: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Bucket X
                          SizedBox(
                            // height: 25.hb,
                            child: LiquidFill(
                              boxBackgroundColor: Colors.white,
                              boxHeight: 120,
                              boxWidth: 120,
                              loadDuration: const Duration(seconds: 2),
                              waveDuration: const Duration(milliseconds: 1500),
                              key: null,
                              startProgress: _fillingProgresses[0]
                                  [AnimProgressEnum.startProgress],
                              endProgress: _fillingProgresses[0]
                                  [AnimProgressEnum.endProgress],
                              bucketName: BucketNameEnum.xBucket,
                            ),
                          ),
                          //Bucket X Inputs
                          Container(
                            margin: const EdgeInsets.only(top: 25),
                            decoration: inputLayoutBackground,
                            child: Column(
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
                                        .read(bucketsNotifierProvider.notifier)
                                        .calculateBestSolution();
                                  },
                                  onChanged: (value) {
                                    {
                                      _manageTextControllerPosition(
                                          BucketNameEnum.xBucket, value);

                                      if (double.tryParse(value) != null) {
                                        ref
                                            .read(bucketsNotifierProvider
                                                .notifier)
                                            .changeBucketCapacity(
                                                bucket: BucketNameEnum.xBucket,
                                                value: int.parse(value),
                                                shouldSetNewValue: true);
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  keyboardAppearance: Brightness.light,
                                  textInputAction: TextInputAction.done,
                                  cursorColor: primaryColor,
                                  style: balooRegular.copyWith(
                                      fontSize: kIsWeb ? 19 : 16,
                                      color: primaryColor,
                                      height: 1),
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                        bucket: BucketNameEnum
                                                            .xBucket,
                                                        value: -1);
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .home_page_bucket_x_label,
                                              style: balooRegular.copyWith(
                                                  fontSize: kIsWeb ? 16 : 13,
                                                  color: primaryColor,
                                                  height: 1),
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
                                                  .read(bucketsNotifierProvider
                                                      .notifier)
                                                  .changeBucketCapacity(
                                                      bucket: BucketNameEnum
                                                          .xBucket,
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
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 50.0, right: 5, left: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Bucket Y
                          SizedBox(
                            // height: 25.hb,
                            child: LiquidFill(
                              boxBackgroundColor: Colors.white,
                              boxHeight: 120,
                              boxWidth: 120,
                              loadDuration: const Duration(seconds: 2),
                              waveDuration: const Duration(milliseconds: 1500),
                              key: null,
                              startProgress: _fillingProgresses[0]
                                  [AnimProgressEnum.startProgress],
                              endProgress: _fillingProgresses[0]
                                  [AnimProgressEnum.endProgress],
                              bucketName: BucketNameEnum.yBucket,
                            ),
                          ),
                          //Bucket Y Inputs
                          Container(
                            margin: const EdgeInsets.only(top: 25),
                            decoration: inputLayoutBackground,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: ValueKey(
                                      '${(key as ValueKey).value}_yBucketTf'),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  maxLines: 1,
                                  minLines: 1,
                                  controller: _yBucketTfController,
                                  onEditingComplete: () {
                                    ref
                                        .read(bucketsNotifierProvider.notifier)
                                        .calculateBestSolution();
                                  },
                                  onChanged: (value) {
                                    {
                                      _manageTextControllerPosition(
                                          BucketNameEnum.yBucket, value);

                                      if (double.tryParse(value) != null) {
                                        ref
                                            .read(bucketsNotifierProvider
                                                .notifier)
                                            .changeBucketCapacity(
                                                bucket: BucketNameEnum.yBucket,
                                                value: int.parse(value),
                                                shouldSetNewValue: true);
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  keyboardAppearance: Brightness.light,
                                  textInputAction: TextInputAction.done,
                                  cursorColor: primaryColor,
                                  style: balooRegular.copyWith(
                                      fontSize: kIsWeb ? 19 : 16,
                                      color: primaryColor,
                                      height: 1),
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                        bucket: BucketNameEnum
                                                            .yBucket,
                                                        value: -1);
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .home_page_bucket_y_label,
                                              style: balooRegular.copyWith(
                                                  fontSize: kIsWeb ? 16 : 13,
                                                  color: primaryColor,
                                                  height: 1),
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
                                                  .read(bucketsNotifierProvider
                                                      .notifier)
                                                  .changeBucketCapacity(
                                                      bucket: BucketNameEnum
                                                          .yBucket,
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
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 50.0, right: 5, left: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Bucket Z
                          SizedBox(
                            // height: 25.hb,
                            child: LiquidFill(
                              boxBackgroundColor: Colors.white,
                              boxHeight: 120,
                              boxWidth: 120,
                              loadDuration: const Duration(seconds: 2),
                              waveDuration: const Duration(milliseconds: 1500),
                              key: null,
                              startProgress: _fillingProgresses[0]
                                  [AnimProgressEnum.startProgress],
                              endProgress: _fillingProgresses[0]
                                  [AnimProgressEnum.endProgress],
                              bucketName: BucketNameEnum.zBucket,
                            ),
                          ),
                          //Bucket Z Inputs
                          Container(
                            margin: const EdgeInsets.only(top: 25),
                            decoration: inputLayoutBackground,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: ValueKey(
                                      '${(key as ValueKey).value}_zBucketTf'),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  maxLines: 1,
                                  minLines: 1,
                                  controller: _zBucketTfController,
                                  onEditingComplete: () {
                                    ref
                                        .read(bucketsNotifierProvider.notifier)
                                        .calculateBestSolution();
                                  },
                                  onChanged: (value) {
                                    {
                                      _manageTextControllerPosition(
                                          BucketNameEnum.zBucket, value);

                                      if (double.tryParse(value) != null) {
                                        ref
                                            .read(bucketsNotifierProvider
                                                .notifier)
                                            .changeBucketCapacity(
                                                bucket: BucketNameEnum.zBucket,
                                                value: int.parse(value),
                                                shouldSetNewValue: true);
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  keyboardAppearance: Brightness.light,
                                  textInputAction: TextInputAction.done,
                                  cursorColor: primaryColor,
                                  style: balooRegular.copyWith(
                                      fontSize: kIsWeb ? 19 : 16,
                                      color: primaryColor,
                                      height: 1),
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                        bucket: BucketNameEnum
                                                            .zBucket,
                                                        value: -1);
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .home_page_bucket_z_label,
                                              style: balooRegular.copyWith(
                                                  fontSize: kIsWeb ? 16 : 13,
                                                  color: primaryColor,
                                                  height: 1),
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
                                                  .read(bucketsNotifierProvider
                                                      .notifier)
                                                  .changeBucketCapacity(
                                                      bucket: BucketNameEnum
                                                          .zBucket,
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
                        ],
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
              AppLocalizations.of(context)!.home_page_goal_label,
              style: balooRegular.copyWith(
                fontSize: kIsWeb ? 19 : 16,
                color: primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          //Button
          Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
            ),
            child: DefaultButton(
              key: ValueKey(HomePageKeys.mainKey(suffix: ':xBucketTf')),
              providerToWatch: bucketsNotifierProvider,
              fieldToWatch: 'isCalculating',
              width: _isWebLargerLayout ? 380 : 250,
              label: AppLocalizations.of(context)!.home_page_button_label,
              onTapCallback: () {
                ref
                    .read(bucketsNotifierProvider.notifier)
                    .calculateBestSolution();
              },
            ),
          ),
          //Steps
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Text(
              "${AppLocalizations.of(context)!.home_page_steps_label} ${_stepsCount.toString()}",
              style: balooRegular.copyWith(
                  fontSize: kIsWeb ? 19 : 16, color: primaryColor, height: 1),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    });
  }
}