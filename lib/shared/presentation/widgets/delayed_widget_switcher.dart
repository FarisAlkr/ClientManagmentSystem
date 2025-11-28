import 'package:flutter/material.dart';

/// A widget that shows a loading screen for a minimum duration before showing content
class DelayedWidgetSwitcher extends StatefulWidget {
  final Widget loadingWidget;
  final Widget child;
  final bool isLoading;
  final int minimumLoadingMilliseconds;

  const DelayedWidgetSwitcher({
    super.key,
    required this.loadingWidget,
    required this.child,
    required this.isLoading,
    this.minimumLoadingMilliseconds = 6000,
  });

  @override
  State<DelayedWidgetSwitcher> createState() => _DelayedWidgetSwitcherState();
}

class _DelayedWidgetSwitcherState extends State<DelayedWidgetSwitcher> {
  DateTime? _loadingStartTime;
  bool _showLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.isLoading) {
      _loadingStartTime = DateTime.now();
    }
  }

  @override
  void didUpdateWidget(DelayedWidgetSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If loading just started, record the time
    if (widget.isLoading && !oldWidget.isLoading) {
      _loadingStartTime = DateTime.now();
      setState(() {
        _showLoading = true;
      });
    }

    // If loading finished, check if minimum time has elapsed
    if (!widget.isLoading && oldWidget.isLoading) {
      _checkAndTransition();
    }
  }

  void _checkAndTransition() {
    if (_loadingStartTime == null) {
      setState(() {
        _showLoading = false;
      });
      return;
    }

    final elapsed = DateTime.now().difference(_loadingStartTime!).inMilliseconds;
    final remaining = widget.minimumLoadingMilliseconds - elapsed;

    if (remaining > 0) {
      // Wait for remaining time before transitioning
      Future.delayed(Duration(milliseconds: remaining), () {
        if (mounted) {
          setState(() {
            _showLoading = false;
          });
        }
      });
    } else {
      // Minimum time already elapsed, transition immediately
      setState(() {
        _showLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading || _showLoading) {
      return widget.loadingWidget;
    }
    return widget.child;
  }
}
