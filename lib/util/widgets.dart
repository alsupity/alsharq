import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

import 'app_consts.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 5),
      color: Colors.white,
      child: Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text("لا توجد بيانات", style: TextStyle( fontSize: 16, color: Colors.black),),
          )
      ),
    );
  }
}

class ErrorData extends StatelessWidget {
  const ErrorData({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.white,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Text("خطا في قاعدة البيانات", style: TextStyle(color: Colors.red, fontSize: 16),),
        ),
      ),
    );
  }
}

class LoadingData extends StatelessWidget {

  final double size;

  LoadingData({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(
            strokeWidth: 5,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(AppConsts.primaryColor),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class CacheImg extends StatelessWidget {
  final String url;
  final BoxFit? boxFit;
  final imgWidth;
  double sizeCircleLoading = 30;
  CacheImg(this.url, {super.key, this.boxFit = BoxFit.cover, this.sizeCircleLoading = 30, this.imgWidth = null});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "${AppConsts.baseUrl}${AppConsts.storageUrl}/$url",
      // imageUrl: "$url",
      fit: boxFit,
      width: imgWidth,
      placeholder: (context, url) {
        return Container(
          padding: EdgeInsets.all(10),
          // height: sizeCircleLoading + 10.0,
          // width: sizeCircleLoading + 10.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: sizeCircleLoading,
                width: sizeCircleLoading,
                child: CircularProgressIndicator(strokeWidth: 2,),
              ),
            ],
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Image.asset("assets/images/splash.png");
      },
    );
  }
}

class CacheImgGallery extends StatelessWidget {
  final String url;
  final BoxFit boxFit;
  final Function? onClick;
  final Function? onLongClick;
  CacheImgGallery(this.url, {super.key, this.boxFit = BoxFit.cover, this.onClick, this.onLongClick});

  @override
  Widget build(BuildContext context) {
    // print("${v.storageLink}${imageName}");
    final rand = Random().nextInt(1000000).toString();
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: Hero(
            tag: "${url}_$rand",
            child: CacheImg(url, boxFit: boxFit),
          ),
        ),
        Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: TextButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))
              ),
              onPressed: (onClick == null)? () async {
                SwipeImageGallery(
                  context: context,
                  // children: [Image(image: AssetImage('assets/images/logo.png')),],
                  children: [
                    CacheImg(url, boxFit: BoxFit.contain),
                  ],
                  initialIndex: 0,
                  heroProperties: [ImageGalleryHeroProperties(tag: "${url}_$rand"),],
                  hideStatusBar: false,
                ).show();
              }: () => onClick,
              onLongPress: (onLongClick == null)? () async {
                SwipeImageGallery(
                  context: context,
                  // children: [Image(image: AssetImage('assets/images/logo.png')),],
                  children: [
                    CacheImg(url, boxFit: BoxFit.contain),
                  ],
                  initialIndex: 0,
                  heroProperties: [ImageGalleryHeroProperties(tag: "${url}_$rand"),],
                  hideStatusBar: false,
                ).show();
              }: () => onLongClick,
              child: Text(""),
            )
        ),
      ],
    );
  }
}

