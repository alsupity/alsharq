import 'package:alsharq/model/department_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:alsharq/view/subjects.dart';

import '../controller/classes_controller.dart';
import '../model/class_model.dart';
import '../util/app_consts.dart';
import '../util/widgets.dart';

class Classes extends StatefulWidget {
  final String fromPage;
  final DepartmentModel departmentModel;

  const Classes({super.key, this.fromPage = "", required this.departmentModel});

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  ClassesController countriesController = Get.put(ClassesController());

  @override
  void initState() {
    super.initState();
    countriesController.getServerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // titleSpacing: 15,
        backgroundColor: AppConsts.bgColor,
        title: Text("اختر المرحلة الدراسية "),
      ),
      body: Center(
        child: GetBuilder<ClassesController>(builder: (controller) {
          if (controller.loading == true) {
            return LoadingData();
          } else {
            if (controller.dataList == null) {
              return ErrorData();
            } else if (controller.dataList == []) {
              return EmptyData();
            }
            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              itemCount: controller.dataList!.length,
              itemBuilder: (context, int i) {
                final ClassModel item = ClassModel.fromJson(controller.dataList![i]);

                return SizedBox(
                  height: 50,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: AlignmentDirectional.centerStart,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      GetStorage().write("clas", item.toMap());
                      Get.offAll(
                        () => Subjects(),
                        duration: 500.ms,
                        transition: Transition.rightToLeftWithFade,
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 16),
                        Row(
                          children: [
                            Icon(Icons.arrow_forward_ios_outlined, size: 18,),
                            Text(
                              "  ${item.name}",
                              style: TextStyle(
                                fontSize: AppConsts.lg,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: (500 + (i * 500)).ms)
                    .slideX(duration: (250 + (i * 250)).ms, begin: 1, end: 0);
              },
              separatorBuilder: (context, int i) {
                return Divider(height: 1, color: AppConsts.tertiaryColor[300]);
              },
            );
          }
        }),
      ),
    );
  }

}
