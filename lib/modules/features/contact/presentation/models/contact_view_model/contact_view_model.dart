import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';

part 'contact_view_model.freezed.dart';

@freezed
abstract class ContactViewModel implements _$ContactViewModel {
  const factory ContactViewModel({
    required String coreId,
    required String name,
  }) = _ContactViewModel;
}

extension ContactViewModelMapper on UserModel {
  ContactViewModel mapToContactViewModel() {
    return ContactViewModel(
      name: name,
      coreId: coreId,
    );
  }
}
