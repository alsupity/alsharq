import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../util/init.dart';

class StartController extends GetxController {
  late ConfettiController confettiController;
  late FToast fToast;

  // AudioPlayer audioPlayer = AudioPlayer();

  reward() async {
    try {
      showConfetti();
    } catch (err) {
      print("err in giveReward: $err");
    }
  }

  Future showConfetti() async {
    Widget toast = ConfettiWidget(
      confettiController: confettiController,
      blastDirectionality: BlastDirectionality.explosive,
      emissionFrequency: 0.01,
      numberOfParticles: 20,
      minBlastForce: 5,
      maxBlastForce: 12,
      gravity: 0.1,
      createParticlePath: (size) {
        return Init.drawStar(size);
      },
    );
    confettiController.play();
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(milliseconds: 3000),
      fadeDuration: Duration(milliseconds: 500),
    );
  }
}
