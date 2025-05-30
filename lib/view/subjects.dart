import 'package:alsharq/view/sign/sign_in.dart';
import 'package:alsharq/view/teachers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:alsharq/controller/notification_controller.dart';
import 'package:alsharq/controller/subjects_controller.dart';
import 'package:alsharq/model/subject_model.dart';
import 'package:alsharq/util/app_funs.dart';
import 'package:alsharq/util/app_vars.dart';
import 'package:alsharq/view/countries.dart';
import '../controller/start_controller.dart';
import '../model/class_model.dart';
import '../model/countries_model.dart';
import '../util/app_consts.dart';
import '../util/widgets.dart';

class Subjects extends StatefulWidget {
  final String fromPage;

  const Subjects({super.key, this.fromPage = ""});

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  SubjectsController subjectsController = Get.put(SubjectsController());
  StartController startController = Get.put(StartController());

  @override
  void initState() {
    super.initState();

    AppVars.country = CountryModel.fromJson(GetStorage().read("country"));
    AppVars.clas = ClassModel.fromJson(GetStorage().read("clas"));
    startController.fToast = FToast();
    startController.fToast.init(context);
    subjectsController.getServerData();
  }

  DateTime timeBckPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBckPressed);
        final isExitWarning = difference >= Duration(seconds: 2);
        timeBckPressed = DateTime.now();
        if (isExitWarning) {
          await Fluttertoast.showToast(
            msg: "انقر مرة اخرى للخروج",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.5),
            textColor: Colors.white,
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 15,
          backgroundColor: AppConsts.bgColor,
          title: Text("اختر المادة الدراسية "),
          actions: [
            // IconButton(
            //   onPressed: () {},
            //   icon: SvgPicture.asset(AppConsts.settingsFill, width: 24, height: 24, color: AppConsts.primaryColor,),
            // ),
            if (AppVars.user != null)
              Container(
                width: 85,
                padding: EdgeInsetsDirectional.only(end: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    Get.to(() => SignIn());
                  },
                  child: Text(
                    "تسجيل خروج",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (AppFuns.isStartup())
                Container(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppConsts.tertiaryColor[300]!),
                      ),
                    ),
                    onPressed: () {
                      NotificationController.createNotification(
                          title: "My Tile", body: "My Body");
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: AppFuns.flag(AppVars.country!.code),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(child: Text(AppVars.clas!.name)),
                        SizedBox(
                          height: 35,
                          width: 65,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0),
                            ),
                            onPressed: () {
                              Get.to(() => Countries());
                            },
                            child: Text(
                              "تغيير",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              GetBuilder<SubjectsController>(builder: (controller) {
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
                      // childAspectRatio: 0.9,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 16),
                    itemCount: controller.dataList!.length,
                    itemBuilder: (context, int i) {
                      final SubjectModel item =
                          SubjectModel.fromJson(controller.dataList![i]);
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Get.to(
                            () => Teachers(subjectModel: item),
                            duration: 500.ms,
                            transition: Transition.rightToLeftWithFade,
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                child: CacheImg(
                                  "${item.image}",
                                  boxFit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Text(item.name),
                            Text(
                              item.desc ?? "",
                              style: TextStyle(
                                fontSize: AppConsts.sm,
                                color: AppConsts.tertiaryColor[700],
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
              }),
            ],
          ),
        ),
      ),
    );
  }
}
