import 'package:flutter/material.dart';

class AppConsts {
  static const String androidLink = "https://play.google.com/store/apps/details?id=com.mhma.alsharq";
  static const String baseUrl = "https://sharq.afkarsoft.xyz";
  // static const String baseUrl = "http://172.16.4.249";
  static const String storageUrl = "/storage";
  static const String reserveCouponUrl = "/api/coupons/reserve/";

  static const String serverToken = "AAAAxI7JdhA:APA91bHwUcmS3U40QQ1ZHW1zabKEs0XZ4apekaN0vv6LLYjlMjje0zdIizJlfZxnPo2J-BQffRY_L3wvgxFnUwHKq1J3jjtmbOhlS6_5jsLZ9W3io1fG8GCT6SvJkoCFjhftPULsqi5l";
  static const String subscribeFCM = "subscribe";

  static const String fn = "Almaria";
  static const String fnDG = "DG";

  // assets path ______________________________________________
  static const String splash = "assets/images/splash.png";
  static const String icon = "assets/images/icon.png";
  static const String lock = "assets/images/lock.png";

  static const String home = "assets/images/icons/home.svg";
  static const String homeFill = "assets/images/icons/home_fill.svg";
  static const String menu = "assets/images/icons/menu.svg";
  static const String menuFill = "assets/images/icons/menu_fill.svg";
  static const String orders = "assets/images/icons/orders.svg";
  static const String ordersFill = "assets/images/icons/orders_fill.svg";
  static const String cart = "assets/images/icons/cart.svg";
  static const String cartFill = "assets/images/icons/cart_fill.svg";
  static const String user = "assets/images/icons/user.svg";
  static const String userFill = "assets/images/icons/user_fill.svg";
  static const String categories = "assets/images/icons/categories.svg";
  static const String categoriesFill = "assets/images/icons/categories_fill.svg";
  static const String gps = "assets/images/icons/gps.svg";
  static const String gpsFill = "assets/images/icons/gps_fill.svg";
  static const String location = "assets/images/icons/location.svg";
  static const String locationFill = "assets/images/icons/location_fill.svg";
  static const String bell = "assets/images/icons/bell.svg";
  static const String bellFill = "assets/images/icons/bell_fill.svg";
  static const String search = "assets/images/icons/search.svg";
  static const String searchFill = "assets/images/icons/search_fill.svg";
  static const String download = "assets/images/icons/download.svg";
  static const String downloadFill = "assets/images/icons/download_fill.svg";
  static const String favorite = "assets/images/icons/favorite.svg";
  static const String favoriteFill = "assets/images/icons/favorite_fill.svg";
  static const String phone = "assets/images/icons/phone.svg";
  static const String phoneFill = "assets/images/icons/phone_fill.svg";
  static const String settings = "assets/images/icons/settings.svg";
  static const String settingsFill = "assets/images/icons/settings_fill.svg";
  static const String telegram = "assets/images/icons/telegram.svg";
  static const String telegramFill = "assets/images/icons/telegram_fill.svg";


  static const String soundBuzz = "sounds/buzz.mp3";
  static const String soundCorrect = "sounds/correct.mp3";
  // end assets path __________________________________________

  // colors _________________________________________________
  static const Color primaryColor = Color(0xff15b0c9);
  static const Color secondaryColor = Color(0xffeb9f4a);
  static const MaterialColor tertiaryColor = Colors.grey;
  static const Color bgColor = Color(0xfff8ece3);
  static Map<int, Color> primarySwatchColor() {
    return {
      50: primaryColor.withOpacity(0.1),
      100:primaryColor.withOpacity(0.2),
      200:primaryColor.withOpacity(0.3),
      300:primaryColor.withOpacity(0.4),
      400:primaryColor.withOpacity(0.5),
      500:primaryColor.withOpacity(0.6),
      600:primaryColor.withOpacity(0.7),
      700:primaryColor.withOpacity(0.8),
      800:primaryColor.withOpacity(0.9),
      900:primaryColor.withOpacity(1.0),
    };
  }
  // end colors _____________________________________________

  // sizes __________________________________________________
  static const double xxlg = 20;
  static const double xlg = 18;
  static const double lg = 16;
  static const double normal = 14;
  static const double sm = 12;
  static const double xsm = 10;
  static const double xxsm = 8;
  // end sizes ______________________________________________
}
