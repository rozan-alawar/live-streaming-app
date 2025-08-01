import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;
  final double height;
  final TextDecoration? decoration;
  final String? fontFamily;

  const CustomText(
    this.text, {
    super.key,
    this.fontSize = 16,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.fontFamily,
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.visible,
    this.maxLines,
    this.height = 1.5,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        fontFamily: fontFamily,
        color: color ?? AppColors.textPrimary,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        decoration: decoration,
      ),
    );
  }
}

class CustomHeading extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const CustomHeading(
    this.text, {
    super.key,
    this.fontSize = 24,
    this.color,
    this.fontWeight = FontWeight.w700,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      fontSize: fontSize,
      color: color ?? AppColors.textPrimary,
      fontWeight: fontWeight,
      textAlign: textAlign,
    );
  }
}

class CustomBodyText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final int? maxLines;

  const CustomBodyText(
    this.text, {
    super.key,
    this.fontSize = 16,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      fontSize: fontSize,
      color: color ?? AppColors.textPrimary,
      fontWeight: fontWeight,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class CustomCaptionText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const CustomCaptionText(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      fontSize: fontSize,
      color: color ?? AppColors.textSecondary,
      fontWeight: fontWeight,
      textAlign: textAlign,
    );
  }
}
