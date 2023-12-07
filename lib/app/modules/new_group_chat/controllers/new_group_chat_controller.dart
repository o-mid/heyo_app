import 'dart:async';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/shared/data/models/messaging_participant_model.dart';
import 'package:heyo/app/modules/shared/utils/extensions/barcode.extension.dart';
import 'package:heyo/app/modules/shared/utils/extensions/string.extension.dart';

import '../../../routes/app_pages.dart';
import '../../new_chat/data/models/user_model.dart';
import '../../shared/data/models/messages_view_arguments_model.dart';
import '../../shared/data/repository/contact_repository.dart';
import '../../shared/data/repository/crypto_account/account_repository.dart';
import '../../shared/utils/constants/colors.dart';
import '../../shared/utils/constants/textStyles.dart';

class NewGroupChatController extends GetxController {
  final ContactRepository contactRepository;
  final AccountRepository accountInfoRepo;
  final inputFocusNode = FocusNode();
  final confirmationScreenInputFocusNode = FocusNode();
  final showConfirmationScreen = false.obs;
  final inputText = "".obs;
  final confirmationInputText = "".obs;
  late StreamSubscription _contactsStreamSubscription;
  late TextEditingController inputController;
  late TextEditingController confirmationScreenInputController;
  RxBool isTextInputFocused = false.obs;
  RxBool isconfirmationTextInputFocused = false.obs;
  RxList<UserModel> searchSuggestions = <UserModel>[].obs;
  final String profileLink = "https://heyo.core/m6ljkB4KJ";
  RxList<String> selectedCoreids = <String>[].obs;

  NewGroupChatController({required this.contactRepository, required this.accountInfoRepo});
  final count = 0.obs;
  @override
  Future<void> onInit() async {
    await setupInputController();
    await _listenToContacts();
    super.onInit();
  }

  @override
  void onReady() {
    _addMockUsers();
    super.onReady();
  }

  @override
  void onClose() async {
    inputController.dispose();
    confirmationScreenInputController.dispose();
    await _contactsStreamSubscription.cancel();
    await _clearSearchSuggestions();
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
        (await contactRepository.getContactsStream()).listen(_updateSearchSuggestions);
  }

  void _updateSearchSuggestions(List<UserModel> newContacts) {
    if (inputText.value.isEmpty) {
      searchSuggestions
        ..value = newContacts
        ..sort((a, b) => a.name.compareTo(b.name));
    }
  }

  List<String> mockIconUrls = [
    "https://avatars.githubusercontent.com/u/6644146?v=4",
    "https://avatars.githubusercontent.com/u/7844146?v=4",
    "https://avatars.githubusercontent.com/u/7847725?v=4",
    "https://avatars.githubusercontent.com/u/9947725?v=4",
  ];
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
          iconUrl: (mockIconUrls..shuffle()).first,
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
    updateSelectedCoreIds(user);
    await updateContactRepository(user);
  }

  void updateSelectedCoreIds(UserModel user) {
    if (selectedCoreids.contains(user.coreId)) {
      selectedCoreids.remove(user.coreId);
    } else {
      selectedCoreids.add(user.coreId);
    }
  }

  Future<void> updateContactRepository(UserModel user) async {
    final contact = await contactRepository.getContactById(user.coreId);
    if (contact == null) {
      await contactRepository.addContact(user);
    }
  }

  Future<void> _addMockUsers() async {
    final _mockUsers = <UserModel>[
      UserModel(
        name: "Crapps",
        walletAddress: 'CB92...969A',
        coreId: 'CB92969A',
        iconUrl: "https://raw.githubusercontent.com/Zunawe/identicons/HEAD/examples/poly.png",
        nickname: "Nickname",
      ),
      UserModel(
        name: "Fancy",
        walletAddress: 'CB21...C325',
        coreId: 'CB21C325',
        iconUrl: "https://avatars.githubusercontent.com/u/6634136?v=4",
        isOnline: true,
        isVerified: true,
      ),
      UserModel(
        name: "manly",
        walletAddress: 'CB42...324E',
        coreId: 'CB42324E',
        iconUrl: "https://avatars.githubusercontent.com/u/9801359?v=4",
        isOnline: true,
      ),
    ].obs;

    for (int i = 0; i < _mockUsers.length; i++) {
      await Future.delayed(const Duration(seconds: 3), () async {
        if (searchSuggestions.any((element) => element.coreId == _mockUsers[i].coreId)) {
          return;
        } else {
          await contactRepository.addContact(_mockUsers[i]);
        }
      });
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
    } else {
      _navigateToMessages();
    }
  }

  void _navigateToMessages() {
    Get.toNamed(
      Routes.MESSAGES,
      arguments: MessagesViewArgumentsModel(
        coreId: selectedCoreids.value.first,
        iconUrl: mockIconUrls.first,
        connectionType: MessagingConnectionType.internet,
        participants:
            selectedCoreids.map((element) => MessagingParticipantModel(coreId: element)).toList(),
      ),
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
      margin: const EdgeInsets.only(bottom: 16),
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
}
