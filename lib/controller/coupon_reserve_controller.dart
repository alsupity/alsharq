import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../util/app_vars.dart';

class CouponReserveController extends GetxController {
  static const String uri = "/api/coupons/reserve/";

  bool loading = false;

  isLoading({bool loading = true}) {
    this.loading = loading;
    update();
  }

  Future<bool> postServerData(
      {required String code,
      required int userId,
      required int teacherId,
      required int subjectId}) async {
    isLoading(loading: true);
    try {
      final Map<String, dynamic> requestBody = {
        "code": code,
        "user_id": userId,
        "teacher_id": teacherId,
        "subject_id": subjectId
      };
      final responseMap = await AppVars.api.post(
        uri,
        params: requestBody,
      );
      print("response $responseMap");
      if (responseMap != null && responseMap["error"] == null) {
        Fluttertoast.showToast(msg: "تم حجز الكوبون بنجاح");
        isLoading(loading: false);
        return true;
      } else {
        String errorMessage = "فشل حجز الكوبون";
        if (responseMap != null && responseMap["message"] != null) {
          errorMessage += ": ${responseMap["message"]}";
        }
        Fluttertoast.showToast(msg: errorMessage);
        isLoading(loading: false);
        return false;
      }
    } catch (err) {
      if (kDebugMode) print("err $uri: $err");
      Fluttertoast.showToast(
        msg: "فشل حجز الكوبون: ${err}",
      );
      isLoading(loading: false);
      return false;
    }
  }
}
