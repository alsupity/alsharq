import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../util/app_vars.dart';

class SingUpController extends GetxController {
  static const String uri = "/api/signup";

  bool loading = false;

  isLoading({bool loading = true}) {
    this.loading = loading;
    update();
  }

  Future<Map<String, dynamic>?> postServerData({Map<String, dynamic>? params}) async {
    isLoading(loading: true);
    try {
      final responseMap = await AppVars.api.post(
        uri,
        params: params??{},
      );
      print("response $responseMap");
      if(responseMap != null) {
        final Map<String, dynamic>? response = responseMap["user"];
        if (response != null) {
          Fluttertoast.showToast(
            msg: "تم انشاء حساب بنجاح",
          );
          isLoading(loading: false);
          return response;
        }
      }
    } catch(err) {
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
