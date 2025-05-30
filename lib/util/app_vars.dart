
import '../model/api.dart';
import '../model/db/db_helper.dart';
import '../model/countries_model.dart';
import '../model/class_model.dart';

class AppVars {
  static Map<String, dynamic>? user;
  static Api api = Api();
  static DbHelper dbHelper = DbHelper();
  static CountryModel? country;
  static ClassModel? clas;
}

