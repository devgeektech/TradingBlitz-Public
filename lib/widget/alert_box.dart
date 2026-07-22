

import 'package:flutter/material.dart';

void showCommonDialog({
  required BuildContext context,
  String? title,
  required String message,
  String confirmText = 'OK',
  String cancelText = 'Cancel',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool showCancel = true,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: title != null ? Text(title) : null,
      content: Text(message),
      actions: [
        if (showCancel)
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (onCancel != null) onCancel();
            },
            child: Text(cancelText),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            if (onConfirm != null) onConfirm();
          },
          child: Text(confirmText),
        ),
      ],
    ),
  );
}
