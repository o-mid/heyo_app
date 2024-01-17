import 'package:uuid/uuid.dart';

class ChatIdGenerator {
  static String generate() {
    var uuid = const Uuid();
    return uuid.v4();
  }
}
