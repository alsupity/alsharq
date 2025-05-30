import 'package:alsharq/view/departments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:alsharq/controller/countries_controller.dart';
import 'package:alsharq/model/countries_model.dart';
import 'package:alsharq/util/app_consts.dart';
import 'package:alsharq/util/app_funs.dart';
import 'package:alsharq/util/widgets.dart';
import 'package:alsharq/view/classes.dart';

class Countries extends StatefulWidget {
  final String fromPage;
  const Countries({super.key, this.fromPage = ""});

  @override
  State<Countries> createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {

  CountriesController countriesController = Get.put(CountriesController());

  @override
  void initState() {
    super.initState();
    countriesController.getServerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 15,
        backgroundColor: AppConsts.bgColor,
        title: Text("اختر دولة "),
      ),
      body: Center(
        child: GetBuilder<CountriesController>(
          builder: (controller) {
            if(controller.loading == true) {
              return LoadingData();
            } else {
              if(controller.dataList == null) {
                return ErrorData();
              } else if(controller.dataList == []) {
                return EmptyData();
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                itemCount: controller.dataList!.length,
                itemBuilder: (context, int i) {
                  final CountryModel item = CountryModel.fromJson(controller.dataList![i]);
                  return TextButton(
                    style: ElevatedButton.styleFrom(
                      alignment: AlignmentDirectional.centerStart,
                      foregroundColor: AppConsts.tertiaryColor[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      GetStorage().write("country", item.toMap());
                      Get.to(
                        () => Departments(countryModel: item,),
                        duration: 500.ms,
                        transition: Transition.rightToLeftWithFade,
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: AppFuns.flag(item.code),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(item.name, style: TextStyle(fontSize: AppConsts.lg),),
                      ],
                    ),

                  ).animate()
                    .fadeIn(duration: (1000 + (i * 1000)).ms)
                    .slideX(duration: (500 + (i * 500)).ms, begin: 1, end: 0);
                },
                separatorBuilder: (context, int i) {
                  return Divider(height: 1, color: AppConsts.tertiaryColor[300]);
                },
              );
            }
          }
        ),
      ),
    );
  }

}
