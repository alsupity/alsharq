import 'package:alsharq/controller/coupons_controller.dart';
import 'package:alsharq/controller/teachers_controller.dart';
import 'package:alsharq/model/subject_model.dart';
import 'package:alsharq/model/teacher_model.dart';
import 'package:alsharq/util/app_vars.dart';
import 'package:alsharq/view/lessons.dart';
import 'package:alsharq/view/sign/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../util/app_consts.dart';
import '../util/widgets.dart';

class Teachers extends StatefulWidget {
  final SubjectModel subjectModel;
  const Teachers({super.key, required this.subjectModel});

  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  TeachersController teachersController = Get.put(TeachersController());
  CouponsController couponsController = Get.put(CouponsController());

  TextEditingController _txtCoupon = TextEditingController();

  @override
  void initState() {
    super.initState();
    teachersController.getServerData(extra: widget.subjectModel.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 15,
        backgroundColor: AppConsts.bgColor,
        title: Text("معلمون مادة ${widget.subjectModel.name}"),
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
            GetBuilder<TeachersController>(
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
                      crossAxisCount: 1,
                      childAspectRatio: 1.3,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 20,
                    ),
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 16),
                    itemCount: controller.dataList!.length,
                    itemBuilder: (context, int i) {
                      final TeacherModel item =
                          TeacherModel.fromJson(controller.dataList![i]);
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          print(
                              "GetStorage().read(user): ${GetStorage().read("user")}");
                          if (GetStorage().read("user") == null) {
                            Fluttertoast.showToast(
                              msg: "يجب عليك تسجيل الدخول اولا ...",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Get.to(SignIn());
                          } else {
                            await couponsController.getServerData(
                              extra:
                                  "${widget.subjectModel.id}/${item.id}/${AppVars.user!['id']}",
                            );
                            if (couponsController.enterState == 0) {
                              Fluttertoast.showToast(
                                msg: "تاكد من اتصال الانترنت",
                              );
                            } else if (couponsController.enterState == 1) {
                              Get.to(
                                () => Lessons(
                                  teacherModel: item,
                                  subjectModel: widget.subjectModel,
                                ),
                                duration: 500.ms,
                                transition: Transition.rightToLeftWithFade,
                              );
                            } else if (couponsController.enterState == 2) {
                              Get.defaultDialog(
                                titleStyle: TextStyle(fontSize: 14),
                                title: item.name,
                                content: TextFormField(
                                  controller: _txtCoupon,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: "ادخل الكوبون ...",
                                  ),
                                ),
                                confirm: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.24,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      Get.back();
                                      Get.to(
                                        () => Lessons(
                                          teacherModel: item,
                                          subjectModel: widget.subjectModel,
                                        ),
                                        duration: 500.ms,
                                        transition:
                                            Transition.rightToLeftWithFade,
                                      );
                                    },
                                    child: Text("موافق"),
                                  ),
                                ),
                                cancel: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.24,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () => Get.back(),
                                    child: Text("إلغاء"),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                color: Colors.grey,
                                child: CacheImg(
                                  "${item.image}",
                                  boxFit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: AppConsts.lg,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                          ],
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
