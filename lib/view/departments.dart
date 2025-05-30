import 'package:alsharq/controller/Departments_controller.dart';
import 'package:alsharq/model/countries_model.dart';
import 'package:alsharq/model/department_model.dart';
import 'package:alsharq/model/lesson_model.dart';
import 'package:alsharq/model/teacher_model.dart';
import 'package:alsharq/view/classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../util/app_consts.dart';
import '../util/widgets.dart';

class Departments extends StatefulWidget {
  final CountryModel countryModel;
  const Departments({super.key, required this.countryModel});

  @override
  State<Departments> createState() => _DepartmentsState();
}

class _DepartmentsState extends State<Departments> {
  DepartmentsController departmentsController =
      Get.put(DepartmentsController());

  @override
  void initState() {
    super.initState();
    departmentsController.getServerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 15,
        backgroundColor: AppConsts.bgColor,
        title: Text("اختار القسم"),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: SvgPicture.asset(AppConsts.settingsFill, width: 24, height: 24, color: AppConsts.primaryColor,),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GetBuilder<DepartmentsController>(
              builder: (controller) {
                if (controller.loading == true) {
                  return LoadingData();
                } else {
                  if (controller.dataList == null) {
                    return ErrorData();
                  } else if (controller.dataList == []) {
                    return EmptyData();
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        left: 12, right: 12, top: 12, bottom: 12),
                    itemCount: controller.dataList!.length,
                    itemBuilder: (context, int i) {
                      final DepartmentModel item =
                          DepartmentModel.fromJson(controller.dataList![i]);
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          GetStorage().write("department", item.toMap());
                          print("item.toMap(): ${item.toMap()}");
                          Get.to(
                            () => Classes(
                              departmentModel: item,
                            ),
                            duration: 500.ms,
                            transition: Transition.rightToLeftWithFade,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            item.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppConsts.xlg,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ).animate().scale(
                          duration: 1000.ms,
                          begin: Offset(0, 0),
                          end: Offset(1, 1));
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
