import 'dart:async';

import 'package:flutter/animation.dart';

class DebounceTime {
  final int milliseconds;
  late Timer _timer;

  DebounceTime({required this.milliseconds}) {
    _timer = Timer(Duration(milliseconds: milliseconds), () => {});
  }

  run(VoidCallback callback) {
    _timer.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), callback);
  }

}