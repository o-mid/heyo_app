import 'dart:async';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';
import 'package:heyo/app/modules/shared/utils/extensions/barcode.extension.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';

import '../../../routes/app_pages.dart';
import '../../messages/utils/chat_Id_generator.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../../shared/data/repository/contact_repository.dart';
import '../../shared/data/repository/crypto_account/account_repository.dart';
import '../../shared/utils/constants/colors.dart';
import '../../shared/utils/constants/textStyles.dart';

class NewGroupChatController extends GetxController {
  NewGroupChatController({required this.contactRepository, required this.accountInfoRepo});

  final ContactRepository contactRepository;
  final AccountRepository accountInfoRepo;
  final inputFocusNode = FocusNode();
  final confirmationScreenInputFocusNode = FocusNode();
  final showConfirmationScreen = false.obs;
  final inputText = ''.obs;
  final confirmationInputText = ''.obs;
  late StreamSubscription _contactsStreamSubscription;
  late TextEditingController inputController;
  late TextEditingController confirmationScreenInputController;
  RxBool allowAddingMembers = false.obs;
  RxBool isTextInputFocused = false.obs;
  RxBool isconfirmationTextInputFocused = false.obs;
  RxList<UserModel> searchSuggestions = <UserModel>[].obs;
  final String profileLink = 'https://heyo.core/m6ljkB4KJ';
  RxList<UserModel> selectedCoreids = <UserModel>[].obs;

  @override
  Future<void> onInit() async {
    await setupInputController();
    await _listenToContacts();
    super.onInit();
  }

  @override
  void onReady() {
    //_addMockUsers();
    super.onReady();
  }

  @override
  void onClose() async {
    inputController.dispose();
    confirmationScreenInputController.dispose();
    await _contactsStreamSubscription.cancel();
    // await _clearSearchSuggestions();
    super.onClose();
  }

  Future<void> setupInputController() async {
    inputController = TextEditingController();
    confirmationScreenInputController = TextEditingController();

    inputController.addListener(() async {
      inputText.value = inputController.text;
      await _searchUsers(inputController.text);
    });
    confirmationScreenInputController.addListener(() {
      confirmationInputText.value = confirmationScreenInputController.text;
    });
  }

  Future<void> _listenToContacts() async {
    _contactsStreamSubscription =
        (await contactRepository.getContactsStream()).listen((newContacts) {
      _updateSearchSuggestions(newContacts);
    });
  }

  void _updateSearchSuggestions(List<UserModel> newContacts) {
    if (inputText.value.isEmpty) {
      searchSuggestions
        ..value = newContacts
        ..sort((a, b) => a.name.compareTo(b.name));
    }
  }

  Future<void> _searchUsers(String query) async {
    final searchedItems = (await contactRepository.search(query)).toList();
    await processSearchResults(searchedItems, query);
  }

  Future<void> processSearchResults(List<UserModel> results, String query) async {
    if (results.isEmpty && query.isValidCoreId()) {
      await handleEmptySearchResults(query);
    } else {
      searchSuggestions.value = results;
    }
    searchSuggestions.sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> handleEmptySearchResults(String query) async {
    final currentUserCoreId = await accountInfoRepo.getUserAddress();
    if (currentUserCoreId != query) {
      // Add logic for new user
      searchSuggestions.value = [
        UserModel(
          name: 'Unknown',
          walletAddress: query,
          coreId: query,
        ),
      ];
    } else {
      searchSuggestions.clear();
    }
  }

  void handleScannedValue(String? barcodeValue) {
    if (barcodeValue == null) return;
    final coreId = barcodeValue.getCoreId();
    _updateInputField(coreId);
  }

  void _updateInputField(String coreId) {
    Get.back();
    isTextInputFocused.value = true;
    inputController.text = coreId;
  }

  Future<void> handleItemTap(UserModel user) async {
    await updateSelectedCoreIds(user);
    await updateContactRepository(user);
  }

  Future<void> updateSelectedCoreIds(UserModel user) async {
    if (selectedCoreids.any((element) => element.coreId == user.coreId)) {
      selectedCoreids.removeWhere((element) => element.coreId == user.coreId);
    } else {
      selectedCoreids.add(user);
    }
  }

  Future<void> updateContactRepository(UserModel user) async {
    final contact = await contactRepository.getContactById(user.coreId);
    if (contact == null) {
      await contactRepository.addContact(user);
    }
  }

  Future<void> _clearSearchSuggestions() async {
    for (final element in searchSuggestions) {
      await contactRepository.deleteContactById(element.coreId);
    }
  }

  void handleFabOnpressed() {
    if (selectedCoreids.length <= 1) {
      _showMembersSnackbar();
    } else if (showConfirmationScreen.value == false) {
      _showConfirmationScreen();
    } else if (confirmationInputText.value.isEmpty) {
      _showGroupNameSnackbar();
    } else {
      _navigateToMessages();
    }
  }

  void _showConfirmationScreen() {
    showConfirmationScreen.value = true;
    confirmationScreenInputFocusNode.requestFocus();
  }

  Future<void> _navigateToMessages() async {
    final chatId = ChatIdGenerator.generate();
    print(chatId);

    final selfCoreId = await accountInfoRepo.getUserAddress() ?? "";

    final participants = selectedCoreids
        .map(
          (element) => MessagingParticipantModel(
            coreId: element.coreId,
            chatId: chatId,
          ),
        )
        .toList();

    if (!selectedCoreids.contains(selfCoreId)) {
      participants.add(
        MessagingParticipantModel(
          coreId: selfCoreId,
          chatId: chatId,
        ),
      );
    }

    await Get.offNamedUntil(
      Routes.MESSAGES,
      ModalRoute.withName(Routes.HOME),
      arguments: MessagesViewArgumentsModel(
        connectionType: MessagingConnectionType.internet,
        participants: participants,
        chatName: confirmationInputText.value,
      ),
    );
  }

  void handleAllowMembersOnTap(bool value) {
    allowAddingMembers.value = value;
  }

  void handleGroupChatPhotoOnTap() {
    _showDevelopmentSnackbar('Adding group chat avatar');
  }

  void _showDevelopmentSnackbar(String featureName) {
    Get.rawSnackbar(
      messageText: Text(
        '$featureName is in development phase',
        style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kGreenMainColor),
        textAlign: TextAlign.center,
      ),
      backgroundColor: COLORS.kAppBackground,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.only(top: 20),
      boxShadows: [
        BoxShadow(
          color: const Color(0xFF466087).withOpacity(0.1),
          offset: const Offset(0, 3),
          blurRadius: 10,
        ),
      ],
      borderRadius: 8,
    );
  }

  void _showMembersSnackbar() {
    Get.rawSnackbar(
      messageText: Text(
        'Select two or more members to start a group chat.',
        style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kGreenMainColor),
        textAlign: TextAlign.center,
      ),
      backgroundColor: COLORS.kAppBackground,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.only(top: 20),
      boxShadows: [
        BoxShadow(
          color: const Color(0xFF466087).withOpacity(0.1),
          offset: const Offset(0, 3),
          blurRadius: 10,
        ),
      ],
      borderRadius: 8,
    );
  }

  void _showGroupNameSnackbar() {
    Get.rawSnackbar(
      messageText: Text(
        'Add group name to start a group chat.',
        style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kGreenMainColor),
        textAlign: TextAlign.center,
      ),
      backgroundColor: COLORS.kAppBackground,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.only(top: 20),
      boxShadows: [
        BoxShadow(
          color: const Color(0xFF466087).withOpacity(0.1),
          offset: const Offset(0, 3),
          blurRadius: 10,
        ),
      ],
      borderRadius: 8,
    );
  }

  Future<bool> handleConfirmationWidgetPop() async {
    showConfirmationScreen.value = false;
    inputFocusNode.requestFocus();
    return false;
  }

  Future<void> _addMockUsers() async {
    final _mockUsers = <UserModel>[
      // UserModel(
      //   name: 'testApi33',
      //   walletAddress: 'ab68f7423e57d266d5a7061e3e166f5004e7353e841e',
      //   coreId: 'ab68f7423e57d266d5a7061e3e166f5004e7353e841e',
      // ),
      // UserModel(
      //   name: 'Farzaam',
      //   walletAddress: 'CB62C325',
      //   coreId: 'CB62C325',
      //   isOnline: true,
      //   isVerified: true,
      // ),
      // UserModel(
      //   name: 'Ali',
      //   walletAddress: 'CB423H4E',
      //   coreId: 'CB423H4E',
      //   isOnline: true,
      // ),
      // UserModel(
      //   name: 'Saeed',
      //   walletAddress: 'CB23969A',
      //   coreId: 'CB23969A',
      // ),
      // UserModel(
      //   name: 'testIosReal',
      //   walletAddress: 'ab08a6c74ca74022a394ac1dab6a8adb55e5146e8caf',
      //   coreId: 'ab08a6c74ca74022a394ac1dab6a8adb55e5146e8caf',
      // ),
      // UserModel(
      //   name: 'testApi31',
      //   walletAddress: 'ab45655fd5cdec507ed368251568c66abb3b0d71dd30',
      //   coreId: 'ab45655fd5cdec507ed368251568c66abb3b0d71dd30',
      // ),
      // UserModel(
      //   name: 'testIosSim',
      //   walletAddress: 'ab1920ab021739e5120b158eaefd579bcf3b01527f91',
      //   coreId: 'ab1920ab021739e5120b158eaefd579bcf3b01527f91',
      //   isOnline: true,
      // ),
    ].obs;
    await Future.delayed(const Duration(seconds: 2), () async {
      for (var i = 0; i < _mockUsers.length; i++) {
        if (searchSuggestions.any((element) => element.coreId == _mockUsers[i].coreId)) {
          return;
        } else {
          await contactRepository.addContact(_mockUsers[i]);
        }
      }
    });
  }
}
