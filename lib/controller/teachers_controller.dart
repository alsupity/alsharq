import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../util/app_vars.dart';

class TeachersController extends GetxController {
  static const String uri = "/api/subjects/teachers";
  static const String table = "teachers";

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
    if (kDebugMode) print("$uri/$extra");

    try {
      final responseMap = await AppVars.api.get(uri, extra: "/${extra}");
      final response = responseMap;
      print("response $response");
      if (response.isNotEmpty) {
        if (response is List) {
          dataList = [];
          for (var element in response) {
            dataList!.add(element);
          }
        }
      }
    } catch (err) {
      if (kDebugMode) print("err $uri: $err");
    }
    isLoading(loading: false);
  }

  tmpData() async {
    await Future.delayed(Duration(seconds: 1));
    dataList = [
      {
        "id": 1,
        "name": "محمد محمود",
        "image": "islamic2.png",
        "body": null,
        "priority": 1,
        "subject_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 2,
        "name": "خالد مسعد",
        "image": "islamic4.png",
        "body": "شهادة بكالريوس",
        "priority": 1,
        "subject_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 3,
        "name": "امل طه",
        "image": "arabic.png",
        "body": "ماجستير",
        "priority": 1,
        "subject_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 4,
        "name": "مسعود احمد",
        "image": "math2.png",
        "body": "حاصل على شهادة دكتورة",
        "priority": 1,
        "subject_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 5,
        "name": "مختار صالح",
        "image": "science3.png",
        "body": null,
        "priority": 1,
        "subject_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
    ];
    isLoading(loading: false);
  }
}
