import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../util/app_vars.dart';

class CountriesData extends GetxController {
  static const String uri = "/api/countries";
  static const String table = "countries";

  fromServer() async {
    List<Map<String, dynamic>>? created;
    List<Map<String, dynamic>>? updated;
    final String createdAtMaxDate = await AppVars.dbHelper.maxDate(created_at: true, table: table);
    final String updatedAtMaxDate = await AppVars.dbHelper.maxDate(created_at: false, table: table);
    try {
      final response = await AppVars.api.get(uri, extra: "?created_at=$createdAtMaxDate&updated_at=$updatedAtMaxDate");
      if (response != null) {
        if(response is Map) {
          created = response["created"];
          for(final Map<String, dynamic> element in created!) {
            AppVars.dbHelper.insert(table: table, obj: element);
          }
          updated = response["updated"];
          for(final Map<String, dynamic> element in updated!) {
            AppVars.dbHelper.update(table: table, obj: element, condition: " id = ${element['id']} ");
          }
        }
      }
    } catch(err) {
      if (kDebugMode) print("err $uri: $err");
    }
    if (kDebugMode) print("dataList $uri: $created");
  }
  fromServerCreated() async {
    List<Map<String, dynamic>>? created;
    final String createdAtMaxDate = await AppVars.dbHelper.maxDate(created_at: true, table: table);
    try {
      final response = await AppVars.api.get(uri, extra: "?created_at=$createdAtMaxDate");
      if (response != null) {
        if(response is Map) {
          created = response["created"];
          for(final Map<String, dynamic> element in created!) {
            AppVars.dbHelper.insert(table: table, obj: element);
          }
        }
      }
    } catch(err) {
      if (kDebugMode) print("err $uri: $err");
    }
    if (kDebugMode) print("dataList $uri: $created");
  }
  fromServerUpdated() async {
    List<Map<String, dynamic>>? updated;
    final String updatedAtMaxDate = await AppVars.dbHelper.maxDate(created_at: false, table: table);
    try {
      final response = await AppVars.api.get(uri, extra: "?updated_at=$updatedAtMaxDate");
      if (response != null) {
        if(response is Map) {
          updated = response["updated"];
          for(final Map<String, dynamic> element in updated!) {
            AppVars.dbHelper.update(table: table, obj: element, condition: " id = ${element['id']} ");
          }
        }
      }
    } catch(err) {
      if (kDebugMode) print("err $uri: $err");
    }
    if (kDebugMode) print("dataList $uri: $updated");
  }



  prepare() async {
    final int count = await AppVars.dbHelper.countRows(table: table, condition: "1");
    if(count > 0) {
      fromServer();
    } else {
      fromServerCreated();
    }
  }

}
