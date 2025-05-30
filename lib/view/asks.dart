import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:alsharq/controller/asks_controller.dart';
import 'package:alsharq/controller/phases_controller.dart';
import 'package:alsharq/model/ask_model.dart';
import 'package:alsharq/model/phase_model.dart';

import '../util/app_consts.dart';
import '../util/widgets.dart';

import 'ask_widgets/ask_options.dart';

class Asks extends StatefulWidget {
  final String fromPage;

  // final PhasesController phasesController;
  final int phaseIndex;

  // final int phaseId;
  // final String phaseName;
  final String subjectName;
  final bool showInfoDialog;

  // final PhaseModel phaseModel;

  const Asks({
    super.key,
    this.fromPage = "",
    required this.phaseIndex,
    /* required this.phaseId, required this.phaseName, required this.phaseModel, */ required this.subjectName,
    this.showInfoDialog = true,
    /* required this.phasesController */
  });

  @override
  State<Asks> createState() => _AsksState();
}

class _AsksState extends State<Asks> {
  PhasesController phasesController = Get.find();
  AsksController asksController = Get.put(AsksController());

  late PhaseModel phaseModel;

  @override
  void initState() {
    super.initState();

    phaseModel = PhaseModel.fromJson(phasesController.dataList![widget.phaseIndex]);

    asksController.tmpData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showInfoDialog == true) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.infoReverse,
          animType: AnimType.rightSlide,
          title: '',
          desc: ' لتتجاوز هذه المرحلة يجب ان تحصل على معدل اكبر من او يساوي ${phaseModel.overrideRate}% ',
          descTextStyle: TextStyle(fontSize: AppConsts.lg),
          btnOkText: "موافق",
          btnOkOnPress: () {},
        ).show();
      }
    });
  }

  @override
  void dispose() {
    asksController.pageController.dispose();
    super.dispose();
  }

  bool canPop = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = await AwesomeDialog(
          context: context,
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
          reverseBtnOrder: true,
          autoDismiss: false,
          onDismissCallback: (DismissType dismissType) {
            print("onDismissCallback: ${dismissType.name}");
          },
          dialogType: DialogType.question,
          animType: AnimType.rightSlide,
          title: '',
          desc: ' هل انت متاكد من انهاء هذه المرحلة؟ ',
          descTextStyle: TextStyle(fontSize: AppConsts.lg),
          btnOkText: "نعم",
          btnCancelText: "لا",
          btnOkOnPress: () {
            print("btnOkOnPress");
            Get.back(result: true);
          },
          btnCancelOnPress: () {
            print("btnCancelOnPress");
            Get.back(result: false);
          },
        ).show();
        if (exit == true) return true;
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          // titleSpacing: 15,
          backgroundColor: AppConsts.bgColor,
          title: Text("اسئلة المرحلة ${phaseModel.name} لمادة ${widget.subjectName}"),
        ),
        body: Center(
          child: GetBuilder<AsksController>(
            builder: (controller) {
              if (controller.loading == true) {
                return LoadingData();
              } else {
                if (controller.dataList == null) {
                  return ErrorData();
                } else if (controller.dataList == []) {
                  return EmptyData();
                }
                return Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 41,
                            height: 41,
                            child: SingleChildScrollView(
                              child: CircularPercentIndicator(
                                radius: 20.0,
                                lineWidth: 5.0,
                                percent: controller.rateCorrectAnswers / 100.0,
                                center: Text(
                                  controller.numCorrectAnswers.toString(),
                                  style: TextStyle(fontSize: AppConsts.lg, fontWeight: FontWeight.w700),
                                ),
                                progressColor: Colors.green,
                              ),
                            ),
                          ),
                          if (asksController.dataList != null)
                            SizedBox(
                              height: 30,
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  foregroundColor: AppConsts.tertiaryColor[800],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(99),
                                    side: BorderSide(color: AppConsts.tertiaryColor[800]!, width: 1),
                                  ),
                                ),
                                onPressed: () {},
                                child: FutureBuilder(
                                  future: Future.value(true),
                                  builder: (BuildContext context, AsyncSnapshot<void> snap) {
                                    if (!snap.hasData) {
                                      return Text("0");
                                    }
                                    return Text(
                                      "${asksController.pageController.page!.ceil() + 1} / ${asksController.dataList!.length}",
                                      style: TextStyle(
                                        fontSize: AppConsts.lg,
                                        height: 1,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          SizedBox(
                            width: 41,
                            height: 41,
                            child: SingleChildScrollView(
                              child: CircularPercentIndicator(
                                radius: 20.0,
                                lineWidth: 5.0,
                                percent: controller.rateWrongAnswers / 100.0,
                                center: Text(
                                  controller.numWrongAnswers.toString(),
                                  style: TextStyle(fontSize: AppConsts.lg, fontWeight: FontWeight.w700),
                                ),
                                progressColor: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: asksController.pageController,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.dataList!.length,
                        onPageChanged: (int i) {
                          if (kDebugMode) print("index is $i");
                        },
                        itemBuilder: (context, int i) {
                          final AskModel item = AskModel.fromJson(controller.dataList![i]);
                          final List options = jsonDecode(item.optionsJson);
                          print("options: ${options[0]["name"]}");
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.90,
                                // color: Color.fromRGBO(40 * item.id, 30 * item.id, 50 * item.id, 1.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.only(left: 0, right: 0),
                                      width: MediaQuery.of(context).size.width,
                                      constraints: BoxConstraints(
                                        minHeight: 80,
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(8),
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          item.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: AppConsts.lg,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Expanded(
                                      child: AskOptions(
                                        options: options,
                                        asksController: controller,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.88,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          surfaceTintColor: AppConsts.secondaryColor,
                        ),
                        onPressed: (controller.disableNextButton == true)
                            ? null
                            : () async {
                                if (asksController.dataList == null) return;
                                controller.changeDisableNextButton(true, 0);
                                if (asksController.pageController.page == (asksController.dataList!.length - 1)) {
                                  bool exit = false;

                                  if(controller.rateCorrectAnswers > phaseModel.rate) {
                                    // sqlite update to phase (rate)
                                  }

                                  if (controller.rateCorrectAnswers >= (phaseModel.overrideRate ?? 50)) {
                                    if(phaseModel.status == 1) {
                                      // sqlite update to current phase (status = 0)
                                      // and update to Next Phase (status = 1)
                                    }
                                    exit = await AwesomeDialog(
                                      context: context,
                                      dismissOnBackKeyPress: false,
                                      dismissOnTouchOutside: false,
                                      reverseBtnOrder: true,
                                      autoDismiss: false,
                                      onDismissCallback: (DismissType dismissType) {
                                        print("onDismissCallback: ${dismissType.name}");
                                      },
                                      dialogType: DialogType.success,
                                      animType: AnimType.rightSlide,
                                      title: 'تمت الاجابة عن جميع الاسئلة',
                                      body: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("عدد الاسئلة: ${controller.dataList!.length}"),
                                          Text(
                                              "عدد الاجابات الصحيحة: ${controller.numCorrectAnswers} (${controller.rateCorrectAnswers}%)"),
                                          Text(
                                              "عدد الاجابات الخاطئة: ${controller.numWrongAnswers} (${controller.rateWrongAnswers}%)"),
                                          Container(
                                            child: RatingBar.builder(
                                              initialRating: (controller.rateCorrectAnswers / 20),
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              glow: false,
                                              ignoreGestures: true,
                                              itemSize: 30,
                                              itemPadding: EdgeInsets.symmetric(horizontal: 1),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: AppConsts.secondaryColor,
                                              ),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      btnOkText: "التالي",
                                      btnCancelText: "خروج",
                                      btnOkOnPress: () {
                                        print("btnOkOnPress");
                                        Get.back(result: false);
                                      },
                                      btnCancelOnPress: () {
                                        print("btnCancelOnPress");
                                        Get.back(result: true);
                                      },
                                    ).show();
                                    if (exit == false) {
                                      print("Next Phase");
                                    }
                                  } else {
                                    exit = await AwesomeDialog(
                                      context: context,
                                      dismissOnBackKeyPress: false,
                                      dismissOnTouchOutside: false,
                                      reverseBtnOrder: true,
                                      autoDismiss: false,
                                      onDismissCallback: (DismissType dismissType) {
                                        print("onDismissCallback: ${dismissType.name}");
                                      },
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'تمت الاجابة عن جميع الاسئلة',
                                      body: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("عدد الاسئلة: ${controller.dataList!.length}"),
                                          Text(
                                              "عدد الاجابات الصحيحة: ${controller.numCorrectAnswers} (${controller.rateCorrectAnswers}%)"),
                                          Text(
                                              "عدد الاجابات الخاطئة: ${controller.numWrongAnswers} (${controller.rateWrongAnswers}%)"),
                                          Text(
                                            " لتتجاوز هذه المرحلة يجب ان تحصل على معدل اكبر من او يساوي ${phaseModel.overrideRate}% ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          Container(
                                            child: RatingBar.builder(
                                              initialRating: (controller.rateCorrectAnswers / 20),
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              glow: false,
                                              ignoreGestures: true,
                                              itemSize: 30,
                                              itemPadding: EdgeInsets.symmetric(horizontal: 1),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: AppConsts.secondaryColor,
                                              ),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      btnOkText: "اعادة المحاولة",
                                      btnCancelText: "خروج",
                                      btnOkOnPress: () {
                                        print("btnOkOnPress");
                                        Get.back(result: false);
                                      },
                                      btnCancelOnPress: () {
                                        print("btnCancelOnPress");
                                        Get.back(result: true);
                                      },
                                    ).show();
                                    if (exit == false) {
                                      print("Again");
                                      Get.off(
                                        () => Asks(
                                          phaseIndex: widget.phaseIndex,
                                          subjectName: widget.subjectName,
                                          showInfoDialog: false,
                                          // phasesController: widget.phasesController,
                                        ),
                                        preventDuplicates: false,
                                      );
                                    }
                                  }

                                  if (exit == true) Get.back();

                                  return;
                                }
                                await asksController.pageController.nextPage(duration: 500.ms, curve: Curves.ease);
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "الــتــالــي",
                              style: TextStyle(
                                color: (controller.disableNextButton == true) ? AppConsts.tertiaryColor[500] : Colors.black,
                                fontSize: AppConsts.xlg,
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: (controller.disableNextButton == true) ? AppConsts.tertiaryColor[500] : Colors.black,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
