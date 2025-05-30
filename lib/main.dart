import 'package:alsharq/util/app_vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:alsharq/util/init.dart';
import 'package:alsharq/util/app_consts.dart';
import 'package:alsharq/start.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await Init.init();
  AppVars.user = GetStorage().read("user");
  print("user: ${AppVars.user}");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Learning',
      debugShowCheckedModeBanner: false,
      builder: FToastBuilder(),
      navigatorKey: navigatorKey,
      theme: ThemeData(
        fontFamily: AppConsts.fn,
        useMaterial3: true,
        // primaryColor: MaterialColor(v.primarycolor.value, v.primary_swatch_color),
        // canvasColor: Color(0xfff3f3f3),
        // canvasColor: v.tertiarycolor[600],
        scaffoldBackgroundColor: AppConsts.bgColor,
        colorSchemeSeed: AppConsts.primaryColor,
        // primarySwatch: MaterialColor(v.primarycolor.value, v.primary_swatch_color),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: AppConsts.fn,
              bodyColor: AppConsts.tertiaryColor[800],
              displayColor: AppConsts.tertiaryColor[800],
            ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding:
              EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            gapPadding: 0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppConsts.tertiaryColor[300]!,
            ),
            borderRadius: BorderRadius.circular(4),
            gapPadding: 0,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppConsts.primaryColor,
            ),
            borderRadius: BorderRadius.circular(4),
            gapPadding: 0,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            gapPadding: 0,
            borderSide: BorderSide(
              color: AppConsts.tertiaryColor[500]!,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            gapPadding: 0,
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: Colors.red,
            ),
            gapPadding: 0,
          ),
          labelStyle: TextStyle(
            height: 1,
          ),
          hintStyle: TextStyle(
            height: 1.5,
            color: AppConsts.tertiaryColor[400],
          ), // height: 2.5
          helperStyle: TextStyle(
            height: 1.4,
          ),
          helperMaxLines: 3,
          fillColor: Colors.white,
          filled: true,
          errorStyle: TextStyle(height: 0.8, color: Colors.red),
        ),
        appBarTheme: AppBarTheme(
          titleSpacing: -5,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          titleTextStyle: TextStyle(
            fontSize: AppConsts.xlg,
            fontFamily: AppConsts.fn,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppConsts.secondaryColor,
            surfaceTintColor: AppConsts.secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
        ),
      ),

      // arabic __________________________________________
      locale: Locale("ar"),
      fallbackLocale: Locale("ar"),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("ar"),
        // const Locale('en'),
      ],
      // end arabic __________________________________________

      home: Start(),
    );
  }
}
