import 'dart:convert';

import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';

/// content : {"type":"request","data":{"isAudioCall":true,"members":[]},"command":"call_connection","call_id":"1704602412780"}
/// id : "ab527764b825b99461f6c60a030cbc64ef162f0e22ea"

class NotificationCallModel {
  NotificationCallModel({
    NotificationCallContentModel? content,
    String? messageFrom,
    String? notificationType,
  }) {
    _content = content;
    _messageFrom = messageFrom;
    _notificationType = notificationType;
  }

  NotificationCallModel.fromJson(dynamic json) {
    final tempContent = json['content'];
    _content = tempContent != null
        ? NotificationCallContentModel.fromJson(tempContent.toString())
        : null;
    _messageFrom = json['messageFrom'].toString();
    _notificationType = json['notificationType'].toString();
  }

  NotificationCallContentModel? _content;
  String? _messageFrom;
  String? _notificationType;

  String? get messageFrom => _messageFrom;

  String? get notificationType => _notificationType;

  NotificationCallModel copyWith({
    NotificationCallContentModel? content,
    String? id,
    String? messageFrom,
    String? notificationType,
  }) =>
      NotificationCallModel(
        content: content ?? _content,
        messageFrom: messageFrom ?? _messageFrom,
        notificationType: notificationType ?? _notificationType,
      );

  NotificationCallContentModel? get content => _content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_content != null) {
      map['content'] = _content?.toJson();
    }
    if (_messageFrom != null) {
      map['messageFrom'] = _messageFrom?.toString();
    }
    if (_notificationType != null) {
      map['notificationType'] = _notificationType;
    }
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
    DateTime? dateTime,
  }) {
    _type = type;
    _data = data;
    _command = command;
    _callId = callId;
    _dateTime = dateTime;
  }

  NotificationCallContentModel.fromJson(String json) {
    Map<String, dynamic>? decoded;
    try {
      // Attempt to directly decode the JSON
      decoded = jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      decoded = jsonDecode(json.toValidJson()) as Map<String, dynamic>;
    }

    _type = decoded!['type'].toString();
    _data = decoded['data'] != null ? Data.fromJson(decoded['data']) : null;
    _command = decoded['command'].toString();
    _callId = decoded['call_id'].toString();
    if (decoded['dateTime'] != null) {
      _dateTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(decoded['dateTime'].toString()));
    }
  }

  String? _type;
  Data? _data;
  String? _command;
  String? _callId;
  DateTime? _dateTime;

  NotificationCallContentModel copyWith({
    String? type,
    Data? data,
    String? command,
    String? callId,
    DateTime? dateTime,
  }) =>
      NotificationCallContentModel(
        type: type ?? _type,
        data: data ?? _data,
        command: command ?? _command,
        callId: callId ?? _callId,
        dateTime: dateTime ?? _dateTime,
      );

  String? get type => _type;

  Data? get data => _data;

  String? get command => _command;

  String? get callId => _callId;

  DateTime? get dateTime => _dateTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['command'] = _command;
    map['call_id'] = _callId;
    if (dateTime != null) {
      map['dateTime'] = _dateTime?.millisecondsSinceEpoch.toString();
    }
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
