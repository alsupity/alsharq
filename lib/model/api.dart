import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import '../util/app_consts.dart';

Dio dio = Dio();
class Api {

  Future<dynamic> get(String uri, {String extra = "", Map<String, dynamic>? params, Map<String, dynamic>? headers}) async {
    try {
      final String url = AppConsts.baseUrl + uri + extra;
      if(kDebugMode) print("get url: $url");
      final response = await dio.get(
        url,
        data: params,
        options: Options(
          headers: headers,
        ),
      );
      if(response.statusCode == 200) {
        return response.data;
      }
      else {
        if(kDebugMode) print("Err (${response.statusCode}): ${response.statusMessage}");
      }
    } catch(err) {
      if(kDebugMode) print("Err get data: $err");
    }
    return null;
  }

  Future<Map?> post(String uri, {String extra = "", Map<String, dynamic>? params, Map<String, dynamic>? headers, File? file,}) async {
    params = params??{};
    if(file != null) {
      params.addAll({
        "file": MultipartFile.fromFileSync(
          file.path,
          filename: basename(file.path),
        ),
      });
    }
    FormData formData = FormData.fromMap(params);
    try {
      print("url: ${AppConsts.baseUrl + uri + extra}");
      print("params: $params");
      final response = await dio.post(
        AppConsts.baseUrl + uri + extra,
        data: formData,
        options: Options(
          headers: headers,
        ),
      );
      print("response post: ${response.data}");
      if(response.statusCode != null) {
        if(response.statusCode! >= 200 && response.statusCode! < 300) {
          return response.data;
        }
        else {
          if(kDebugMode) print("Err (${response.statusCode}): ${response.statusMessage}");
        }
      }
    } catch(err) {
      if(kDebugMode) print("Err get data: $err");
    }
    return null;
  }

}