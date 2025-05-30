import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:alsharq/controller/phases_controller.dart';
import 'package:alsharq/model/phase_model.dart';
import 'package:alsharq/view/asks.dart';

import '../util/app_consts.dart';
import '../util/widgets.dart';

class Phases extends StatefulWidget {
  final String fromPage;
  final int subjectId;
  final String subjectName;

  const Phases({super.key, this.fromPage = "", required this.subjectId, required this.subjectName});

  @override
  State<Phases> createState() => _PhasesState();
}

class _PhasesState extends State<Phases> {
  PhasesController phasesController = Get.put(PhasesController());

  @override
  void initState() {
    super.initState();
    phasesController.tmpData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // titleSpacing: 15,
        backgroundColor: AppConsts.bgColor,
        title: Text("اختر مرحلة من مادة ${widget.subjectName} "),
      ),
      body: Center(
        child: GetBuilder<PhasesController>(builder: (controller) {
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
                crossAxisCount: 3,
                // childAspectRatio: 0.9,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              scrollDirection: Axis.vertical,
              // physics: NeverScrollableScrollPhysics(),
              // shrinkWrap: true,
              padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
              itemCount: controller.dataList!.length,
              itemBuilder: (context, int i) {
                final PhaseModel item = PhaseModel.fromJson(controller.dataList![i]);
                ButtonStyle buttonStyle = ElevatedButton.styleFrom();
                if (i == 0 || item.status != null) {
                  buttonStyle = ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    backgroundColor: AppConsts.primaryColor,
                    surfaceTintColor: AppConsts.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 2,
                  );
                } else {
                  buttonStyle = ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                  );
                }
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 0, left: 0, right: 0, bottom: 0,
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          Get.to(() => Asks(
                            phaseIndex: i,
                            subjectName: widget.subjectName,
                          ));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppConsts.fnDG,
                                fontSize: (item.name.length > 3)? AppConsts.normal: MediaQuery.of(context).size.width * 0.12,
                              ),
                            ),
                            RatingBar.builder(
                              initialRating: item.rate / 20,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              glow: false,
                              ignoreGestures: true,
                              itemSize: MediaQuery.of(context).size.width * 0.045,
                              itemPadding: EdgeInsets.symmetric(horizontal: 1),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: AppConsts.secondaryColor,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ],
                        ),
                      ).animate().scale(duration: 500.ms, begin: Offset(0, 0), end: Offset(1, 1)),
                    ),
                    if (i != 0 && item.status == null)
                      Positioned(
                        top: 0, left: 0, right: 0, bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppConsts.tertiaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(AppConsts.lock, height: 60, width: 60,),
                        ),
                      ),
                  ],
                );
              },
            );
          }
        }),
      ),
    );
  }
}

