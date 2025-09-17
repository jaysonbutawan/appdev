import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AppStateHandler extends StatefulWidget {
  final bool isLoading;
  final Widget child;

  const AppStateHandler({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  State<AppStateHandler> createState() => _AppStateHandlerState();
}

class _AppStateHandlerState extends State<AppStateHandler> {
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isOffline = result == ConnectivityResult.none;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🔴 Show Circular Loader when offline
    if (_isOffline) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 🔵 Show Circular Loader when app is busy
    if (widget.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 🟢 Normal app UI
    return widget.child;
  }
}
