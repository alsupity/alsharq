import 'package:alsharq/controller/lessons_controller.dart';
import 'package:alsharq/model/subject_model.dart';
import 'package:alsharq/model/lesson_model.dart';
import 'package:alsharq/model/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import 'education_tools.dart';
import '../util/app_consts.dart';
import '../util/widgets.dart';

class Lessons extends StatefulWidget {
  final TeacherModel teacherModel;
  final SubjectModel subjectModel;
  const Lessons(
      {super.key, required this.teacherModel, required this.subjectModel});

  @override
  State<Lessons> createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {
  LessonsController lessonsController = Get.put(LessonsController());

  @override
  void initState() {
    super.initState();
    lessonsController.getServerData(
      extra: "${widget.subjectModel.id}/${widget.teacherModel.id}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 15,
        backgroundColor: AppConsts.bgColor,
        title: Text("دروس المعلم ${widget.teacherModel.name}"),
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
            GetBuilder<LessonsController>(
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
                      childAspectRatio: 1.5,
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
                      final LessonModel item =
                          LessonModel.fromJson(controller.dataList![i]);
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Get.to(
                            () => EducationTools(
                              lessonModel: item,
                            ),
                            duration: 500.ms,
                            transition: Transition.rightToLeftWithFade,
                          );
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
