import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../util/app_vars.dart';

class AsksController extends GetxController {
  static const String uri = "/api/asks";
  static const String table = "asks";

  bool loading = true;

  isLoading({bool loading = false}) {
    this.loading = loading;
    update();
  }

  List? dataList;

  getData() async {
    try {
      // final response = await AppVars.api.get(uri);
      final response = await AppVars.dbHelper.select(
        column: "*",
        table: table,
        condition: " 1 ",
      );
      if (response.isNotEmpty) {
        dataList = [];
        for (var element in response) {
          dataList!.add(element);
        }
      }
    } catch (err) {
      if (kDebugMode) print("err $uri: $err");
    }
    if (kDebugMode) print("dataList $uri: $dataList");
    isLoading(loading: false);
  }

  double askGrade = 0.0;

  tmpData() async {
    await Future.delayed(Duration(seconds: 1));
    dataList = [
      {
        "id": 1,
        "name": "ما هو العنصر الكيميائي الأكثر وفرة في الغلاف الجوي؟",
        "options_json":
            """[{"id": 1, "name": "الاكسجين", "answer": 0}, {"id": 2, "name": "النيتروجين", "answer": 1}, {"id": 3, "name": "اليورانيوم", "answer": 0}]""",
        "phase_id": 1,
        "priority": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 2,
        "name": "من هو صديق رسول الله صلّى الله عليه وسلّم في رحلة الهجرة من مكة إلى المدينة؟",
        "options_json":
            """[{"id": 1, "name": "عمر بن الخطاب", "answer": 0}, {"id": 2, "name": "علي بن ابي طالب", "answer": 0}, {"id": 3, "name": "أبو بكر الصديق", "answer": 1}]""",
        "phase_id": 1,
        "priority": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 3,
        "name": "من هو الطير الذي يُوصف بالإجرام، ويُسبب النسبة الأكبر من حرائق الغابات؟",
        "options_json":
            """[{"id": 1, "name": "الحدأة", "answer": 1}, {"id": 2, "name": "الهدهد", "answer": 0}, {"id": 3, "name": "النورس", "answer": 0}]""",
        "phase_id": 1,
        "priority": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 4,
        "name": "ما هو الكوكب الأبعد مسافةً عن الشّمس، وبماذا يُسمّى؟",
        "options_json":
            """[{"id": 1, "name": "الزهرة", "answer": 0}, {"id": 2, "name": "بلوتو", "answer": 1}, {"id": 3, "name": "زحل", "answer": 0}]""",
        "phase_id": 1,
        "priority": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
    ];
    if (dataList != null) askGrade = 100.0 / dataList!.length;
    isLoading(loading: false);
  }

  PageController pageController = PageController(initialPage: 0, keepPage: false);
  int numCorrectAnswers = 0;
  int numWrongAnswers = 0;
  double rateCorrectAnswers = 0.0;
  double rateWrongAnswers = 0.0;
  int clickedOption = 0;
  bool disableNextButton = true;

  changeDisableNextButton(bool disableNextButton, int clickedOption) {
    this.disableNextButton = disableNextButton;
    this.clickedOption = clickedOption;
    update();
  }
}
