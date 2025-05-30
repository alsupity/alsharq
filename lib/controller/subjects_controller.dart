import 'package:alsharq/model/class_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../util/app_vars.dart';

class SubjectsController extends GetxController {
  static const String uri = "/api/subjects";
  static const String table = "subjects";

  bool loading = true;

  isLoading({bool loading = false}) {
    this.loading = loading;
    update();
  }

  List? dataList;

  getData({String condition = ""}) async {
    try {
      final response = await AppVars.dbHelper.select(
        column: "*",
        table: table,
        condition: " 1 and $condition ",
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

  getServerData({String extra = ""}) async {
    final ClassModel classModel = ClassModel.fromJson(GetStorage().read("clas"));
    print("$uri/${classModel.id}");
    try {
      final responseMap = await AppVars.api.get(uri, extra: "/${classModel.id}");
      final response = responseMap["data"];
      print("response $response");
      if (response.isNotEmpty) {
        if(response is List) {
          dataList = [];
          for (var element in response) {
            dataList!.add(element);
          }
        }
      }
    } catch(err) {
      if (kDebugMode) print("err $uri: $err");
    }
    isLoading(loading: false);
  }

  tmpData() async {
    await Future.delayed(Duration(seconds: 1));
    dataList = [
      {
        "id": 1,
        "name": "القران الكريم",
        "image": "islamic2.png",
        "body": null,
        "priority": 1,
        "class_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 2,
        "name": "التربية الاسلامية",
        "image": "islamic4.png",
        "body": "علوم دينية",
        "priority": 1,
        "class_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 3,
        "name": "اللغة العربية",
        "image": "arabic.png",
        "body": "قراءة - نحو - صرف",
        "priority": 1,
        "class_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 4,
        "name": "الرياضيات",
        "image": "math2.png",
        "body": null,
        "priority": 1,
        "class_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 5,
        "name": "العلوم",
        "image": "science3.png",
        "body": null,
        "priority": 1,
        "class_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 6,
        "name": "اللغة الانجليزية",
        "image": "english.png",
        "body": "English Language",
        "priority": 1,
        "class_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
    ];
    isLoading(loading: false);
  }
}
