import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';
import 'package:alsharq/util/app_consts.dart';
import 'package:alsharq/view/countries.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {

  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        key: introKey,
        // globalBackgroundColor: Colors.white,
        pages: [
          myPageViewModel(
              img: "1.json",
              title: "التعلم الذكي",
              body: "بكل بساطة اختبر معلوماتك الثقافية في لعديد من المواضيع المختلفة"
          ),
          myPageViewModel(
              img: "2.png",
              title: "",
              body: ""
          ),
          myPageViewModel(
            img: "3.png",
            title: "",
            body: "",
          ),
          myPageViewModel(
            img: "4.png",
            title: "",
            body: "",
          ),
          myPageViewModel(
            img: "last.png",
            title: "البدء في التطبيق (انقر على ابدا)",
            body: "اختر الدولة والمرحلة الدراسية المناسبة من الواجهة التالية",
          ),
        ],
        onDone: () {
          Get.offAll(() => Countries());
        },
        // onSkip: () {
        //   // You can also override onSkip callback
        // },
        showBackButton: false,
        showSkipButton: true,
        skip: const Text("تخطي",),
        next: const Icon(Icons.navigate_next,),
        done: const Text("ابدا", style: TextStyle(fontWeight: FontWeight.w600,)),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: AppConsts.secondaryColor,
            color: Color(0xffcccccc),
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)
            )
        ),
      ),
    );
  }
  PageViewModel myPageViewModel({required String img, required String title, required String body, bool islast = false}){
    img = "assets/images/intro/$img";
    return PageViewModel(
      title: "",
      body: "",
      image: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: Get.height * 0.12),
          if(title == "" && body == "")
            SizedBox(height: Get.height * 0.08),
          SizedBox(
            width: Get.width * 0.8,
            height: Get.height * 0.5,
            child: (img.contains("json"))?
              Lottie.asset(img) :
              Image.asset(img, fit: BoxFit.contain),
          ),
          if(title != "")
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              )
          ),
          if(title != "")
            SizedBox(height: Get.height * 0.02,),
          if(body != "")
            Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              body,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.5,
                fontSize: 16,
              ),
            ),
          ),
          if(body != "")
            SizedBox(height: Get.height * 0.05,),
          if(islast == true)
            SizedBox(
              height: 60,
              width: Get.width * 0.4,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                ),
                child: Text(
                  "ابــــــدا",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: AppConsts.xlg + 2
                  ),
                ),
                onPressed: () async {
                  Get.offAll(() => Countries());
                },
              ),
            ),
        ],
      ),
      footer: Text(""),
      decoration: PageDecoration(
          fullScreen: true
      ),
    );
  }
}
