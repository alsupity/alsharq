import 'package:alsharq/view/countries.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:alsharq/view/intro.dart';
import 'package:alsharq/view/subjects.dart';

import 'controller/start_controller.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  StartController startController = Get.put(StartController());

  @override
  void initState() {
    super.initState();
    startController.fToast = FToast();
    startController.confettiController =
        ConfettiController(duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    if(GetStorage().read("country") == null || GetStorage().read("clas") == null || GetStorage().read("department") == null) {
      return Intro();
    } else {
      return Countries();
    }
  }
}
