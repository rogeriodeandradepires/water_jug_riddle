import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:water_jug_riddle/helper/enums.dart';
import 'package:water_jug_riddle/state_mgmt/controllers/buckets_notifier.dart';
import 'package:water_jug_riddle/state_mgmt/providers/buckets_providers.dart';
import 'package:water_jug_riddle/ui/shared/colors.dart';
import 'package:water_jug_riddle/ui/shared/text_styles.dart';
import 'package:water_jug_riddle/ui/widgets/liquidify/wave_painter.dart';
import 'package:water_jug_riddle/ui/widgets/liquidify/wave_painter_smaller.dart';

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
    required this.isSmallerBucket,
    required this.bucketName,
    this.bucketStringValue,
    required this.boxBackgroundColor,
  }) : super(key: key);

  final BucketNameEnum bucketName;

  late final AnimationController? waveController, loadController;
  final Duration? waveDuration, loadDuration;

  late final Animation loadValue;
  double startProgress, endProgress;
  String? bucketStringValue;

  final double boxHeight, boxWidth;
  final bool isSmallerBucket;

  final Color boxBackgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    waveController = useAnimationController(duration: waveDuration);

    loadController = useAnimationController(duration: loadDuration);

    loadValue = Tween<double>(begin: startProgress, end: endProgress)
        .animate(loadController!);

    waveController!.repeat();

    loadController!.forward();

    bool _isEmpty = endProgress==0.0;

    return Stack(
      children: [
        //Wave
        Center(
          child: SizedBox(
            height: boxHeight,
            width: boxWidth-15,
            child: _isEmpty
                ? Container()
                : AnimatedBuilder(
                    animation: waveController!,
                    builder: (BuildContext context, Widget? child) {
                      return _isEmpty
                          ? Container()
                          : CustomPaint(
                              painter: isSmallerBucket ? WavePainterSmaller(
                                waveAnimation: waveController,
                                percentValue: loadValue.value,
                                boxHeight: boxHeight,
                              ) : WavePainter(
                                waveAnimation: waveController,
                                percentValue: loadValue.value,
                                boxHeight: boxHeight,
                              ),
                            );
                    },
                  ),
          ),
        ),
        //Shader
        Center(
          child: SizedBox(
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
        ),
        //Bucket
        Center(
          child: SizedBox(
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
          ),
        ),
        isSmallerBucket ? Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Text(
            '$bucketStringValue',
            style: balooRegular.copyWith(
                fontSize: 16,
                color: primaryColor,
                height: 1),
            textAlign: TextAlign.center,
          ),
        ) : Container()
      ],
    );
  }
}