// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';
part 'contact_dto.freezed.dart';
part 'contact_dto.g.dart';

@freezed
abstract class ContactDTO with _$ContactDTO {
  @JsonSerializable(explicitToJson: true)
  const factory ContactDTO({
    required String coreId,
    required String name,
  }) = _ContactDTO;

  factory ContactDTO.fromJson(Map<String, dynamic> json) =>
      _$ContactDTOFromJson(json);
}

extension ContactDTOMapper on ContactDTO {
  // Mapper method to convert ContactDTO to ContactModel
  ContactModel toContactModel() {
    return ContactModel(
      coreId: coreId,
      name: name,
    );
  }
}
