import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../util/app_vars.dart';

class DepartmentsController extends GetxController {
  static const String uri = "/api/departments";
  static const String table = "departments";

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
        condition: " 1 $condition ",
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

  getServerData() async {
    try {
      final responseMap = await AppVars.api.get(uri);
      print("response $responseMap");
      final response = responseMap["data"];
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
        "name": "عربي",
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 2,
        "name": "English",
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
    ];
    isLoading(loading: false);
  }
}
