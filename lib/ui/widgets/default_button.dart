import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_jug_riddle/helper/screen_size.dart';
import 'package:water_jug_riddle/ui/shared/colors.dart';
import 'package:water_jug_riddle/ui/shared/shape_styles.dart';
import 'package:water_jug_riddle/ui/shared/text_styles.dart';

class DefaultButton extends ConsumerWidget {
  final String label;
  final Color? textColor;
  final TextStyle? textStyle;
  final ShapeDecoration? decoration;
  final double? height;
  final double? width;
  final AutoDisposeStateNotifierProvider? providerToWatch;
  final String? fieldToWatch;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTapCallback;

  const DefaultButton(
      {required ValueKey key,
      required this.label,
      this.textColor,
      this.decoration,
      this.height,
      this.width,
      this.padding,
      this.textStyle,
      this.onTapCallback,
      this.providerToWatch,
      this.fieldToWatch,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScreenSize.recalculate(context);

    bool _isCalculating = providerToWatch != null
        ? ref.watch(providerToWatch!.select((state) {
            return state.model?.getFieldByName(fieldToWatch) ?? false;
          }))
        : false;

    return Container(
      margin: margin,
      height: height ?? 41,
      width: width,
      decoration: decoration ?? (_isCalculating ? buttonFaded : buttonDefault),
      child: Stack(
        children: [
          Padding(
            padding:
                padding ?? const EdgeInsets.only(left: 30, right: 25, top: 1),
            child: Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Center(
                    child: Text(label,
                        key: ValueKey('${(key as ValueKey).value}_label'),
                        style: textStyle ??
                            balooRegular.copyWith(
                                fontSize: kIsWeb ? 22 : 19,
                                color: textColor ?? Colors.white)),
                  ),
                  _isCalculating
                      ? const Center(
                          child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.2, color: primaryColor),
                        ))
                      : Container()
                ],
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            type: MaterialType.transparency,
            child: InkWell(
              key: ValueKey('${(key as ValueKey).value}_onTap'),
              borderRadius: BorderRadius.circular(50.0),
              splashColor:
                  (!_isCalculating ? splashColorDefault : Colors.transparent)
                      .withOpacity(0.02),
              highlightColor:
                  (!_isCalculating ? splashColorDefault : Colors.transparent)
                      .withOpacity(0.02),
              onTap: () {
                HapticFeedback.heavyImpact();
                if (onTapCallback != null) {
                  onTapCallback!();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}