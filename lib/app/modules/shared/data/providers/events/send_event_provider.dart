abstract class SendEventProvider {
  Future<void> sendInfoEvent(String name, Map<String,dynamic> data);
  Future<void> sendErrorEvent(String name, Map<String,dynamic> data);
}