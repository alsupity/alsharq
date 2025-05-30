import 'package:alsharq/model/education_tool_model.dart';
import 'package:alsharq/model/lesson_model.dart';
import 'package:alsharq/run_file/pdf_reader.dart';
import 'package:alsharq/run_file/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../controller/education_tools_controller.dart';
import '../util/app_consts.dart';
import '../util/widgets.dart';

class EducationTools extends StatefulWidget {
  final LessonModel lessonModel;
  const EducationTools({super.key, required this.lessonModel});

  @override
  State<EducationTools> createState() => _EducationToolsState();
}

class _EducationToolsState extends State<EducationTools> {
  EducationToolsController educationToolsController =
      Get.put(EducationToolsController());

  @override
  void initState() {
    super.initState();
    educationToolsController.getServerData(
      extra: widget.lessonModel.id.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 15,
        backgroundColor: AppConsts.bgColor,
        title: Text("ادوات تعليم ${widget.lessonModel.name}"),
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
            GetBuilder<EducationToolsController>(
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
                      childAspectRatio: 1,
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
                      final EducationToolModel item =
                          EducationToolModel.fromJson(controller.dataList![i]);
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          if (item.file != null) {
                            if (item.file!.toLowerCase().contains(".pdf")) {
                              Get.to(
                                () => PdfReader(
                                  educationToolModel: item,
                                ),
                                duration: 500.ms,
                                transition: Transition.rightToLeftWithFade,
                              );
                            } else if (item.file!
                                .toLowerCase()
                                .contains(".mp4")) {
                              Get.to(
                                () => VideoPlayerScreen(
                                  educationToolModel: item,
                                ),
                                duration: 500.ms,
                                transition: Transition.rightToLeftWithFade,
                              );
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: "لا يوجد ملف او الملف غير صحيح",
                            );
                          }
                          // Get.to(
                          //       () => Phases(subjectId: 1, subjectName: item.name,),
                          //   duration: 500.ms,
                          //   transition: Transition.rightToLeftWithFade,
                          // );
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
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                item.body ?? "",
                                style: TextStyle(
                                  fontSize: AppConsts.sm,
                                  color: AppConsts.tertiaryColor[700],
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
