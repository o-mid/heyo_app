// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/calls/shared/data/models/all_participant_model/all_participant_model.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/modules/features/contact/data/models/contact_dto/contact_dto.dart';
part 'contact_model.freezed.dart';
part 'contact_model.g.dart';

@freezed
abstract class ContactModel with _$ContactModel {
  @JsonSerializable(explicitToJson: true)
  const factory ContactModel({
    required String coreId,
    required String name,
  }) = _ContactModel;

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);
}

extension ContactModelMapper on ContactModel {
  // Mapper method to convert ContactModel to ContactDTO
  ContactDTO toContactDTO() {
    return ContactDTO(
      coreId: coreId,
      name: name,
    );
  }

  // Mapper method to convert ContactModel to UserModel
  UserModel toUserModel() {
    return UserModel(
      coreId: coreId,
      name: name,
      walletAddress: coreId,
    );
  }

  // Mapper method to convert ContactModel to AllParticipantModel
  AllParticipantModel toAllParticipantModel() {
    return AllParticipantModel(
      name: name,
      coreId: coreId,
    );
  }
}
