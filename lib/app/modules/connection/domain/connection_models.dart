sealed class ConnectionRequestReceived{}

class LibP2PRequestReceived extends ConnectionRequestReceived {
  final Map<String, dynamic> mapData;
  final String remoteCoreId;
  final String remotePeerId;

  LibP2PRequestReceived({
    required this.remoteCoreId,
    required this.remotePeerId,
    required this.mapData,
  });
}

class ChatMultipleConnectionDataReceived extends LibP2PRequestReceived {
  ChatMultipleConnectionDataReceived(
      {required super.remoteCoreId,
        required super.remotePeerId,
        required super.mapData,});
}

class CallConnectionDataReceived extends LibP2PRequestReceived {
  CallConnectionDataReceived(
      {required super.remoteCoreId,
        required super.remotePeerId,
        required super.mapData,});
}

class RemotePeerData {
  String remoteCoreId;
  String? remotePeerId;

  RemotePeerData({required this.remoteCoreId, required this.remotePeerId});
}
