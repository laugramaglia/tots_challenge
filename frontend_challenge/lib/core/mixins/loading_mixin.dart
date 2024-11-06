import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_challenge/core/extensions/context.dart';

mixin LoadingMixin<T extends StatefulWidget> on State<T> {
  OverlayEntry? _overlayEntry;

  Future<void> insetOverlay(Future Function() action) async {
    if (_overlayEntry != null) {
      return;
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => Container(
        color: context.colorScheme.primary.withOpacity(.1),
        child: Center(
          child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withOpacity(.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const CircularProgressIndicator.adaptive()),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    try {
      await action();
    } catch (e) {
      log(e.toString());
    } finally {
      removeOverlay();
    }
  }

  void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    removeOverlay();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    removeOverlay();
    super.didChangeDependencies();
  }
}
