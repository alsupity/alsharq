import 'package:alsharq/controller/coupon_reserve_controller.dart';
import 'package:alsharq/util/app_vars.dart'; // For AppVars.userData
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
  final CouponReserveController _couponReserveController = Get.put(CouponReserveController());
  final TextEditingController _couponCodeController = TextEditingController();
  // For storing the current user ID, assuming it's accessible via AppVars.userData
  // You might need to adjust how user_id is fetched based on your app's auth structure.
  // This is a placeholder, ensure AppVars.userData and AppVars.userData['id'] are valid.
  int? userId;

  @override
  void initState() {
    super.initState();
    // Fetch user ID in initState
    // This assumes AppVars.userData is a Map<String, dynamic> containing user info including 'id'
    // and that AppVars.isLogin is a boolean indicating login status.
    if (AppVars.isLogin && AppVars.userData != null && AppVars.userData!['id'] != null) {
      userId = AppVars.userData!['id'];
    } else {
      // Handle cases where user is not logged in or ID is not available,
      // though the coupon API requires user_id.
      // For now, we'll proceed assuming userId will be available if needed.
      print("User ID not found, coupon reservation might fail.");
    }
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
                          _handleLessonTap(item);
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

  void _handleLessonTap(LessonModel lessonItem) {
    _couponCodeController.clear(); // Clear previous text
    if (userId == null) {
        // If userId is null, perhaps directly navigate or show an error
        // For now, let's print a message and navigate directly
        print("User ID is null. Skipping coupon dialog.");
        Get.to(
          () => EducationTools(lessonModel: lessonItem),
          duration: 500.ms,
          transition: Transition.rightToLeftWithFade,
        );
        return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("إدخال كوبون الخصم"),
          content: TextField(
            controller: _couponCodeController,
            decoration: InputDecoration(hintText: "ادخل كود الكوبون"),
            keyboardType: TextInputType.text,
          ),
          actions: <Widget>[
            TextButton(
              child: Text("تخطي"),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Get.to(
                  () => EducationTools(lessonModel: lessonItem),
                  duration: 500.ms,
                  transition: Transition.rightToLeftWithFade,
                );
              },
            ),
            TextButton(
              child: Text("حجز"),
              onPressed: () async {
                final String code = _couponCodeController.text.trim();
                if (code.isNotEmpty) {
                  // Ensure userId is not null before proceeding
                  if (userId == null) {
                      print("User ID is null, cannot reserve coupon.");
                      // Optionally show a toast or message to the user
                      return;
                  }
                  bool success = await _couponReserveController.postServerData(
                    code: code,
                    userId: userId!, // Use the userId fetched in initState
                    teacherId: widget.teacherModel.id,
                    subjectId: widget.subjectModel.id,
                  );
                  if (success) {
                    Navigator.of(context).pop(); // Close dialog
                    Get.to(
                      () => EducationTools(lessonModel: lessonItem),
                      duration: 500.ms,
                      transition: Transition.rightToLeftWithFade,
                    );
                  } else {
                    // Error toast is shown by the controller
                    // Dialog remains open for user to try again or skip
                  }
                } else {
                  // Show some validation for empty code if desired
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("الرجاء إدخال كود الكوبون")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
