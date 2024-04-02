// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
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
}
