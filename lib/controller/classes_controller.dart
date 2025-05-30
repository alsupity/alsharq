import 'package:alsharq/model/class_model.dart';
import 'package:alsharq/model/countries_model.dart';
import 'package:alsharq/model/department_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../util/app_vars.dart';

class ClassesController extends GetxController {
  static const String uri = "/api/classes";
  static const String table = "classes";

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
    final CountryModel countryModel = CountryModel.fromJson(GetStorage().read("country"));
    final DepartmentModel departmentModel = DepartmentModel.fromJson(GetStorage().read("department"));
    print("$uri/${countryModel.id}/${departmentModel.id}");
    try {
      final responseMap = await AppVars.api.get(uri, extra: "/${countryModel.id}/${departmentModel.id}");
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
        "name": "الاول الابتدائي",
        "country_id": 1,
        "department_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 2,
        "name": "الثاني الابتدائي",
        "country_id": 1,
        "department_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 3,
        "name": "الثالث الابتدائي",
        "country_id": 1,
        "department_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 4,
        "name": "الرابع الابتدائي",
        "country_id": 1,
        "department_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 5,
        "name": "الخامس الابتدائي",
        "country_id": 1,
        "department_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 6,
        "name": "السادس الابتدائي",
        "country_id": 1,
        "department_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 7,
        "name": "الاول الاعدادي (السابع)",
        "country_id": 1,
        "department_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
      {
        "id": 8,
        "name": "الثاني الاعدادي (الثامن)",
        "country_id": 1,
        "department_id": 1,
        "deleted_at": null,
        "created_at": "2024-02-22T19:22:11",
        "updated_at": "2024-02-22T19:22:11",
      },
    ];
    isLoading(loading: false);
  }
}
