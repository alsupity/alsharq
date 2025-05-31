import 'package:alsharq/model/education_tool_model.dart';
import 'package:alsharq/util/app_consts.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatefulWidget {
  final EducationToolModel educationToolModel;
  const VideoPlayerScreen({super.key, required this.educationToolModel});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _isLooping = false;

  String fileUrl = "";

  @override
  void initState() {
    super.initState();

    initializePlayer();
  }

  Future<void> initializePlayer() async {
    fileUrl =
        "${AppConsts.baseUrl}${AppConsts.storageUrl}/${widget.educationToolModel.file}";
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(fileUrl),
    );

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: _isLooping,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      allowFullScreen: true,
      allowMuting: true,
      showControls: true,
      placeholder: Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.red,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.white,
      ),
      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            iconData: _isLooping ? Icons.repeat_one : Icons.repeat,
            title: "تكرار الفيديو",
            onTap: () {
              setState(() {
                _isLooping = !_isLooping;
              });
              _videoPlayerController.setLooping(_isLooping);
              if (_isLooping == true) {
                Fluttertoast.showToast(msg: "تم تشغيل تكرار الفيديو");
              } else {
                Fluttertoast.showToast(msg: "تم إيقاف تكرار الفيديو");
              }
              Navigator.pop(context);
            },
          ),
        ];
      },
      optionsTranslation: OptionsTranslation(
        playbackSpeedButtonText: 'سرعة التشغيل',
        subtitlesButtonText: "الترجمة",
        cancelButtonText: 'الغاء',
      ),
    );

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مشغل الفيديو',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: _isInitialized
            ? Column(
                children: [
                  AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Chewie(controller: _chewieController!),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                                "هل هو فيديو تعليمي، ترفيهي، إعلاني، أو شيء آخر",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            const Text(
                                "في هذا الفيديو التعليمي، سنأخذك في رحلة شيقة لتعلم من الصفر حتى الاحتراف. سواء كنت مبتدئًا أو لديك بعض الخبرة، ستجد في هذا الدليل خطوات واضحة ونصائح عملية تساعدك على فهم [الموضوع] بسهولة."),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
