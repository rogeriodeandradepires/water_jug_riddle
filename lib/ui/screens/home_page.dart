import 'dart:ui';

import 'package:align_positioned/align_positioned.dart';
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
import 'package:water_jug_riddle/ui/shared/text_styles.dart';
import 'package:water_jug_riddle/ui/widgets/default_button.dart';
import 'package:water_jug_riddle/ui/widgets/liquefy/liquid_fill.dart';

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
            _stepsList[0]['action'] == BucketActionsEnum.error
        ? 0
        : _stepsList.length;

    final _isWebLargerLayout = kIsWeb && 100.wb >= Constants.tabletWidthScreen;

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
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildBucketsSession(context, _stepsCount, _isWebLargerLayout,
                    _bucketsModel, _stepsList),
                //Steps List
                Container(
                  height: 100.hb,
                  padding: EdgeInsets.only(
                      right: kIsWeb ? 22.0 : 10,
                      left: kIsWeb ? 22.0 : 10,
                      top: 14.0),
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _stepsList.length,
                    itemBuilder: (context, index) {
                      final _isFirstItem = index == 0;
                      final _isLastItem = index == _stepsList.length - 1;

                      Map _currentMap = _stepsList[index];
                      BucketActionsEnum _action = _currentMap['action'];

                      if (_action == BucketActionsEnum.error) {
                        return _getListItem(
                            context,
                            _isFirstItem,
                            true,
                            index,
                            AppLocalizations.of(context)!.action_no_solution,
                            [0, 0, 0],
                            [0.0, 0.0, 0.0],
                            isError: true);
                      }

                      final _xBucketCapacity =
                          _bucketsModel?.bucketsCapacityList[0] ?? 0;
                      final _yBucketCapacity =
                          _bucketsModel?.bucketsCapacityList[1] ?? 0;
                      final _zBucketCapacity =
                          _bucketsModel?.bucketsCapacityList[2] ?? 0;

                      BucketNameEnum _bucketName = _currentMap['bucketName'];

                      final _stepText = getStepText(context,
                          currentMap: _currentMap, action: _action);

                      double _bucketValue =
                          double.parse('${_currentMap['bucketValue']}');
                      double _bucketValueTo =
                          double.parse('${_currentMap['bucketValueTo']}');

                      double _xBucketEndProgress = 0.0;
                      double _yBucketEndProgress = 0.0;
                      double _zBucketEndProgress = 0.0;

                      switch (_bucketName) {
                        case BucketNameEnum.xBucket:
                          _xBucketEndProgress = _bucketValue;
                          _yBucketEndProgress = _bucketValueTo;
                          break;
                        case BucketNameEnum.yBucket:
                          _xBucketEndProgress = _bucketValueTo;
                          _yBucketEndProgress = _bucketValue;
                          break;
                        default:
                          break;
                      }

                      if (_action == BucketActionsEnum.transfer) {
                        switch (_bucketName) {
                          case BucketNameEnum.xBucket:
                            _yBucketEndProgress = _bucketValueTo;
                            break;
                          case BucketNameEnum.yBucket:
                            _xBucketEndProgress = _bucketValueTo;
                            break;
                          default:
                            break;
                        }
                      }

                      final _bucketsCapacitiesList = [
                        _xBucketCapacity,
                        _yBucketCapacity,
                        _zBucketCapacity,
                      ];

                      final _bucketsProgressList = [
                        _xBucketEndProgress,
                        _yBucketEndProgress,
                        _zBucketEndProgress,
                      ];

                      return _isLastItem
                          ? Column(
                              children: [
                                _getListItem(
                                    context,
                                    _isFirstItem,
                                    false,
                                    index,
                                    _stepText,
                                    _bucketsCapacitiesList,
                                    _bucketsProgressList),
                                _getListItem(context, false, true, index,
                                    _stepText, _bucketsCapacitiesList, [
                                  0.0,
                                  0.0,
                                  _zBucketCapacity == 0 &&
                                          _zBucketEndProgress == 0
                                      ? 0.0
                                      : 100.0,
                                ])
                              ],
                            )
                          : _getListItem(
                              context,
                              _isFirstItem,
                              _isLastItem,
                              index,
                              _stepText,
                              _bucketsCapacitiesList,
                              _bucketsProgressList);
                    },
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
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

  String getStepText(context, {required Map currentMap, required action}) {
    BucketNameEnum _bucketName =
        currentMap['bucketName'] ?? BucketNameEnum.zBucket;
    BucketNameEnum _toBucketName;

    switch (action) {
      case BucketActionsEnum.fill:
        return AppLocalizations.of(context)!
            .action_fill
            .replaceAll('{bucket}', _bucketName.short);
      case BucketActionsEnum.transfer:
        _toBucketName = currentMap['toBucketName'];
        return AppLocalizations.of(context)!
            .action_transfer
            .replaceAll('{from}', _bucketName.short)
            .replaceAll('{to}', _toBucketName.short);
      case BucketActionsEnum.empty:
        return AppLocalizations.of(context)!
            .action_empty
            .replaceAll('{bucket}', _bucketName.short);
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
                AppLocalizations.of(context)!.home_page_info,
                style: balooRegular.copyWith(
                    fontSize: kIsWeb ? 19 : 16, color: primaryColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          //Buckets Session
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 18.0 : 5.0),
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
                            child: LiquidFill(
                              isSmallerBucket: false,
                              boxBackgroundColor: Colors.white,
                              boxHeight: 120,
                              boxWidth: 120,
                              loadDuration: const Duration(seconds: 2),
                              waveDuration: const Duration(milliseconds: 1500),
                              key: null,
                              startProgress: 0.0,
                              endProgress: _xBucketCapacity * 10 > 100
                                  ? 100.0
                                  : double.parse('${_xBucketCapacity * 10}'),
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
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          height: 50,
                                          child: Container(
                                            decoration: inputButtonLeft,
                                            child: AlignPositioned(
                                              moveByChildWidth:
                                                  kIsWeb ? 0.0 : -0.1,
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
                                                            bucket:
                                                                BucketNameEnum
                                                                    .xBucket,
                                                            value: -1);
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
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
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          height: 50,
                                          child: Container(
                                            decoration: inputButtonRight,
                                            child: AlignPositioned(
                                              moveByChildWidth:
                                                  kIsWeb ? 0.0 : -0.1,
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
                                                          bucket: BucketNameEnum
                                                              .xBucket,
                                                          value: 1);
                                                },
                                              ),
                                            ),
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
                            child: LiquidFill(
                              isSmallerBucket: false,
                              boxBackgroundColor: Colors.white,
                              boxHeight: 120,
                              boxWidth: 120,
                              loadDuration: const Duration(seconds: 2),
                              waveDuration: const Duration(milliseconds: 1500),
                              key: null,
                              startProgress: 0.0,
                              endProgress: _yBucketCapacity * 10 > 100
                                  ? 100.0
                                  : double.parse('${_yBucketCapacity * 10}'),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          height: 50,
                                          child: Container(
                                            decoration: inputButtonLeft,
                                            child: AlignPositioned(
                                              moveByChildWidth:
                                                  kIsWeb ? 0.0 : -0.1,
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
                                                            bucket:
                                                                BucketNameEnum
                                                                    .yBucket,
                                                            value: -1);
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
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
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          height: 50,
                                          child: Container(
                                            decoration: inputButtonRight,
                                            child: AlignPositioned(
                                              moveByChildWidth:
                                                  kIsWeb ? 0.0 : -0.1,
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
                                                          bucket: BucketNameEnum
                                                              .yBucket,
                                                          value: 1);
                                                },
                                              ),
                                            ),
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
                            child: LiquidFill(
                              isSmallerBucket: false,
                              boxBackgroundColor: Colors.white,
                              boxHeight: 120,
                              boxWidth: 120,
                              loadDuration: const Duration(seconds: 2),
                              waveDuration: const Duration(milliseconds: 1500),
                              key: null,
                              startProgress: 0.0,
                              endProgress: _zBucketCapacity * 10 > 100
                                  ? 100.0
                                  : double.parse('${_zBucketCapacity * 10}'),
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
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          height: 50,
                                          child: Container(
                                            decoration: inputButtonLeft,
                                            child: AlignPositioned(
                                              moveByChildWidth:
                                                  kIsWeb ? 0.0 : -0.1,
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
                                                            bucket:
                                                                BucketNameEnum
                                                                    .zBucket,
                                                            value: -1);
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
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
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          height: 50,
                                          child: Container(
                                            decoration: inputButtonRight,
                                            child: AlignPositioned(
                                              moveByChildWidth:
                                                  kIsWeb ? 0.0 : -0.1,
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
                                                          bucket: BucketNameEnum
                                                              .zBucket,
                                                          value: 1);
                                                },
                                              ),
                                            ),
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

  _getListItem(BuildContext context, _isFirstItem, _isLastItem, index,
      _stepText, _bucketsCapacity, _bucketsProgress,
      {bool? isError}) {
    BoxDecoration decoration;

    String _xBucketStringValue;
    String _yBucketStringValue;
    String _zBucketStringValue;

    if (_bucketsCapacity[0] > 10 ||
        _bucketsCapacity[0] > 10 ||
        _bucketsCapacity[0] > 10) {
      _xBucketStringValue = '';
      _yBucketStringValue = '';
      _zBucketStringValue = '';
    } else {
      if (_bucketsProgress[0] >= 100.0) {
        _xBucketStringValue =
            '${_bucketsCapacity[0] > 10 ? '' : _bucketsCapacity[0]}';
      } else {
        _xBucketStringValue =
            '${double.parse('${_bucketsProgress[0]}').toStringAsFixed(0)}${kIsWeb ? '/${_bucketsCapacity[0]}' : ''}';
      }

      if (_bucketsProgress[1] >= 100.0) {
        _yBucketStringValue =
            '${_bucketsCapacity[1] > 10 ? '' : _bucketsCapacity[1]}';
      } else {
        _yBucketStringValue =
            '${double.parse('${_bucketsProgress[1]}').toStringAsFixed(0)}${kIsWeb ? '/${_bucketsCapacity[1]}' : ''}';
      }

      if (_bucketsProgress[0] >= 100.0) {
        _zBucketStringValue =
            '${_bucketsCapacity[2] > 10 ? '' : _bucketsCapacity[2]}';
      } else {
        _zBucketStringValue =
            '${double.parse('${_bucketsProgress[2]}').toStringAsFixed(0)}${kIsWeb ? '/${_bucketsCapacity[2]}' : ''}';
      }
    }

    if (_bucketsCapacity[0] != 0 &&
        _bucketsProgress[0] != 0 &&
        _bucketsProgress[0] == _bucketsCapacity[0]) {
      _bucketsProgress[0] = 100.0;
    }

    if (_bucketsCapacity[1] != 0 &&
        _bucketsProgress[1] != 0 &&
        _bucketsProgress[1] == _bucketsCapacity[1]) {
      _bucketsProgress[1] = 100.0;
    }

    if (_bucketsCapacity[2] != 0 &&
        _bucketsProgress[2] != 0 &&
        _bucketsProgress[2] == _bucketsCapacity[2]) {
      _bucketsProgress[2] = 100.0;
    }

    if (isError ?? false) {
      decoration = fullStepLineDecoration;
    } else if (_isFirstItem) {
      decoration = superiorStepLineDecoration;
    } else if (_isLastItem) {
      decoration = inferiorStepLineDecoration;
    } else {
      decoration = midStepLineDecoration;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: decoration,
      child: isError ?? false
          ? Center(
              child: Text(
                _isLastItem
                    ? AppLocalizations.of(context)!.action_no_solution
                    : _stepText,
                style: balooRegular.copyWith(
                    fontSize: kIsWeb ? 19 : 16, color: primaryColor, height: 1),
                textAlign: TextAlign.center,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Step Number
                Expanded(
                  flex: 1,
                  child: Text(
                    _isLastItem ? '' : '${index + 1}',
                    style: balooRegular.copyWith(
                        fontSize: kIsWeb ? 19 : 16,
                        color: primaryColor,
                        height: 1),
                    textAlign: TextAlign.center,
                  ),
                ),
                //Step Description
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Text(
                      _isLastItem
                          ? AppLocalizations.of(context)!.action_solved
                          : _stepText,
                      style: balooRegular.copyWith(
                          fontSize: kIsWeb ? 19 : 16,
                          color: primaryColor,
                          height: 1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                //Step Buckets
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: SizedBox(
                      width: 160,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5, left: 5),
                              child: SizedBox(
                                child: LiquidFill(
                                  isSmallerBucket: true,
                                  bucketStringValue: _xBucketStringValue,
                                  boxBackgroundColor: cultured,
                                  boxHeight: 40,
                                  boxWidth: 40,
                                  loadDuration: const Duration(seconds: 2),
                                  waveDuration:
                                      const Duration(milliseconds: 1500),
                                  key: null,
                                  startProgress: 0.0,
                                  endProgress: _bucketsProgress[0],
                                  bucketName: BucketNameEnum.xBucket,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5, left: 5),
                              child: SizedBox(
                                child: LiquidFill(
                                  isSmallerBucket: true,
                                  bucketStringValue: _yBucketStringValue,
                                  boxBackgroundColor: cultured,
                                  boxHeight: 40,
                                  boxWidth: 40,
                                  loadDuration: const Duration(seconds: 2),
                                  waveDuration:
                                      const Duration(milliseconds: 1500),
                                  key: null,
                                  startProgress: 0.0,
                                  endProgress: _bucketsProgress[1],
                                  bucketName: BucketNameEnum.yBucket,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5, left: 5),
                              child: SizedBox(
                                // height: 25.hb,
                                child: LiquidFill(
                                  isSmallerBucket: true,
                                  bucketStringValue: _zBucketStringValue,
                                  boxBackgroundColor: cultured,
                                  boxHeight: 40,
                                  boxWidth: 40,
                                  loadDuration: const Duration(seconds: 2),
                                  waveDuration:
                                      const Duration(milliseconds: 1500),
                                  key: null,
                                  startProgress: 0.0,
                                  endProgress: _bucketsProgress[2],
                                  bucketName: BucketNameEnum.zBucket,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}