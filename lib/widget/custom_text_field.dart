import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? textInputStyle;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final VoidCallback? ontap;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  // Add inputFormatters parameter
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsets? scrollPadding;

  const CustomTextField({
    super.key,
    this.ontap,
    this.hintText,
    this.hintStyle = const TextStyle(
      fontSize: 14,
      color: Color(0xFF697D95),
      fontFamily: 'regular',
    ),
    this.controller,
    this.obscureText = false,
    this.onChanged,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.focusNode,
    this.readOnly = false,
    this.textInputStyle,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.borderColor,
    this.borderRadius,
    this.scrollPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollPadding: scrollPadding ?? EdgeInsets.zero,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: ThemeProvider.primary,
      onFieldSubmitted: onFieldSubmitted,
      textAlignVertical: TextAlignVertical.center,
      onTap: ontap,
      focusNode: focusNode,
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      style: textInputStyle,
      inputFormatters: inputFormatters ?? [], // Apply inputFormatters if provided
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ?Colors.white54
            :ThemeProvider.whiteColor,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          borderSide: const BorderSide(
            color: Colors.green,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey.withValues(alpha: 0.4),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          borderSide: BorderSide(
            color: ThemeProvider.primary,
            width: 1.0,
          ),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.all(15.0),
        hintText: hintText,
        hintStyle: TextStyle(
        fontFamily: 'regular',
        color: Theme.of(context).brightness == Brightness.dark
            ?Colors.white
        :ThemeProvider.greyColor,
        fontSize: Utils.responsiveFontSize(context, 16.sp),
      ),
      ),
    );
  }
}
