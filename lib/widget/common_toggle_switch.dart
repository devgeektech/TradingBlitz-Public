import 'package:flutter/material.dart';
import 'package:trading/utils/theme.dart';

class CommonToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CommonToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchTheme(
      data: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeProvider.buttonColor;
          }
          return Colors.grey.shade400;
        }),
        thumbColor: WidgetStateProperty.all(Colors.white),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        thumbIcon: WidgetStateProperty.all(null),
      ),
      child: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
