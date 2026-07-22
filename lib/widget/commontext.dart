import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonTextWidget extends StatelessWidget {
  final String heading;
  final String fontFamily;
  final double fontSize;
  final double lineHeight;
  final Color color;
  final Color decorationColor;
  final double letterSpacing;
  final TextAlign textAlign;
  final TextOverflow textOverflow;
  final FontWeight? fontWeight;
  final TextDecoration textDecoration;
  final FontStyle fontStyle;
  final bool useThemeColors;
  final int? maxLines;
  final bool addUnderline;
  final TextDirection? textDirection;


  const CommonTextWidget({
    super.key,
    this.fontStyle = FontStyle.normal,
    required this.heading,
    this.textDecoration = TextDecoration.none,
    this.fontFamily = 'regular',
    required this.fontSize,
    required this.color,
    this.decorationColor = CupertinoColors.black,
    this.letterSpacing = 0,
    this.lineHeight = 1,
    this.fontWeight,
    this.textAlign = TextAlign.start,
    this.textOverflow = TextOverflow.visible,
    this.useThemeColors = true,
    this.maxLines,
    this.addUnderline = false,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return
      useThemeColors
      ?Text(
        maxLines: maxLines ?? 1,
        heading,
        textAlign: textAlign,
        textDirection: textDirection ?? TextDirection.ltr,
        overflow: textOverflow,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontStyle: fontStyle,
          decoration: addUnderline ? TextDecoration.underline : textDecoration,
          fontFamily: fontFamily,
          color: addUnderline ? Colors.transparent : color,
          fontWeight: fontWeight ?? FontWeight.w600,
          height: lineHeight,
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          decorationThickness: 2,
          shadows: addUnderline ? [
            Shadow(
              color: color,
              offset: Offset(0, -5),
            )
          ] : null,

        ),
      )
      :Text(
      heading,
      textAlign: textAlign,
      overflow: textOverflow,
      style: TextStyle(
          fontStyle: fontStyle,
          decoration: textDecoration,
          fontFamily: fontFamily,
          fontWeight:fontWeight??FontWeight.w600,
          height: lineHeight,
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          color: color,
          decorationThickness: 5,
          decorationColor: decorationColor,
      ),
    );
  }
}
