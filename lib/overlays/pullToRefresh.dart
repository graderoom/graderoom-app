import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PullToRefresh extends StatefulWidget {
  const PullToRefresh({
    Key? key,
    required this.child,
    required this.onRefresh,
  });

  final Widget child;

  final Future<void> Function() onRefresh;

  @override
  _PullToRefreshState createState() => _PullToRefreshState();
}

class _PullToRefreshState extends State<PullToRefresh> {
  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    Overlay.of(context)!.insert(this._overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: widget.child,
      onRefresh: widget.onRefresh,
    );
  }
}
