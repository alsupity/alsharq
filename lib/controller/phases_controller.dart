import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../util/app_vars.dart';

class PhasesController extends GetxController {
  static const String uri = "/api/phases";
  static const String table = "phases";

  bool loading = true;

  isLoading({bool loading = false}) {
    this.loading = loading;
    update();
  }

  List? dataList;

  getData() async {
    try {
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

  tmpData() async {
    await Future.delayed(Duration(seconds: 1));
    dataList = [
      {
        "id": 1,
        "name": "1",
        "override_rate": 50,
        "sequence": 1,
        "rank": 1,
        "num_actual_asks": null,
        "subject_id": 1,
        "rate": 70,
        "status": null,
        "priority": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 2,
        "name": "2",
        "override_rate": 50,
        "sequence": 1,
        "rank": 2,
        "num_actual_asks": null,
        "subject_id": 1,
        "rate": 0,
        "status": null,
        "priority": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 3,
        "name": "3",
        "override_rate": 50,
        "sequence": 1,
        "rank": 3,
        "num_actual_asks": null,
        "subject_id": 1,
        "rate": 0,
        "status": null,
        "priority": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 4,
        "name": "4",
        "override_rate": 50,
        "sequence": 1,
        "rank": 4,
        "num_actual_asks": null,
        "subject_id": 1,
        "rate": 0,
        "status": null,
        "priority": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
    ];
    isLoading(loading: false);
  }
}
