import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:water_jug_riddle/helper/enums.dart';
import 'package:water_jug_riddle/state_mgmt/providers/buckets_providers.dart';
import 'package:water_jug_riddle/ui/shared/colors.dart';
import 'package:water_jug_riddle/ui/widgets/liquidify/wave_painter.dart';

class LiquidFill extends HookConsumerWidget {
  // with TickerProviderStateMixin {

  LiquidFill({
    required ValueKey? key,
    required this.startProgress,
    required this.endProgress,
    required this.loadDuration,
    required this.waveDuration,
    required this.boxHeight,
    required this.boxWidth,
    required this.bucketName,
    required this.boxBackgroundColor,
  }) : super(key: key);

  final BucketNameEnum bucketName;

  late final AnimationController? waveController, loadController;
  final Duration? waveDuration, loadDuration;

  late final Animation loadValue;
  final double startProgress, endProgress;

  final double boxHeight, boxWidth;

  final Color boxBackgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    waveController = useAnimationController(duration: waveDuration);

    loadController = useAnimationController(duration: loadDuration);

    loadValue = Tween<double>(begin: startProgress, end: endProgress)
        .animate(loadController!);

    waveController!.repeat();

    loadController!.forward();

    loadController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (startProgress == 0.0 && endProgress == 0.0) {
          debugPrint("listener 1");
        } else if (endProgress == 0.0) {
          debugPrint("listener 2");
          ref.read(bucketsNotifierProvider.notifier).changeBucketState(
              bucket: bucketName, newState: BucketStatesEnum.empty);
        } else if (endProgress == 100.0) {
          debugPrint("listener 3");
          ref.read(bucketsNotifierProvider.notifier).changeBucketState(
              bucket: bucketName, newState: BucketStatesEnum.full);
        } else {
          debugPrint("listener 4");
          ref.read(bucketsNotifierProvider.notifier).changeBucketState(
              bucket: bucketName, newState: BucketStatesEnum.partiallyFull);
        }
      }
    });

    bool _isEmpty = ref.watch(bucketsNotifierProvider.notifier.select((state) {
      final _bucketsStateMap = state.model.bucketsCurrentStateMap;

      return ref.read(bucketsNotifierProvider.notifier).checkBucketEmptiness(
          bucketName: bucketName, bucketsStateMap: _bucketsStateMap);
    }));

    // debugPrint("_isEmpty: $_isEmpty");

    return Stack(
      children: [
        //Wave
        SizedBox(
          height: boxHeight,
          width: boxWidth,
          child: _isEmpty
              ? Container()
              : AnimatedBuilder(
                  animation: waveController!,
                  builder: (BuildContext context, Widget? child) {
                    return _isEmpty
                        ? Container()
                        : CustomPaint(
                            painter: WavePainter(
                              waveAnimation: waveController,
                              percentValue: loadValue.value,
                              boxHeight: boxHeight,
                            ),
                          );
                  },
                ),
        ),
        //Shader
        SizedBox(
          height: boxHeight,
          width: boxWidth,
          child: ShaderMask(
            blendMode: BlendMode.srcOut,
            shaderCallback: (bounds) =>
                LinearGradient(colors: [boxBackgroundColor], stops: const [0.0])
                    .createShader(bounds),
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: SvgPicture.asset(
                  'images/bucket_content.svg',
                  height: 120,
                ),
              ),
            ),
          ),
        ),
        //Bucket
        SizedBox(
          height: boxHeight,
          width: boxWidth,
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: SvgPicture.asset(
                'images/bucket_frame_thicker.svg',
                height: 120,
                color: blackOlive,
              ),
            ),
          ),
        )
      ],
    );
  }
}