import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:heyo/app/modules/messages/data/models/messages/video_message_model.dart';
import 'package:video_player/video_player.dart';

class VideoMessageController extends GetxController {
  final _videoPlayerController = Rxn<VideoPlayerController?>();
  final _chewieController = Rxn<ChewieController?>();
  final playingId = "".obs;

  ChewieController? get chewieController => _chewieController.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _videoPlayerController.value?.dispose();

    _chewieController.value?.dispose();
  }

  Future<void> initializePlayer(VideoMessageModel message) async {
    stopAndClearPreviousVideo();

    playingId.value = message.messageId;

    _videoPlayerController.value = VideoPlayerController.network(message.url);
    await _videoPlayerController.value!.initialize();

    _chewieController.value = ChewieController(
      videoPlayerController: _videoPlayerController.value!,
      hideControlsTimer: const Duration(seconds: 1),
      autoPlay: true,
    );
  }

  void stopAndClearPreviousVideo() {
    _chewieController.value?.pause();

    _videoPlayerController.value = null;
    _chewieController.value = null;

    playingId.value = "";
  }
}
