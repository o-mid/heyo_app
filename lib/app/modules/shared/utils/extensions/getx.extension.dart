import 'dart:async';

import 'package:get/get.dart';

extension ResultListener<X> on Rx<X> {
  Future<X> waitForResult({required bool Function(X value) condition}) async {
    final jobCompleter = Completer<X>();
    final listener = listen((p0) {
      if (condition.call(p0)) jobCompleter.complete(p0);
    });
    final result = await jobCompleter.future;
    await listener.cancel();
    return result;
  }
}
