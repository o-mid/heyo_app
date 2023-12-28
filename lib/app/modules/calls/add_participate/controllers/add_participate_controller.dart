//import 'dart:async';

//import 'package:flutter/material.dart';
//import 'package:get/get.dart';
//import 'package:heyo/app/modules/calls/add_participate/controllers/filter_model.dart';
//import 'package:heyo/app/modules/calls/usecase/get_contact_user_use_case.dart';
//import 'package:heyo/app/modules/calls/add_participate/usecase/search_contact_user_use_case.dart';
//import 'package:heyo/app/modules/calls/domain/call_repository.dart';
//import 'package:heyo/app/modules/calls/domain/models.dart';
//import 'package:heyo/app/modules/calls/shared/data/models/all_participant_model/all_participant_model.dart';

//class AddParticipateController extends GetxController {
//  AddParticipateController({
//    required this.searchContactUserUseCase,
//    required this.getContactUserUseCase,
//    required this.callRepository,
//  });

//  final SearchContactUserUseCase searchContactUserUseCase;
//  final GetContactUserUseCase getContactUserUseCase;
//  final CallRepository callRepository;

//  RxList<AllParticipantModel> selectedUser = <AllParticipantModel>[].obs;
//  RxList<AllParticipantModel> participateItems = <AllParticipantModel>[].obs;
//  RxList<AllParticipantModel> searchItems = <AllParticipantModel>[].obs;
//  late TextEditingController inputController;
//  //final inputFocusNode = FocusNode();
//  final inputText = ''.obs;
//  final profileLink = 'https://heyo.core/m6ljkB4KJ';

//  @override
//  Future<void> onInit() async {
//    inputController = TextEditingController();
//    await getContact();
//    super.onInit();
//  }

//  @override
//  void onClose() {
//    inputController.dispose();
//    //_contactsStreamSubscription.cancel();
//  }

//// Mock filters for the users
//  RxList<FilterModel> filters = [
//    FilterModel(
//      title: 'Verified',
//      isActive: false.obs,
//    ),
//    FilterModel(
//      title: 'Online',
//      isActive: false.obs,
//    ),
//  ].obs;

//  Future<void> getContact() async {
//    final contacts = await getContactUserUseCase.execute();
//    //* Get the list of users who are in call
//    var callStreams = <CallStream>[];
//    try {
//      callStreams = await callRepository.getCallStreams();
//      //callRepository.onCallStreamReceived = (callStateView) {
//      //  debugPrint('onAddCallStream : $callStateView');
//      //  callStreams.add(callStateView);
//      //};
//    } catch (e) {
//      debugPrint(e.toString());
//      callStreams = [];
//    }

//    //* Remove the users who are already in call
//    for (final callStream in callStreams) {
//      contacts.removeWhere(
//        (contact) => contact.coreId == callStream.coreId,
//      );
//    }

//    participateItems.value =
//        contacts.map((e) => e.mapToAllParticipantModel()).toList();
//    searchItems.value = participateItems;
//  }

//  Future<void> searchUsers(String query) async {
//    if (query == '') {
//      searchItems.value = participateItems;
//    } else {
//      query = query.toLowerCase();

//      searchItems.value = participateItems
//          .where((item) => item.name.toLowerCase().contains(query))
//          .toList();
//    }
//    //refresh();
//  }

//  RxBool isTextInputFocused = false.obs;

//  void selectUser(AllParticipantModel user) {
//    final existingIndex =
//        selectedUser.indexWhere((u) => u.coreId == user.coreId);

//    if (existingIndex != -1) {
//      selectedUser.removeAt(existingIndex);
//    } else {
//      //It will add user to the top
//      selectedUser.insert(0, user);
//    }
//  }

//  bool isSelected(AllParticipantModel user) {
//    return selectedUser.any((u) => u.coreId == user.coreId);
//  }

//  void clearRxList() {
//    selectedUser.clear();
//    participateItems.clear();
//    searchItems.clear();
//  }

//// region ali
//  // endregion
//  Future<void> addUsersToCall() async {
//    if (selectedUser.isEmpty) {
//      return;
//    }

//    debugPrint('Add selected users to call');

//    //* Pop to call page
//    Get.back();

//    //* Add user to call repo
//    for (final user in selectedUser) {
//      await callRepository.addMember(user.coreId);
//    }

//    //* Clears list
//    clearRxList();
//  }
//}
