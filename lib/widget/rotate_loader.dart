import 'package:flutter/material.dart';
import '../utils/theme.dart';

class RotatingRefreshIcon extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isLoading;

  const RotatingRefreshIcon({
    super.key,
    this.onTap,
    this.isLoading = false,
  });

  @override
  State<RotatingRefreshIcon> createState() => _RotatingRefreshIconState();
}

class _RotatingRefreshIconState extends State<RotatingRefreshIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(RotatingRefreshIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading) {
      _controller.repeat(); // Continuous rotation
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isLoading) {
      _controller.repeat();
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: ThemeProvider.lightThemeBgColor1,
          borderRadius: BorderRadius.circular(100),
        ),
        child: RotationTransition(
          turns: _controller,
          child: Icon(Icons.refresh, color: ThemeProvider.buttonColor1,size: 15),
        ),
      ),
    );
  }
}