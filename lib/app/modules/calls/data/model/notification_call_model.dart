import 'dart:convert';

/// content : {"type":"request","data":{"isAudioCall":true,"members":[]},"command":"call_connection","call_id":"1704602412780"}
/// id : "ab527764b825b99461f6c60a030cbc64ef162f0e22ea"

class NotificationCallModel {
  NotificationCallModel({
    NotificationCallContentModel? content,
    String? id,
  }) {
    _content = content;
    _id = id;
  }

  NotificationCallModel.fromJson(dynamic json) {
    final tempContent = jsonDecode(json['content'].toString());
    _content = tempContent['content'] != null
        ? NotificationCallContentModel.fromJson(tempContent['content'])
        : null;
    _id = tempContent['id'] as String;
  }

  NotificationCallContentModel? _content;
  String? _id;

  NotificationCallModel copyWith({
    NotificationCallContentModel? content,
    String? id,
  }) =>
      NotificationCallModel(
        content: content ?? _content,
        id: id ?? _id,
      );

  NotificationCallContentModel? get content => _content;

  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_content != null) {
      map['content'] = _content?.toJson();
    }
    map['id'] = _id;
    return map;
  }
}

/// type : "request"
/// data : {"isAudioCall":true,"members":[]}
/// command : "call_connection"
/// call_id : "1704602412780"

class NotificationCallContentModel {
  NotificationCallContentModel({
    String? type,
    Data? data,
    String? command,
    String? callId,
  }) {
    _type = type;
    _data = data;
    _command = command;
    _callId = callId;
  }

  NotificationCallContentModel.fromJson(dynamic json) {
    _type = json['type'].toString();
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _command = json['command'].toString();
    _callId = json['call_id'].toString();
  }

  String? _type;
  Data? _data;
  String? _command;
  String? _callId;

  NotificationCallContentModel copyWith({
    String? type,
    Data? data,
    String? command,
    String? callId,
  }) =>
      NotificationCallContentModel(
        type: type ?? _type,
        data: data ?? _data,
        command: command ?? _command,
        callId: callId ?? _callId,
      );

  String? get type => _type;

  Data? get data => _data;

  String? get command => _command;

  String? get callId => _callId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['command'] = _command;
    map['call_id'] = _callId;
    return map;
  }
}

/// isAudioCall : true
/// members : []

class Data {
  Data({
    bool? isAudioCall,
    List<String>? members,
  }) {
    _isAudioCall = isAudioCall;
    _members = members;
  }

  Data.fromJson(dynamic json) {
    _isAudioCall =
        bool.tryParse(json['isAudioCall'].toString(), caseSensitive: false);
    if (json['members'] != null) {
      _members = [];
      json['members'].forEach((v) {
        _members?.add(v.toString());
      });
    }
  }

  bool? _isAudioCall;
  List<String>? _members;

  Data copyWith({
    bool? isAudioCall,
    List<String>? members,
  }) =>
      Data(
        isAudioCall: isAudioCall ?? _isAudioCall,
        members: members ?? _members,
      );

  bool? get isAudioCall => _isAudioCall;

  List<String>? get members => _members;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isAudioCall'] = _isAudioCall;
    if (_members != null) {
      map['members'] = _members?.map((v) => v).toList();
    }
    return map;
  }
}
