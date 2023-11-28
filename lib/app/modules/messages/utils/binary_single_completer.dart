import 'dart:async';

class SingleCompleter<T> {
  var completer = Completer<T>();

  bool get isCompleted {
    return completer.isCompleted;
  }

  Future<T> get future {
    return completer.future;
  }

  void completeError(Object error) {
    if (!completer.isCompleted) {
      completer.completeError(error);
    }
  }

  void complete(T result) {
    if (!completer.isCompleted) {
      completer.complete(result);
    }
  }
}
