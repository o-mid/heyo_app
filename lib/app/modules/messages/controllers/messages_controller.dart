import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heyo/app/modules/messages/data/models/messages/file_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/multi_media_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/metadatas/file_metadata.dart';
import 'package:heyo/app/modules/messages/data/repo/messages_abstract_repo.dart';
import 'package:heyo/app/modules/messages/data/usecases/send_message_usecase.dart';
import 'package:heyo/app/modules/messages/utils/open_camera_for_sending_media_message.dart';
import 'package:heyo/app/modules/shared/providers/database/dao/user_preferences/user_preferences_abstract_provider.dart';
import 'package:heyo/app/modules/shared/providers/database/repos/user_preferences/user_preferences_abstract_repo.dart';
import 'package:heyo/app/modules/shared/utils/permission_flow.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera/flutter_camera.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/audio_message_model.dart';
import 'package:heyo/app/modules/messages/data/models/messages/call_message_model.dart';
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

import 'package:tuple/tuple.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../messaging/controllers/messaging_connection_controller.dart';
import '../../messaging/messaging_session.dart';
import '../../share_files/models/file_model.dart';
import '../../shared/data/models/user_preferences.dart';
import '../../shared/utils/constants/animations_constant.dart';
import '../../shared/utils/scroll_to_index.dart';
import '../data/usecases/delete_message_usecase.dart';
import '../data/usecases/update_message_usecase.dart';

class MessagesController extends GetxController {
  final MessagesAbstractRepo messagesRepo;
  final UserPreferencesAbstractRepo userPreferencesRepo;
  final MessagingConnectionController messagingConnection;

  MessagesController(
      {required this.messagesRepo,
      required this.messagingConnection,
      required this.userPreferencesRepo});

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

  late UserPreferences? userPreferences;
  final FocusNode textFocusNode = FocusNode();

  @override
  Future<void> onInit() async {
    super.onInit();
    args = Get.arguments as MessagesViewArgumentsModel;
    chatId = args.user.chatModel.id;
    keyboardController = KeyboardVisibilityController();

    _globalMessageController.reset();
    textController = _globalMessageController.textController;
    scrollController = _globalMessageController.scrollController;
    // initialize the messageing Connection
    await _initDataChannel();
    // get the messages from the database and scroll to the bottom or the last read message
    _getMessages();

    initMessagesStream();

    _sendForwardedMessages();

    // Close emoji picker when keyboard opens
    _handleKeyboardVisibilityChanges();
  }

  _initDataChannel() async {
    await messagingConnection.initMessagingConnection(remoteId: args.user.walletAddress);
  }

  void initMessagesStream() async {
    _messagesStreamSubscription =
        (await messagesRepo.getMessagesStream(chatId)).listen((newMessages) {
      messages.value = newMessages;
      // uncomment this if you want to scroll to the bottom after every new message is received

      // WidgetsBinding.instance.addPostFrameCallback(
      //   (_) {
      //     animateToBottom(
      //       duration: ANIMATIONS.receiveMsgDurtion,
      //       curve: ANIMATIONS.getAllMsgscurve,
      //     );
      //   },
      // );
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    await _saveUserPreferences();

    // Todo: remove this when a global player is implemented
    Get.find<AudioMessageController>().player.stop();

    Get.find<VideoMessageController>().stopAndClearPreviousVideo();
    _messagesStreamSubscription.cancel();
    super.onClose();
  }

  void _handleKeyboardVisibilityChanges() {
    // Close emoji picker when keyboard opens
    _globalMessageController.streamSubscriptions
        .add(keyboardController.onChange.listen((bool visible) {
      if (visible) {
        showEmojiPicker.value = false;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _keyboardHeight = Get.mediaQuery.viewInsets.bottom;
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.offset + _keyboardHeight,
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
            );
          }
        });
      } else {
        // when keyboard closes scroll in the amount of keyboard height so that
        // the same part of the messages as before remains visible
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.offset - _keyboardHeight,
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
            );
          }
        });
      }
    }));
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

    textController.selection = textController.selection
        .copyWith(baseOffset: currentPos + str.length, extentOffset: currentPos + str.length);

    newMessage.value = textController.text;
  }

  // this method handles backspace of emoji keyboard since the plugin doesn't handle that itself.
  // the character before cursor is removed and cursor moves to the correct place.
  void removeCharacterBeforeCursorPosition() {
    final currentPos = textController.selection.base.offset;
    final prefix = textController.text.substring(0, currentPos).characters.skipLast(1).toString();
    final suffix = textController.text.substring(currentPos);

    textController.text = prefix + suffix;
    textController.selection = textController.selection.copyWith(
      baseOffset: prefix.length,
      extentOffset: prefix.length,
    );
  }

  void scrollToMessage({required String messageId}) {
    final index = messages.lastIndexWhere((m) => m.messageId == messageId);
    if (index != -1) {
      WidgetsBinding.instance.scheduleFrameCallback((_) {
        scrollController.scrollToIndex(
          // check if index +1 is avialble

          //index + 1 != 0 ? index - 1 : index,
          index,
          duration: const Duration(milliseconds: 200),
          preferPosition: AutoScrollPosition.end,
        );
      });
    } else {
      // Todo: implement loading replied message and scrolling to it
    }
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
      scrollController.position.maxScrollExtent,
      curve: curve ?? ANIMATIONS.generalMsgTransitioncurve,
      duration: duration ?? ANIMATIONS.generalMsgTransitionDurtion,
    );
  }

  void toggleReaction(MessageModel msg, String emoji) {
    UpdateMessage().execute(
        updateMessageType: UpdateMessageType.updateReactions(
      selectedMessage: msg,
      emoji: emoji,
      chatId: chatId,
    ));
  }

  void toogleMessageReadStatus({required String messageId}) async {
    await messagingConnection.confirmReadMessages(messageId: messageId);
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

  void sendTextMessage() async {
    SendMessage().execute(
      sendMessageType: SendMessageType.text(
        text: newMessage.value,
        replyTo: replyingTo.value,
        chatId: chatId,
      ),
    );

    textController.clear();
    newMessage.value = "";

    // _postMessageSendOperations();
  }

//TODO
  void sendAudioMessage(String path, int duration) {
    SendMessage().execute(
      sendMessageType: SendMessageType.audio(
        path: path,
        metadata: AudioMetadata(durationInSeconds: duration),
        replyTo: replyingTo.value,
        chatId: chatId,
      ),
    );

    _postMessageSendOperations();
  }

//TODO
  void sendLocationMessage() {
    final message = locationMessage.value;
    if (message == null) {
      return;
    }

    SendMessage().execute(
      sendMessageType: SendMessageType.location(
        lat: message.latitude,
        long: message.longitude,
        address: message.address,
        replyTo: replyingTo.value,
        chatId: chatId,
      ),
    );

    locationMessage.value = null;

    _postMessageSendOperations();
  }

//TODO
  void sendLiveLocation({
    required Duration duration,
    required double startLat,
    required double startLong,
  }) {
    SendMessage().execute(
      sendMessageType: SendMessageType.liveLocation(
        startLat: startLat,
        startLong: startLong,
        duration: duration,
        replyTo: replyingTo.value,
        chatId: chatId,
      ),
    );

    _postMessageSendOperations();

    // Todo (libp2p): send message
    // Get.find<LiveLocationController>().startSharing(message.messageId, duration);
  }

  void _postMessageSendOperations() {
    messages.refresh();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animateToBottom(
        duration: ANIMATIONS.sendMsgDurtion,
        curve: ANIMATIONS.sendMsgcurve,
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
    );
  }

  stopSharingLiveLocation(LiveLocationMessageModel message) {
    Get.find<LiveLocationController>().removeIdFromSharingList(message.messageId);

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

    late String replyMsg;
    switch (msg.runtimeType) {
      case TextMessageModel:
        replyMsg = (msg as TextMessageModel).text;
        break;
      case ImageMessageModel:
        replyMsg = LocaleKeys.MessagesPage_replyToImage.tr;
        break;
      case VideoMessageModel:
        // Todo: use video metadata to show video duration
        replyMsg = LocaleKeys.MessagesPage_replyToVideo.tr;
        break;
      case AudioMessageModel:
        // Todo: use video metadata to show audio duration
        replyMsg = LocaleKeys.MessagesPage_replyToAudio.tr;
        break;
      case MultiMediaMessageModel:
        replyMsg = LocaleKeys.MessagesPage_replyToImage.tr;
        break;
    }

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

  void deleteSelectedForEveryone() {
    DeleteMessage().execute(
        deleteMessageType: DeleteMessageType.forEveryone(
      chatId: chatId,
      selectedMessages: selectedMessages,
    ));
    clearSelected();
  }

  void deleteSelectedForMe() {
    DeleteMessage().execute(
        deleteMessageType: DeleteMessageType.forMe(
      chatId: chatId,
      selectedMessages: selectedMessages,
    ));
    clearSelected();
  }

  void copySelectedToClipboard() {
    var text = "";

    if (selectedMessages.length == 1 && selectedMessages.first is TextMessageModel) {
      text = (selectedMessages.first as TextMessageModel).text;
    } else {
      for (var message in selectedMessages) {
        if (message is! TextMessageModel) {
          continue;
        }

        text += "[${message.senderName} - ${message.timestamp.dateInAmPmFormat()}]\n";
        text += message.text;
        text += "\n\n";
      }
    }

    Clipboard.setData(
      ClipboardData(text: text),
    );

    clearSelected();
  }

  RxBool isMediaGlassmorphicOpen = false.obs;
  mediaGlassmorphicChangeState() {
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
      await openCameraForSendingMediaMessage(
        context,
        receiverName: args.user.chatModel.name,
        onEntitySaving: (CameraPickerViewType viewType, File file) async {
          AssetEntity? entity;

          switch (viewType) {
            case CameraPickerViewType.image:
              final String filePath = file.path;
              entity = await PhotoManager.editor.saveImageWithPath(
                filePath,
                title: path.basename(filePath),
              );

              if (entity == null) {
                break;
              }
              await SendMessage().execute(
                sendMessageType: SendMessageType.image(
                  path: file.path,
                  metadata: ImageMetadata(
                    height: entity.height.toDouble(),
                    width: entity.width.toDouble(),
                  ),
                  replyTo: replyingTo.value,
                  chatId: chatId,
                ),
              );

              break;
            case CameraPickerViewType.video:
              entity = await PhotoManager.editor.saveVideo(
                File(file.path),
                title: path.basename(file.path),
              );

              if (entity == null) {
                break;
              }

              await SendMessage().execute(
                sendMessageType: SendMessageType.video(
                  path: file.path,
                  metadata: VideoMetadata(
                    durationInSeconds: entity.videoDuration.inSeconds,
                    height: entity.height.toDouble(),
                    width: entity.width.toDouble(),
                    isLocal: true,
                    thumbnailBytes: await entity.thumbnailData,
                    thumbnailUrl: "https://mixkit.imgix.net/static/home/video-thumb3.png",
                  ),
                  replyTo: replyingTo.value,
                  chatId: chatId,
                ),
              );

              break;
          }

          Get.until((route) => Get.currentRoute == Routes.MESSAGES);

          mediaGlassmorphicChangeState();
          messages.refresh();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            animateToBottom();
          });
        },
      );
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
  Future<void> addSelectedMedia(
      {@required dynamic result, bool closeMediaGlassmorphic = false}) async {
    if (closeMediaGlassmorphic) mediaGlassmorphicChangeState();

    List? tempImages = [];
    for (var element in result) {
      if (element["type"] == "image") {
        tempImages.add(ImageMessageModel(
          messageId: "${messages.lastIndexOf(messages.last) + 1}",
          isLocal: true,
          metadata: ImageMetadata(
            height: element["height"].toDouble(),
            width: element["width"].toDouble(),
          ),
          senderAvatar: '',
          senderName: '',
          isFromMe: true,
          status: MessageStatus.sending,
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
          url: element["path"],
        ));
      } else if (element["type"] == "video") {
        Uint8List thumbnailBytes = await element["thumbnail"];
        tempImages.add(VideoMessageModel(
          messageId: "${messages.lastIndexOf(messages.last) + 1}",
          metadata: VideoMetadata(
            durationInSeconds: element["videoDuration"].inSeconds,
            height: double.parse(element["height"].toString()),
            width: double.parse(element["width"].toString()),
            isLocal: true,
            thumbnailBytes: thumbnailBytes,
            thumbnailUrl: "https://mixkit.imgix.net/static/home/video-thumb3.png",
          ),
          url: element["path"],
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
          senderName: '',
          senderAvatar: '',
          isFromMe: true,
          status: MessageStatus.sending,
          type: MessageContentType.video,
        ));
      }
    }
    if (tempImages.length > 1) {
      messages.add(MultiMediaMessageModel(
        mediaList: tempImages,
        messageId: "${messages.lastIndexOf(messages.last) + 1}",
        senderAvatar: '',
        senderName: '',
        isFromMe: true,
        status: MessageStatus.sending,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
      ));
    } else {
      result.forEach((asset) async {
        switch (asset["type"]) {
          case "image":
            {
              messages.add(
                ImageMessageModel(
                    messageId: "${messages.lastIndexOf(messages.last) + 1}",
                    isLocal: true,
                    metadata: ImageMetadata(
                      height: double.parse(asset["height"].toString()),
                      width: double.parse(asset["width"].toString()),
                    ),
                    senderAvatar: '',
                    senderName: '',
                    isFromMe: true,
                    status: MessageStatus.sending,
                    timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
                    url: asset["path"]),
              );
            }
            break;

          case "video":
            {
              messages.add(
                VideoMessageModel(
                  messageId: "${messages.lastIndexOf(messages.last) + 1}",
                  metadata: VideoMetadata(
                    durationInSeconds: asset["videoDuration"].inSeconds,
                    height: double.parse(asset["height"].toString()),
                    width: double.parse(asset["width"].toString()),
                    isLocal: true,
                    thumbnailBytes: await asset["thumbnail"],
                    thumbnailUrl: '',
                  ),
                  url: asset["path"],
                  timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
                  senderName: '',
                  senderAvatar: '',
                  isFromMe: true,
                  status: MessageStatus.sending,
                ),
              );
            }
            break;
          case "text":
            {
              messages.add(
                TextMessageModel(
                  messageId: "${messages.lastIndexOf(messages.last) + 1}",
                  text: asset["value"],
                  timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
                  senderName: '',
                  senderAvatar: '',
                  isFromMe: true,
                  status: MessageStatus.sending,
                ),
              );
            }
            break;

          default:
            break;
        }
      });
    }

    mediaGlassmorphicChangeState();
    messages.refresh();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animateToBottom();
    });
  }

  Future<void> openFiles() async {
    final result = await Get.toNamed(
      Routes.SHARE_FILES,
    );
    if (result != null) {
      result as RxList<FileModel>;
      for (var asset in result) {
        await SendMessage().execute(
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

  void _getMessages() async {
    await userPreferencesRepo.getUserPreferencesById(chatId).then((value) async => {
          userPreferences = value,
          await messagesRepo.getMessages(chatId).then((value) => {
                messages.value = value,
              })
        });

    // of userPreferences is null, scroll to bottom
    // eles scroll to last position

    if (userPreferences != null) {
      lastReadRemoteMessagesId.value = userPreferences!.lastReadMessageId;
      scrollPositionMessagesId.value = userPreferences!.scrollPosition;
      scrollToMessage(messageId: userPreferences!.scrollPosition);
    } else {
      await _addMockMessages();
      // WidgetsBinding.instance.scheduleFrameCallback((_) {
      //   animateToBottom(
      //     duration: ANIMATIONS.getAllMsgsDurtion,
      //     curve: ANIMATIONS.getAllMsgscurve,
      //   );
      // });
    }
  }

//TODO remove?
  Future<void> _addMockMessages() async {
    var index = 0;

    final ms = [
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6, minutes: 5)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6, minutes: 4)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6, minutes: 3)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MessageStatus.read,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 5, minutes: 58)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MessageStatus.read,
      ),

      //
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 5)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
        status: MessageStatus.read,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 4)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 3)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MessageStatus.read,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 58)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MessageStatus.read,
      ),

      //
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 4)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 3)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MessageStatus.read,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 58)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MessageStatus.read,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Sure thing. Just let me know when sth happens",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 56)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
        reactions: {
          "🎉": ReactionModel(
            users: List.generate(12, (index) => ""),
          ),
          "🤘": ReactionModel(
            users: List.generate(3, (index) => ""),
            isReactedByMe: true,
          ),
          "🔥": ReactionModel(
            users: List.generate(5, (index) => ""),
          ),
          "👍": ReactionModel(
            users: List.generate(2, (index) => ""),
          ),
          "😎": ReactionModel(
            users: List.generate(1, (index) => ""),
          ),
        },
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Very nice!",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
        senderName: "",
        senderAvatar: "",
        replyTo: ReplyToModel(
          repliedToMessageId: "${index - 2}",
          repliedToMessage: "Sure thing. Just let me know when sth happens",
          repliedToName: args.user.chatModel.name,
        ),
        isFromMe: true,
        status: MessageStatus.read,
        reactions: {
          "🤗": ReactionModel(
            users: List.generate(1, (index) => ""),
          ),
          "😘": ReactionModel(
            users: List.generate(2, (index) => ""),
            isReactedByMe: true,
          ),
        },
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Very nice!",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 54)),
        senderName: "",
        senderAvatar: "",
        replyTo: ReplyToModel(
          repliedToMessageId: "0",
          repliedToMessage:
              "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
          repliedToName: args.user.chatModel.name,
        ),
        isFromMe: true,
        status: MessageStatus.read,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 52)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MessageStatus.sending,
      ),

      AudioMessageModel(
        messageId: "${index++}",
        metadata: AudioMetadata(durationInSeconds: 100),
        url: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 46)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MessageStatus.read,
      ),
      AudioMessageModel(
        messageId: "${index++}",
        metadata: AudioMetadata(durationInSeconds: 19),
        url: "https://download.samplelib.com/mp3/sample-15s.mp3",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      LocationMessageModel(
        messageId: "${index++}",
        latitude: 48.153445,
        longitude: 17.129925,
        address: "Kocelova 11-11, 821 08, Bratislava",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 44)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),

      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6, minutes: 5)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6, minutes: 4)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6, minutes: 3)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MessageStatus.read,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 5, minutes: 58)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MessageStatus.read,
      ),

      //
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 5)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
        status: MessageStatus.read,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 4)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 3)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MessageStatus.read,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 58)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MessageStatus.read,
      ),

      //
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Architecto, perferendis!",
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text:
            "In quibusdam possimus, temporibus itaque, soluta recusandae facere consequuntur consectetur dolorem deleniti reprehenderit.",
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 4)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 3)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MessageStatus.read,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 58)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MessageStatus.read,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Sure thing. Just let me know when sth happens",
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 56)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
        reactions: {
          "🎉": ReactionModel(
            users: List.generate(12, (index) => ""),
          ),
          "🤘": ReactionModel(
            users: List.generate(3, (index) => ""),
            isReactedByMe: true,
          ),
          "🔥": ReactionModel(
            users: List.generate(5, (index) => ""),
          ),
          "👍": ReactionModel(
            users: List.generate(2, (index) => ""),
          ),
          "😎": ReactionModel(
            users: List.generate(1, (index) => ""),
          ),
        },
      ),
      LiveLocationMessageModel(
        messageId: "${index++}",
        latitude: 35.65031,
        longitude: 51.2925217,
        endTime: DateTime.now().subtract(const Duration(minutes: 40)),
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 42)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),

      CallMessageModel(
        messageId: "${index++}",
        callStatus: CallMessageStatus.declined,
        callType: CallMessageType.video,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 41)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      CallMessageModel(
        messageId: "${index++}",
        callStatus: CallMessageStatus.missed,
        callType: CallMessageType.audio,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: " Nihil, incidunt!",
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 3)),
        senderName: args.user.chatModel.name,
        senderAvatar: args.user.chatModel.icon,
      ),
      TextMessageModel(
        messageId: "${index++}",
        text: "Lorem ipsum dolor sit.",
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        senderName: "",
        senderAvatar: "",
        isFromMe: true,
        status: MessageStatus.read,
      ),
    ];

    for (int i = 0; i < ms.length; i++) {
      await messagesRepo.createMessage(message: ms[i], chatId: chatId);
    }
  }

  Future<List<int>> pathToUint8List(String path) async {
    var data = await rootBundle.load(path);
    return data.buffer.asUint8List().toList();
  }

  void onMessagesItemVisibilityChanged({
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

        if (currentRemoteMessagesIndex.value > lastReadRemoteMessagesIndex.value) {
          // print("lastReadRemoteMessagesKey.value ${lastReadRemoteMessagesId.value}");

          //  checks if its status is read or not
          // if its not read, it will toogleMessageReadStatus

          if (itemStatus != MessageStatus.read) {
            lastReadRemoteMessagesIndex.value = currentRemoteMessagesIndex.value;
            lastReadRemoteMessagesId.value = itemMessageId;
            toogleMessageReadStatus(messageId: itemMessageId);
          }
        }
      }
    }
  }

  Future<void> _saveUserPreferences() async {
    // saves the last read message index in the user preferences repo
    await userPreferencesRepo.createOrUpdateUserPreferences(UserPreferences(
      chatId: chatId,
      lastReadMessageId: lastReadRemoteMessagesId.value,
      scrollPosition: scrollPositionMessagesId.value,
    ));
  }
}
