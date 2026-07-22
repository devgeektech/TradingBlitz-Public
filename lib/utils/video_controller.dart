
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:trading/utils/utils.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  var isInitialized = false.obs;

  Future<void> initializeVideo({bool isLocal = false}) async {
    if (isLocal) {
      videoPlayerController = VideoPlayerController.asset("assets/images/aaa_intro_video.mp4");
    } else {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(Utils.loginVideoUrl));
    }

    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
      showControls: true,
      showControlsOnInitialize: true,
    );

    isInitialized.value = true;
  }

  @override
  void onClose() {
    if (isInitialized.value) {
      videoPlayerController.dispose();
      chewieController?.dispose();
    }
    super.onClose();
  }

}
