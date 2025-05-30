import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../util/app_vars.dart';

class CouponsController extends GetxController {
  static const String uri = "/api/subjects/coupons";
  static const String table = "coupons";
  int enterState = 0;

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
          enterState = 1; // go to lesson
        } else {
          enterState = 2; // show popup coupon
        }
      }
    } catch (err) {
      if (kDebugMode) print("err $uri: $err");
    }
    isLoading(loading: false);
  }
}
