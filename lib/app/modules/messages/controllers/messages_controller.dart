// ignore_for_file: require_trailing_commas

import 'dart:async';

import 'dart:io';

import 'package:heyo/app/modules/chats/data/models/chat_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/multi_media_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/file_metadata.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/usecases/init_message_usecase.dart';
import 'package:heyo/app/modules/messages/data/usecases/read_message_usecase.dart';
import 'package:heyo/app/modules/messages/data/usecases/send_message_usecase.dart';
import 'package:heyo/app/modules/messages/domain/message_repository_models.dart';
import 'package:heyo/app/modules/messages/domain/user_state_repository.dart';
import 'package:heyo/app/modules/messages/utils/extensions/messageModel.extension.dart';
import 'package:heyo/app/modules/messages/utils/open_camera_for_sending_media_message.dart';
import 'package:heyo/app/modules/messaging/connection/domain/messaging_connections_models.dart';
import 'package:heyo/app/modules/shared/utils/extensions/core_id.extension.dart';
import 'package:heyo/app/modules/shared/utils/permission_flow.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:heyo/app/modules/messages/data/models/messages/image_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/live_location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/location_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/text_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/audio_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/messages/message_model.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/image_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/video_metadata.dart';
import 'package:heyo/app/modules/messages/data/models/reaction_model.dart';
import 'package:heyo/app/modules/messages/data/models/reply_to_model.dart';
import 'package:heyo/app/modules/messages/widgets/delete_message_dialog.dart';
import 'package:heyo/app/modules/shared/controllers/global_message_controller.dart';
import 'package:heyo/app/modules/shared/controllers/live_location_controller.dart';
import 'package:heyo/app/modules/shared/controllers/audio_message_controller.dart';
import 'package:heyo/app/modules/shared/controllers/video_message_controller.dart';
import 'package:heyo/app/modules/shared/data/models/messages_view_arguments_model.dart';
import 'package:heyo/app/modules/shared/utils/extensions/datetime.extension.dart';
import 'package:heyo/app/routes/app_pages.dart';
import 'package:heyo/generated/assets.gen.dart';
import 'package:heyo/generated/locales.g.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../chats/data/repos/chat_history/chat_history_abstract_repo.dart';
import '../../messaging/controllers/common_messaging_controller.dart';
import '../../messaging/controllers/messaging_connection_controller.dart';
import '../../messaging/controllers/wifi_direct_connection_controller.dart';
import '../../messaging/unified_messaging_controller.dart';
import '../../new_chat/data/models/user_model.dart';
import '../../share_files/models/file_model.dart';
import '../../shared/utils/constants/colors.dart';
import '../../shared/utils/constants/textStyles.dart';
import '../../shared/utils/constants/transitions_constant.dart';
import '../../shared/utils/scroll_to_index.dart';
import '../data/usecases/delete_message_usecase.dart';
import '../data/usecases/update_message_usecase.dart';
import '../../shared/data/repository/contact_repository.dart';
import '../domain/connection_message_repository.dart';

class MessagesController extends GetxController {
  MessagesController({
    required this.messageRepository,
    required this.userStateRepository,
    required this.readMessageUseCase,
    required this.sendMessageUseCase,
    required this.updateMessageUseCase,
    required this.deleteMessageUseCase,
    required this.initMessageUseCase
  }) {
    init();
  }

  final SendMessageUseCase sendMessageUseCase;
  final UpdateMessageUseCase updateMessageUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;
  final ConnectionMessageRepository messageRepository;
  final UserStateRepository userStateRepository;
  final ReadMessageUseCase readMessageUseCase;
  final InitMessageUseCase initMessageUseCase;

  //final UnifiedConnectionController messagingController;

  late MessagingConnectionType connectionType;

  final _globalMessageController = Get.find<GlobalMessageController>();
  double _keyboardHeight = 0;
  late String chatId;

  late TextEditingController textController;
  late AutoScrollController scrollController;
  final newMessage = "".obs;
  final showEmojiPicker = false.obs;
  final isInRecordMode = false.obs;
  final messages = <MessageModel>[].obs;
  final selectedMessages = <MessageModel>[].obs;
  final replyingTo = Rxn<ReplyToModel>();

  RxInt currentRemoteMessagesIndex = 0.obs;

  RxInt lastReadRemoteMessagesIndex = 0.obs;
  RxString lastReadRemoteMessagesId = "".obs;
  RxString scrollPositionMessagesId = "".obs;

  final locationMessage = Rxn<LocationMessageModel>();
  late MessagesViewArgumentsModel args;
  late StreamSubscription _messagesStreamSubscription;

  late String sessionId;
  late KeyboardVisibilityController keyboardController;

  late ChatModel? chatModel;
  Rx<UserModel> user = UserModel(
    coreId: (Get.arguments as MessagesViewArgumentsModel).coreId,
    iconUrl: (Get.arguments).iconUrl as String ??
        "https://avatars.githubusercontent.com/u/2345136?v=4",
    name: (Get.arguments as MessagesViewArgumentsModel).coreId.shortenCoreId,
    walletAddress: (Get.arguments).coreId as String,
  ).obs;
  final FocusNode textFocusNode = FocusNode();

  final isListLoaded = false.obs;

  Future<void> init() async {
    _initMessagesArguments();

    _initUiControllers();
    await _getUserContact();
    // // Initialize messagingConnection instance of CommonMessagingController-inherited class depends on connection type
    // // Also included previous functionality of _initDataChannel()
    await initMessagingConnection();

    _sendForwardedMessages();
    await _getMessages();

    await _initMessagesStream();

    // Close emoji picker when keyboard opens
    _handleKeyboardVisibilityChanges();

    super.onInit();
  }

  _initMessagesArguments() async {
    args = Get.arguments as MessagesViewArgumentsModel;

    connectionType = args.connectionType;

    chatId = user.value.coreId;

    // UserModel? userModel = await contactRepository.getContactById(user.value.coreId);
    // //Todo: check the following line
    // _userModel = user.value.copyWith(isContact: (userModel != null));
  }

  Future<void> _getUserContact() async {
    user.value = await userStateRepository.getUserContact(
      userInstance: UserInstance(
        coreId: args.coreId,
        iconUrl: args.iconUrl,
      ),
    );
    user.refresh();
  }

  // late UserModel _userModel;
  UserModel getUser() {
    return user.value;
  }

  @override
  Future<void> onReady() async {
    animateToBottom();

    super.onReady();
  }

  void _initUiControllers() {
    keyboardController = KeyboardVisibilityController();
    _globalMessageController.reset();
    textController = _globalMessageController.textController;
    scrollController = _globalMessageController.scrollController;
  }

  Future<void> initMessagingConnection() async {
    initMessageUseCase.execute(args.connectionType.map(),args.coreId);
  }

  Future<void> _initMessagesStream() async {
    final messagesStream =
        await messageRepository.getMessagesStream(coreId: user.value.coreId);

    _messagesStreamSubscription = (messagesStream).listen((newMessages) {
      messages.value = newMessages;
      messages.refresh();
    });
  }

  @override
  Future<void> onClose() async {
    await _saveUserStates();
    _closeMediaPlayers();
    _messagesStreamSubscription.cancel();
    super.onClose();
  }

  void _closeMediaPlayers() {
    // Todo: remove this when a global player is implemented
    Get.find<AudioMessageController>().player.stop();

    Get.find<VideoMessageController>().stopAndClearPreviousVideo();
  }

  void _handleKeyboardVisibilityChanges() {
    final StreamSubscription keyboardChangesStream =
        keyboardController.onChange.listen((bool isKeyboardVisible) {
      // Toggle emoji picker based on keyboard visibility
      if (isKeyboardVisible) {
        _closeEmojiPicker();
        _keyboardHeight = Get.mediaQuery.viewInsets.bottom;
      }

      _adjustScrollPosition(isKeyboardVisible);
    });

    _globalMessageController.streamSubscriptions.add(keyboardChangesStream);
  }

  void _closeEmojiPicker() {
    showEmojiPicker.value = false;
  }

  void _adjustScrollPosition(bool isKeyboardVisible) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        final scrollOffset = scrollController.offset;
        final offsetChange =
            isKeyboardVisible ? _keyboardHeight : -_keyboardHeight;

        animateToPosition(
          offset: scrollOffset + offsetChange,
          duration: TRANSITIONS.messagingPage_KeyboardVisibilityDurtion,
          curve: TRANSITIONS.messagingPage_KeyboardVisibilityCurve,
        );
      }
    });
  }

  void _sendForwardedMessages() {
    if (args.forwardedMessages != null) {
      // Todo (libp2p): Send forwarded messages
      messages.addAll(
        args.forwardedMessages!.map(
          (m) => m.copyWith(
            // messageId: , // Todo: Generate new id for forwarded message
            isFromMe: true,
            isForwarded: true,
            status: MessageStatus.sending,
            clearReply: true,
            reactions: <String, ReactionModel>{},
          ),
        ),
      );
    }
  }

  void toggleEmojiPicker() {
    showEmojiPicker.value = !showEmojiPicker.value;
  }

  // adds a string after cursor position and cursor moves to the correct place.
  void appendAfterCursorPosition(String str) {
    final currentPos = textController.selection.base.offset;

    textController.text = textController.text.substring(0, currentPos) +
        str +
        textController.text.substring(currentPos);

    textController.selection = textController.selection.copyWith(
        baseOffset: currentPos + str.length,
        extentOffset: currentPos + str.length);

    newMessage.value = textController.text;
  }

  // this method handles backspace of emoji keyboard since the plugin doesn't handle that itself.
  // the character before cursor is removed and cursor moves to the correct place.
  void removeCharacterBeforeCursorPosition() {
    final currentPos = textController.selection.base.offset;
    final prefix = textController.text
        .substring(0, currentPos)
        .characters
        .skipLast(1)
        .toString();
    final suffix = textController.text.substring(currentPos);

    textController
      ..text = prefix + suffix
      ..selection = textController.selection.copyWith(
        baseOffset: prefix.length,
        extentOffset: prefix.length,
      );
  }

  Future<void> scrollToMessage({required String messageId}) async {
    final index = messages.lastIndexWhere((m) => m.messageId == messageId);
    if (index != -1) {
      WidgetsBinding.instance.scheduleFrameCallback((_) async {
        await scrollController.scrollToIndex(
          index,
          duration: const Duration(milliseconds: 200),
          preferPosition: AutoScrollPosition.end,
        );
      });
    } else {
      // Todo: implement loading replied message and scrolling to it
    }
  }

  Future<void> jumpToMessage({required String messageId}) async {
    // finding the index of the message
    final index = messages.lastIndexWhere((m) => m.messageId == messageId);
    // if the message found
    if (index != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await scrollController
            .scrollToIndex(
              index,
              duration: const Duration(milliseconds: 1),
              preferPosition: AutoScrollPosition.end,
            )
            .then((value) async => await _finishMessagesLoading());
      });
    }
    // in case of the message not found
    else {
      await _finishMessagesLoading();
    }
  }

  Future<void> _finishMessagesLoading() async {
    // Todo: remove this delay if needed
    await Future.delayed(
        TRANSITIONS.messagingPage_closeMessagesLoadingShimmerDurtion, () {
      isListLoaded.value = true;
    });
  }

  void jumpToBottom() {
    scrollController.jumpTo(
      scrollController.position.maxScrollExtent,
    );
  }

  void animateToBottom({
    Duration? duration,
    Curve? curve,
  }) {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      curve: curve ?? TRANSITIONS.messagingPage_generalMsgTransitioncurve,
      duration:
          duration ?? TRANSITIONS.messagingPage_generalMsgTransitionDurtion,
    );
  }

  void animateToPosition({
    required double offset,
    Duration? duration,
    Curve? curve,
  }) {
    scrollController.animateTo(
      offset,
      curve: curve ?? TRANSITIONS.messagingPage_generalMsgTransitioncurve,
      duration:
          duration ?? TRANSITIONS.messagingPage_generalMsgTransitionDurtion,
    );
  }

  Future<void> toggleReaction(MessageModel msg, String emoji) async {
    await updateMessageUseCase.execute(
      messageConnectionType: args.connectionType.map(),
      remoteCoreId: user.value.walletAddress,
      updateMessageType: UpdateMessageType.updateReactions(
        selectedMessage: msg,
        emoji: emoji,
        chatId: chatId,
      ),
    );
    // await messageRepository.updateReactions(
    //   updateMessageRepoModel: UpdateMessageRepoModel(
    //     selectedMessage: msg,
    //     emoji: emoji,
    //     chatId: chatId,
    //     remoteCoreId: user.value.walletAddress,
    //   ),
    // );
  }

  Future<void> toggleMessageReadStatus({required String messageId}) async {
    readMessageUseCase.execute(
        connectionType: args.connectionType.map(),
        messageId: messageId,
        remoteCoreId: user.value.walletAddress);

    await markMessagesAsReadById(
      lastReadmessageId: messageId,
    );
  }

  Future<void> markMessagesAsReadById(
      {required String lastReadmessageId}) async {
    await messageRepository.markMessagesAsReadById(
      lastReadmessageId: lastReadmessageId,
      chatId: chatId,
    );
  }

  Future<void> markAllMessagesAsRead() async {
    await messageRepository.markAllMessagesAsRead(chatId: chatId);
  }

  void toggleMessageSelection(String id) {
    final index = messages.indexWhere((m) => m.messageId == id);

    if (index < 0) {
      return;
    }

    final message = messages[index];
    if (message.isSelected) {
      selectedMessages.removeWhere((m) => m.messageId == id);
    } else {
      selectedMessages.add(message);
    }
    messages[index] = message.copyWith(isSelected: !message.isSelected);
    messages.refresh();
  }

  void clearSelected() {
    messages.setAll(0, messages.map((m) => m.copyWith(isSelected: false)));
    selectedMessages.clear();
  }

  Future<void> sendTextMessage() async {
    // SendTextMessageRepoModel(
    //   chatId: chatId,
    //   replyingToValue: replyingTo.value,
    //   newMessageValue: newMessage.value,
    //   remoteCoreId: user.value.walletAddress,
    // );
    //   final newMessageValue = sendTextMessageRepoModel.newMessageValue;
    //   final replyingToValue = sendTextMessageRepoModel.replyingToValue;
    //   final chatId = sendTextMessageRepoModel.chatId;
    //   final remoteCoreId = sendTextMessageRepoModel.remoteCoreId;

    await sendMessageUseCase.execute(
      messageConnectionType: args.connectionType.map(),
      sendMessageType: SendMessageType.text(
        text: newMessage.value,
        replyTo: replyingTo.value,
        chatId: chatId,
      ),
      remoteCoreId: user.value.walletAddress,
    );

    textController.clear();
    newMessage.value = "";

    _postMessageSendOperations();
  }

//TODO
  Future<void> sendAudioMessage(String path, int duration) async {
    // await messageRepository.sendAudioMessage(
    //   sendAudioMessageRepoModel: SendAudioMessageRepoModel(
    //     path: path,
    //     duration: duration,
    //     replyingToValue: replyingTo.value,
    //     chatId: chatId,
    //     remoteCoreId: user.value.walletAddress,
    //   ),
    // );
    await sendMessageUseCase.execute(
      messageConnectionType: args.connectionType.map(),
      sendMessageType: SendMessageType.audio(
        path: path,
        metadata: AudioMetadata(durationInSeconds: duration),
        replyTo: replyingTo.value,
        chatId: chatId,
      ),
      remoteCoreId: user.value.walletAddress,
    );

    _postMessageSendOperations();
  }

//TODO
  Future<void> sendLocationMessage() async {
    final message = locationMessage.value;
    if (message == null) {
      return;
    }
    await sendMessageUseCase.execute(
      messageConnectionType: args.connectionType.map(),
      sendMessageType: SendMessageType.location(
        lat: message.latitude,
        long: message.longitude,
        address: message.address,
        replyTo: replyingTo.value,
        chatId: chatId,
      ),
      remoteCoreId: user.value.walletAddress,
    );
    // await messageRepository.sendLocationMessage(
    //   sendLocationMessageRepoModel: SendLocationMessageRepoModel(
    //     latitude: message.latitude,
    //     longitude: message.longitude,
    //     address: message.address,
    //     replyingToValue: replyingTo.value,
    //     chatId: chatId,
    //     remoteCoreId: user.value.walletAddress,
    //   ),
    // );

    locationMessage.value = null;

    _postMessageSendOperations();
  }

//TODO
  Future<void> sendLiveLocation({
    required Duration duration,
    required double startLat,
    required double startLong,
  }) async {
    // await messageRepository.sendLiveLocation(
    //   sendLiveLocationRepoModel: SendLiveLocationRepoModel(
    //     startLat: startLat,
    //     startLong: startLong,
    //     duration: duration,
    //     replyingToValue: replyingTo.value,
    //     chatId: chatId,
    //     remoteCoreId: user.value.walletAddress,
    //   ),
    // );
    sendMessageUseCase.execute(
      messageConnectionType: args.connectionType.map(),
      sendMessageType: SendMessageType.liveLocation(
        startLat: startLat,
        startLong: startLong,
        duration: duration,
        replyTo: replyingTo.value,
        chatId: chatId,
      ),
      remoteCoreId: user.value.walletAddress,
    );

    _postMessageSendOperations();

    // Todo (libp2p): send message
    // Get.find<LiveLocationController>().startSharing(message.messageId, duration);
  }

  void animateToTop({
    Duration? duration,
    Curve? curve,
  }) {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      curve: curve ?? TRANSITIONS.messagingPage_generalMsgTransitioncurve,
      duration:
          duration ?? TRANSITIONS.messagingPage_generalMsgTransitionDurtion,
    );
  }

  void _postMessageSendOperations() {
    clearReplyTo();
    messages.refresh();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animateToBottom(
        duration: TRANSITIONS.messagingPage_sendMsgDurtion,
        curve: TRANSITIONS.messagingPage_sendMsgcurve,
      );
    });
  }

  //TODO ramin, it has been called by another controller that is a connected to a different view
  void prepareLocationMessageForSending({
    required double latitude,
    required double longitude,
    required String address,
  }) {
    //
    locationMessage.value = LocationMessageModel(
      latitude: latitude,
      longitude: longitude,
      address: address,
      messageId: (messages.length + 1).toString(),
      timestamp: DateTime.now(),
      senderName: "",
      senderAvatar: "",
      isFromMe: true,
      chatId: chatId,
    );
  }

  stopSharingLiveLocation(LiveLocationMessageModel message) {
    Get.find<LiveLocationController>()
        .removeIdFromSharingList(message.messageId);

    final index = messages.indexWhere((m) => m.messageId == message.messageId);

    if (index < 0) {
      return;
    }

    messages[index] = message.copyWith(endTime: DateTime.now());
    messages.refresh();

    // Todo (libp2p): update message
  }

  //TODO Ramin, this is a part of send method in our use case
  void replyTo() {
    if (selectedMessages.length != 1) return;
    final msg = selectedMessages.first;

    final replyMsg = msg.getReplyMsgText();

    replyingTo.value = ReplyToModel(
      repliedToMessageId: msg.messageId,
      repliedToName: msg.senderName,
      repliedToMessage: replyMsg,
    );

    clearSelected();
  }

  void clearReplyTo() {
    replyingTo.value = null;
  }

  void showDeleteSelectedDialog() {
    Get.dialog(
      DeleteMessageDialog(
        canDeleteForEveryone: canDeleteForEveryone(),
        deleteForEveryone: deleteSelectedForEveryone,
        deleteForMe: deleteSelectedForMe,
        toDeleteCount: selectedMessages.length,
      ),
    );
  }

  bool canDeleteForEveryone() {
    // If any selected messages belong to another user, it's not possible to delete for everyone
    return !selectedMessages.any((msg) => !msg.isFromMe);
  }

  Future<void> deleteSelectedForEveryone() async {
    await deleteMessageUseCase.execute(
      messageConnectionType: args.connectionType.map(),
      remoteCoreId: user.value.walletAddress,
      deleteMessageType: DeleteMessageType.forEveryone(
        chatId: chatId,
        selectedMessages: selectedMessages,
      ),
    );
    clearSelected();
  }

  Future<void> deleteSelectedForMe() async {
    await deleteMessageUseCase.execute(
      messageConnectionType: args.connectionType.map(),
      remoteCoreId: user.value.walletAddress,
      deleteMessageType: DeleteMessageType.forMe(
        chatId: chatId,
        selectedMessages: selectedMessages,
      ),
    );
    clearSelected();
  }

  void copySelectedToClipboard() {
    var text = "";

    if (selectedMessages.length == 1 &&
        selectedMessages.first is TextMessageModel) {
      text = (selectedMessages.first as TextMessageModel).text;
    } else {
      for (final message in selectedMessages) {
        if (message is! TextMessageModel) {
          continue;
        }

        text +=
            "[${message.senderName} - ${message.timestamp.dateInAmPmFormat()}]\n";
        text += message.text;
        text += "\n\n";
      }
    }

    Clipboard.setData(
      ClipboardData(text: text),
    );

    clearSelected();
  }

  //TODO probably this variable initialization can be moved to top
  RxBool isMediaGlassmorphicOpen = false.obs;

  void mediaGlassmorphicChangeState() {
    isMediaGlassmorphicOpen.value = !isMediaGlassmorphicOpen.value;
  }

  Future<void> pick(BuildContext context) async {
    final mediaPermission = await PermissionFlow(
      permission: Permission.mediaLibrary,
      subtitle: LocaleKeys.Permissions_capturePhotos.tr,
      indicatorIcon: Assets.svg.camerapermissionIcon.svg(
        width: 28.w,
        height: 28.w,
      ),
    ).start();

    if (!mediaPermission) {
      return;
    }

    final cameraPermission = await PermissionFlow(
      permission: Permission.camera,
      subtitle: LocaleKeys.Permissions_camera.tr,
      indicatorIcon: Assets.svg.camerapermissionIcon.svg(
        width: 28.w,
        height: 28.w,
      ),
    ).start();

    if (!cameraPermission) {
      return;
    }

    if (!isClosed) {
      openCameraPicker(context);
    }
  }

  //TODO ramin, i think they can be moved in a helper class, wee need to discuss further
  Future<void> openCameraPicker(BuildContext context) async {
    try {
      // await openCameraForSendingMediaMessage(
      //   context,
      //   receiverName: user.value.name,
      //   onEntitySaving: (CameraPickerViewType viewType, File file) async {
      //     AssetEntity? entity;

      //     switch (viewType) {
      //       case CameraPickerViewType.image:
      //         final String filePath = file.path;
      //         entity = await PhotoManager.editor.saveImageWithPath(
      //           filePath,
      //           title: path.basename(filePath),
      //         );

      //         if (entity == null) {
      //           break;
      //         }
      //         await SendMessage().execute(
      //             sendMessageType: SendMessageType.image(
      //               path: file.path,
      //               metadata: ImageMetadata(
      //                 height: entity.height.toDouble(),
      //                 width: entity.width.toDouble(),
      //               ),
      //               replyTo: replyingTo.value,
      //               chatId: chatId,
      //             ),
      //             remoteCoreId: user.value.walletAddress);

      //         break;
      //       case CameraPickerViewType.video:
      //         entity = await PhotoManager.editor.saveVideo(
      //           File(file.path),
      //           title: path.basename(file.path),
      //         );

      //         if (entity == null) {
      //           break;
      //         }

      //         await SendMessage().execute(
      //             sendMessageType: SendMessageType.video(
      //               path: file.path,
      //               metadata: VideoMetadata(
      //                 durationInSeconds: entity.videoDuration.inSeconds,
      //                 height: entity.height.toDouble(),
      //                 width: entity.width.toDouble(),
      //                 isLocal: true,
      //                 thumbnailBytes: await entity.thumbnailData,
      //                 thumbnailUrl: "https://mixkit.imgix.net/static/home/video-thumb3.png",
      //               ),
      //               replyTo: replyingTo.value,
      //               chatId: chatId,
      //             ),
      //             remoteCoreId: user.value.walletAddress);

      //         break;
      //     }

      //     Get.until((route) => Get.currentRoute == Routes.MESSAGES);

      //     mediaGlassmorphicChangeState();
      //     messages.refresh();
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       animateToBottom();
      //     });
      //   },
      // );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //TODO ramin, i think they can be moved in a helper class, wee need to discuss further
  Future<void> openGallery() async {
    final result = await Get.toNamed(
      Routes.GALLERY_PICKER,
    );
    if (result != null) {
      addSelectedMedia(result: result, closeMediaGlassmorphic: true);
    }
    closeMediaGlassmorphic();
    textFocusNode.unfocus();
    messages.refresh();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animateToBottom();
    });
  }

  //TODO ramin, i think they can be moved in a helper class, wee need to discuss further
  Future<void> addSelectedMedia({
    @required dynamic result,
    bool closeMediaGlassmorphic = false,
  }) async {
    if (closeMediaGlassmorphic) mediaGlassmorphicChangeState();

    // List? tempImages = [];
    // for (final element in result) {
    //   if (element["type"] == "image") {
    //     tempImages.add(ImageMessageModel(
    //       messageId: "${messages.lastIndexOf(messages.last) + 1}",
    //       isLocal: true,
    //       metadata: ImageMetadata(
    //         height: element["height"].toDouble(),
    //         width: element["width"].toDouble(),
    //       ),
    //       senderAvatar: '',
    //       senderName: '',
    //       isFromMe: true,
    //       status: MessageStatus.sending,
    //       chatId: chatId,
    //       timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
    //       url: element["path"],
    //     ));
    //   } else if (element["type"] == "video") {
    //     Uint8List thumbnailBytes = await element["thumbnail"];
    //     tempImages.add(VideoMessageModel(
    //       messageId: "${messages.lastIndexOf(messages.last) + 1}",
    //       chatId: chatId,
    //       metadata: VideoMetadata(
    //         durationInSeconds: element["videoDuration"].inSeconds,
    //         height: double.parse(element["height"].toString()),
    //         width: double.parse(element["width"].toString()),
    //         isLocal: true,
    //         thumbnailBytes: thumbnailBytes,
    //         thumbnailUrl: "https://mixkit.imgix.net/static/home/video-thumb3.png",
    //       ),
    //       url: element["path"],
    //       timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
    //       senderName: '',
    //       senderAvatar: '',
    //       isFromMe: true,
    //       status: MessageStatus.sending,
    //       type: MessageContentType.video,
    //     ));
    //   }
    // }
    // if (tempImages.length > 1) {
    //   messages.add(MultiMediaMessageModel(
    //     mediaList: tempImages,
    //     messageId: "${messages.lastIndexOf(messages.last) + 1}",
    //     chatId: chatId,
    //     senderAvatar: '',
    //     senderName: '',
    //     isFromMe: true,
    //     status: MessageStatus.sending,
    //     timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
    //   ));
    // } else {
    //   result.forEach((asset) async {
    //     switch (asset["type"]) {
    //       case "image":
    //         {
    //           messages.add(
    //             ImageMessageModel(
    //                 messageId: "${messages.lastIndexOf(messages.last) + 1}",
    //                 chatId: chatId,
    //                 isLocal: true,
    //                 metadata: ImageMetadata(
    //                   height: double.parse(asset["height"].toString()),
    //                   width: double.parse(asset["width"].toString()),
    //                 ),
    //                 senderAvatar: '',
    //                 senderName: '',
    //                 isFromMe: true,
    //                 status: MessageStatus.sending,
    //                 timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
    //                 url: asset["path"]),
    //           );
    //         }
    //         break;

    //       case "video":
    //         {
    //           messages.add(
    //             VideoMessageModel(
    //               messageId: "${messages.lastIndexOf(messages.last) + 1}",
    //               chatId: chatId,
    //               metadata: VideoMetadata(
    //                 durationInSeconds: asset["videoDuration"].inSeconds,
    //                 height: double.parse(asset["height"].toString()),
    //                 width: double.parse(asset["width"].toString()),
    //                 isLocal: true,
    //                 thumbnailBytes: await asset["thumbnail"],
    //                 thumbnailUrl: '',
    //               ),
    //               url: asset["path"],
    //               timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
    //               senderName: '',
    //               senderAvatar: '',
    //               isFromMe: true,
    //               status: MessageStatus.sending,
    //             ),
    //           );
    //         }
    //         break;
    //       case "text":
    //         {
    //           messages.add(
    //             TextMessageModel(
    //               messageId: "${messages.lastIndexOf(messages.last) + 1}",
    //               chatId: chatId,
    //               text: asset["value"],
    //               timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
    //               senderName: '',
    //               senderAvatar: '',
    //               isFromMe: true,
    //               status: MessageStatus.sending,
    //             ),
    //           );
    //         }
    //         break;

    //       default:
    //         break;
    //     }
    //   });
    // }

    // mediaGlassmorphicChangeState();
    // messages.refresh();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   animateToBottom();
    // });
  }

  Future<void> openFiles() async {
    final result = await Get.toNamed(
      Routes.SHARE_FILES,
    );
    if (result != null) {
      result as RxList<FileModel>;
      for (final asset in result) {
        await sendMessageUseCase.execute(
          messageConnectionType: args.connectionType.map(),
          sendMessageType: SendMessageType.file(
            metadata: FileMetaData(
              extension: asset.extension,
              name: asset.name,
              path: asset.path,
              size: asset.size,
              timestamp: asset.timestamp,
              isImage: asset.isImage,
            ),
            replyTo: replyingTo.value,
            chatId: chatId,
          ),
          remoteCoreId: user.value.walletAddress,
        );
      }
      mediaGlassmorphicChangeState();
      messages.refresh();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        animateToBottom();
      });
    }
  }

  void closeMediaGlassmorphic() {
    isMediaGlassmorphicOpen.value = false;
  }

  Future<void> _getMessages() async {
    await messageRepository.getMessagesList(coreId: user.value.coreId).then(
          (value) => {
            messages.value = value,
            messages.refresh(),
          },
        );
    chatModel = await userStateRepository.getUserChatModel(chatId: chatId);

    // of chatModel is null, scroll to bottom
    // eles scroll to last position

    if (chatModel != null) {
      print("scrolling to last position");

      lastReadRemoteMessagesId.value = chatModel!.lastReadMessageId;
      scrollPositionMessagesId.value = chatModel!.scrollPosition;
      // await scrollToMessage(messageId: chatModel!.scrollPosition);
      await jumpToMessage(messageId: chatModel!.scrollPosition);
      //isListLoaded.value = true;
    } else {
      // uncomment the following lines if you want to add mock Messages
      // and animate To the Bottom of list

      // await _addMockMessages();
      // WidgetsBinding.instance.scheduleFrameCallback((_) {
      //   animateToBottom(
      //     duration: TRANSITIONS.messagingPage_getAllMsgsDurtion,
      //     curve: TRANSITIONS.messagingPage_getAllMsgscurve,
      //   );
      // });
      isListLoaded.value = true;
      print("ListLoaded");

      chatModel = ChatModel(
        id: user.value.coreId,
        name: user.value.name,
        icon: user.value.iconUrl,
        lastMessage: "",
        timestamp: DateTime.now(),
        isOnline: true,
        isVerified: true,
        lastReadMessageId: lastReadRemoteMessagesId.value,
      );
    }
  }

  Future<void> saveCoreIdToClipboard() async {
    final remoteCoreId = user.value.walletAddress;
    print("Core ID : $remoteCoreId");
    await _copyToClipboard(remoteCoreId);
    _displaySnackbar(LocaleKeys.ShareableQrPage_copiedToClipboardText.tr);
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  void _displaySnackbar(String message) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: TEXTSTYLES.kBodySmall.copyWith(color: COLORS.kDarkBlueColor),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
      backgroundColor: COLORS.kWhiteColor,
      snackPosition: SnackPosition.TOP,
      maxWidth: 250.w,
      margin: EdgeInsets.only(top: 60.h),
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

  Future<List<int>> pathToUint8List(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List().toList();
  }

  Future<void> onMessagesItemVisibilityChanged({
    required VisibilityInfo visibilityInfo,
    required int itemIndex,
    required String itemMessageId,
    required MessageStatus itemStatus,
    required bool isFromMe,
  }) async {
    // checks for Messages if the item is fully visible (visibleFraction = 1)
    //and if its index is bigger than the last index that was visible
    if (visibilityInfo.visibleFraction == 1) {
      // saves the current item index in the scrollPositionMessagesIndex
      scrollPositionMessagesId.value = itemMessageId;
      // if the message is not from the current user it will check if its read or not
      // and if its not read it will toogleMessageReadStatus
      if (!isFromMe) {
        currentRemoteMessagesIndex.value = itemIndex;

        // print("currentItemIndex.value: ${currentRemoteMessagesIndex.value}");
        // print("lastReadRemoteMessagesIndex.value: ${lastReadRemoteMessagesIndex.value}");

        if (currentRemoteMessagesIndex.value >
            lastReadRemoteMessagesIndex.value) {
          // print("lastReadRemoteMessagesKey.value ${lastReadRemoteMessagesId.value}");

          //  checks if its status is read or not
          // if its not read, it will toogleMessageReadStatus

          if (itemStatus != MessageStatus.read) {
            lastReadRemoteMessagesIndex.value =
                currentRemoteMessagesIndex.value;
            lastReadRemoteMessagesId.value = itemMessageId;
            toggleMessageReadStatus(messageId: itemMessageId);
          }
        }
      }
    }
  }

  Future<void> _saveUserStates() async {
    await userStateRepository.saveUserStates(
      userInstance: UserInstance(coreId: args.coreId, iconUrl: args.iconUrl),
      userStates: UserStates(
        chatId: chatId,
        lastReadRemoteMessagesId: lastReadRemoteMessagesId.value,
        scrollPositionMessagesId: scrollPositionMessagesId.value,
        lastMessageTimestamp: messages.last.timestamp,
        lastMessagePreview: messages.last.getMessagePreview(),
      ),
    );
  }
}
