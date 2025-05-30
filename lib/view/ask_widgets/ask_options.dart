import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alsharq/controller/start_controller.dart';

import '../../controller/asks_controller.dart';
import '../../util/app_consts.dart';
import 'package:audioplayers/audioplayers.dart';

class AskOptions extends StatefulWidget {
  final List options;
  final AsksController asksController;
  AskOptions({super.key, required this.options, required this.asksController});

  @override
  State<AskOptions> createState() => _AskOptionsState();
}

class _AskOptionsState extends State<AskOptions> {
  ScrollController scrollController = ScrollController();

  StartController startController = Get.find();

  final AudioPlayer player = AudioPlayer();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: ListView.separated(
        controller: scrollController,
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 16, top: 10),
        itemCount: widget.options.length,
        itemBuilder: (context, int i) {
          final item = widget.options[i];
          Color bgColor = Colors.white;
          if(widget.asksController.clickedOption != 0 && item['answer'] == 1) {
            bgColor = Colors.green;
          }
          else if(widget.asksController.clickedOption == item['id'] && item['answer'] == 0) {
            bgColor = Colors.red;
          }
          else {
            bgColor = Colors.white;
          }
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(
              minHeight: 50,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(8),
                backgroundColor: bgColor,
                foregroundColor: AppConsts.secondaryColor,
                elevation: 1,
                surfaceTintColor: Colors.white,
              ),
              onPressed: () {
                if ((widget.asksController.numCorrectAnswers + widget.asksController.numWrongAnswers) == (widget.asksController.dataList!.length)) return;
                if(widget.asksController.disableNextButton == false) return;
                if(item['answer'] == 1) {
                  widget.asksController.numCorrectAnswers = widget.asksController.numCorrectAnswers + 1;
                  widget.asksController.rateCorrectAnswers = widget.asksController.numCorrectAnswers * widget.asksController.askGrade;
                  player.play(AssetSource(AppConsts.soundCorrect));
                  startController.reward();
                } else {
                  widget.asksController.numWrongAnswers = widget.asksController.numWrongAnswers + 1;
                  widget.asksController.rateWrongAnswers = widget.asksController.numWrongAnswers * widget.asksController.askGrade;
                  player.play(AssetSource(AppConsts.soundBuzz));
                }
                widget.asksController.changeDisableNextButton(false, item['id']);
              },
              child: Text(
                item['name'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: AppConsts.normal + 1,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, int i) {
          return SizedBox(height: 12);
        },
      ),
    );
  }
}

