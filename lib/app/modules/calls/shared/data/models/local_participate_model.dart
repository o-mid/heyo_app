import 'package:get/get.dart';
import 'package:heyo/app/modules/calls/shared/data/models/connected_participate_model.dart';

class LocalParticipateModel extends ConnectedParticipateModel {
  LocalParticipateModel({
    required super.name,
    required super.iconUrl,
    required super.coreId,
    required super.audioMode,
    required super.videoMode,
    required this.frondCamera,
    required this.callDurationInSecond,
  });

  RxBool frondCamera;
  RxInt callDurationInSecond;
}
