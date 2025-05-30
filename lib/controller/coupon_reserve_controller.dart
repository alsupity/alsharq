import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../util/app_vars.dart';

class SignInController extends GetxController {
  static const String uri = "/api/coupons/reserve";

  bool loading = false;

  isLoading({bool loading = true}) {
    this.loading = loading;
    update();
  }

  Future<Map<String, dynamic>?> postServerData(
      {Map<String, dynamic>? params}) async {
    isLoading(loading: true);
    try {
      final responseMap = await AppVars.api.post(
        uri,
        params: params ?? {},
      );
      print("response $responseMap");
      if (responseMap != null) {
        GetStorage().write("token", responseMap["token"]);
        final Map<String, dynamic>? response = responseMap["user"];
        if (response != null) {
          Fluttertoast.showToast(
            msg: "تم تسجيل الدخول بنجاح",
          );
          isLoading(loading: false);
          return response;
        }
      }
    } catch (err) {
      if (kDebugMode) print("err $uri: $err");
      Fluttertoast.showToast(
        msg: "حدث خطأ ما ${err}",
      );
      isLoading(loading: false);
      return null;
    }
    return null;
  }
}
