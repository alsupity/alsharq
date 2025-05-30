
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AppFuns {
  static flag(String alpha_2) {
    return Image.asset(
      'icons/flags/png100px/${alpha_2.toString().toLowerCase()}.png',
      package: 'country_icons',
      fit: BoxFit.fill,
    );
  }

  static bool isStartup() {
    return (GetStorage().read("country") != null && GetStorage().read("clas") != null);
  }

}
