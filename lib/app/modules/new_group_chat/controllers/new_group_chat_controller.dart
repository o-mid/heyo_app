import 'dart:async';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/new_chat/data/models/user_model/user_model.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';
import 'package:heyo/app/modules/shared/utils/extensions/barcode.extension.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';
import 'package:heyo/modules/features/contact/domain/contact_repo.dart';
import 'package:heyo/modules/features/contact/domain/models/contact_model/contact_model.dart';
import 'package:heyo/modules/features/contact/usecase/add_contacts_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/contact_listener_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/delete_contact_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/get_contact_by_id_use_case.dart';
import 'package:heyo/modules/features/contact/usecase/serach_contacts_use_case.dart';

import '../../../routes/app_pages.dart';
import '../../messages/utils/chat_Id_generator.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../../../../modules/features/contact/data/local_contact_repo.dart';
import '../../shared/data/repository/account/account_repository.dart';
import '../../shared/utils/constants/colors.dart';
import '../../shared/utils/constants/textStyles.dart';

class NewGroupChatController extends GetxController {
  NewGroupChatController({
    required this.accountInfoRepo,
    required this.addContactUseCase,
    required this.getContactByIdUseCase,
    required this.deleteContactUseCase,
    required this.contactListenerUseCase,
    required this.searchContactsUseCase,
  });

  final ContactListenerUseCase contactListenerUseCase;
  final AddContactUseCase addContactUseCase;
  final GetContactByIdUseCase getContactByIdUseCase;
  final DeleteContactUseCase deleteContactUseCase;
  final SearchContactsUseCase searchContactsUseCase;
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
  RxList<ContactModel> searchSuggestions = <ContactModel>[].obs;
  final String profileLink = 'https://heyo.core/m6ljkB4KJ';
  RxList<ContactModel> selectedCoreids = <ContactModel>[].obs;

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
        (await contactListenerUseCase.execute()).listen((newContacts) {
      _updateSearchSuggestions(newContacts);
    });
  }

  void _updateSearchSuggestions(List<ContactModel> newContacts) {
    if (inputText.value.isEmpty) {
      searchSuggestions
        ..value = newContacts
        ..sort((a, b) => a.name.compareTo(b.name));
    }
  }

  Future<void> _searchUsers(String query) async {
    final searchedItems = (await searchContactsUseCase.execute(query)).toList();
    await processSearchResults(searchedItems, query);
  }

  Future<void> processSearchResults(
    List<ContactModel> results,
    String query,
  ) async {
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
        ContactModel(
          name: 'Unknown',
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

  Future<void> handleItemTap(ContactModel contact) async {
    await updateSelectedCoreIds(contact);
    await updateContactRepository(contact);
  }

  Future<void> updateSelectedCoreIds(ContactModel contact) async {
    if (selectedCoreids.any((element) => element.coreId == contact.coreId)) {
      selectedCoreids
          .removeWhere((element) => element.coreId == contact.coreId);
    } else {
      selectedCoreids.add(contact);
    }
  }

  Future<void> updateContactRepository(ContactModel contact) async {
    final checkContact = await getContactByIdUseCase.execute(contact.coreId);
    if (checkContact == null) {
      await addContactUseCase.execute(contact);
    }
  }

  Future<void> _clearSearchSuggestions() async {
    for (final element in searchSuggestions) {
      await deleteContactUseCase.execute(element.coreId);
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

    final participants = selectedCoreids.map((element) {
      return MessagingParticipantModel(
        coreId: element.coreId,
        chatId: chatId,
        name: element.name,
      );
    }).toList();

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
    final _mockUsers = <ContactModel>[
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
        if (searchSuggestions
            .any((element) => element.coreId == _mockUsers[i].coreId)) {
          return;
        } else {
          await addContactUseCase.execute(_mockUsers[i]);
        }
      }
    });
  }
}
