// import 'package:another_flushbar/flushbar.dart';
import 'dart:math';

import 'package:ahshiaka/bloc/layout_cubit/bottom_nav_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/view/auth/auth_screen.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
import 'package:toast/toast.dart';

import '../shared/cash_helper.dart';
import '../shared/components.dart';
import '../view/layout/bottom_nav_screen/bottom_nav_tabs_screen.dart';
import 'app_ui.dart';

class AppUtil{

  static double responsiveHeight (context)=> MediaQuery.of(context).size.height;
  static double responsiveWidth (context)=> MediaQuery.of(context).size.width;
  static mainNavigator (context,screen)=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  static removeUntilNavigator (context,screen)=> Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => screen), (route) => false);
  static replacementNavigator (context,screen)=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => screen));


  static bool rtlDirection(context){
    return EasyLocalization.of(context)!.currentLocale==const Locale('en')?false:true;
  }

  static bool isEmailValidate(email){
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }


// Show dialog
  static dialog(context,title,List<Widget> dialogBody,{barrierDismissible=true,alignment,color})async{
    return await showGeneralDialog(context: context,barrierDismissible: barrierDismissible,barrierLabel: "", pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return AlertDialog(
      alignment: alignment??Alignment.center,
      backgroundColor: color??AppUI.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
      ),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 10,
                    child: CustomText(text: title,fontWeight: FontWeight.bold,)),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                      child: const Icon(Icons.close)),
                )
              ],
            ),
            const SizedBox(height: 10,),
            const Divider()
          ],
        ),
      ),
      insetPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.all(5),
      contentPadding: EdgeInsets.zero,

      content: Builder(
          builder: (context) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListBody(
                  children: dialogBody,
                ),
              ),
            );
          }
      ),
    ); });
  }


// Show dialog
  static dialog2(context,title,List<Widget> dialogBody,{barrierDismissible=true})async{
    return await showDialog(context: context,barrierDismissible: barrierDismissible, builder: (context){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: title is Widget?title:CustomText(text: title,textAlign: TextAlign.center,fontWeight: FontWeight.bold,),
            titlePadding: title is String && title.isEmpty? const EdgeInsets.all(0):null,
            content: SingleChildScrollView(
              child: ListBody(
                children: dialogBody,
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              height: 35,width: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
                border: Border.all(color: AppUI.whiteColor)
              ),
              child: Icon(Icons.close,color: AppUI.whiteColor,),
            ),
          )
        ],
      );
    });
  }
//Get current location
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<List> getAddress (location) async {

    geocoding.Placemark placemark = await getPlaceMark(location);

    String place = (placemark.country!.isNotEmpty ? '${placemark.country!}, ' : '') +
        (placemark.administrativeArea!.isNotEmpty ? '${placemark.administrativeArea!}, ' : '') +
        (placemark.subLocality!.isNotEmpty ? '${placemark.subLocality!}, ' : '') +
           (placemark.street!.isNotEmpty ? '${placemark.street!} ' : ''
        );

    place = place.isNotEmpty ? place.replaceFirst(', ', '', place.lastIndexOf(', ')) : '';

    return [placemark.postalCode,place,placemark.isoCountryCode];

  }


  static Future<geocoding.Placemark> getPlaceMark (latLng,) async {

    try {

      List<geocoding.Placemark> placeMarks = await geocoding.placemarkFromCoordinates(
        latLng.latitude, latLng.longitude,
        localeIdentifier: await CashHelper.getSavedString("lang", "")
      );

      geocoding.Placemark placemark = placeMarks[0];

      return placemark;

    }catch (e) {

      return Future.error(e);

    }

  }

  // toast msg
static successToast(context,msg, {type=""}) async {
  // ToastContext().init(context);
  // Toast.show(msg,duration: 3,gravity: 1,textStyle: TextStyle(color: AppUI.whiteColor),backgroundColor: AppUI.activeColor,);
  await dialog2(context, "", [
    CircleAvatar(
      radius: 35,
      backgroundColor: AppUI.mainColor,
      child: Icon(Icons.check,size: 40,color: AppUI.whiteColor,),
    ),
    const SizedBox(height: 20,),
    CustomText(text: "success".tr(),fontWeight: FontWeight.w600,textAlign: TextAlign.center,),
    const SizedBox(height: 20,),
    CustomText(text: msg,textAlign: TextAlign.center,),
    const SizedBox(height: 20,),
    if(type == "cart")
      Column(
        children: [
          const SizedBox(height: 20,),
          CustomButton(text: 'checkout'.tr(),onPressed: () {
            Navigator.of(context,rootNavigator: true).pop();
            BottomNavCubit.get(context).setCurrentIndex(2);
            removeUntilNavigator(context, const BottomNavTabsScreen());
          },),
          const SizedBox(height: 15,),
          GestureDetector(
            onTap: (){
              BottomNavCubit.get(context).setCurrentIndex(0);
              AppUtil.removeUntilNavigator(context, const BottomNavTabsScreen());
            },
              child: CustomText(text: "continueShopping".tr(),textAlign: TextAlign.center,))
        ],
      ),

  ]);
}

static errorToast(context,msg,{type=""}) async {
  // ToastContext().init(context);
  // Toast.show(msg,duration: 3,gravity: 1,textStyle: TextStyle(color: AppUI.whiteColor),backgroundColor: AppUI.errorColor);
  await dialog2(context, "", [
    CircleAvatar(
      radius: 35,
      backgroundColor: AppUI.errorColor,
      child: CircleAvatar(
        radius: 32,
        backgroundColor: AppUI.whiteColor,
        child: Icon(Icons.close,size: 40,color: AppUI.errorColor,),
      ),
    ),
    const SizedBox(height: 20,),
    CustomText(text: "failed".tr(),fontWeight: FontWeight.w600,textAlign: TextAlign.center,),
    const SizedBox(height: 20,),
    CustomText(text: msg,textAlign: TextAlign.center,),
    const SizedBox(height: 20,),
    if(type=="login")
    CustomButton(text: "signin".tr(),onPressed: (){
      Navigator.of(context,rootNavigator: true).pop();
      mainNavigator(context, const AuthScreen(initialIndex: 1));
    },),
    if(type=="login")
      const SizedBox(height: 20,),
  ]);
}

  static Future<void> initNotification() async {
    // FirebaseMessaging messaging = FirebaseMessaging.instance;
    // messaging.requestPermission();
    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
  }

  static Future<void> showPushNotification(context) async {

    // FirebaseMessaging.onMessage.listen((event) async {
    //   Flushbar(
    //     message: event.notification!.body ,
    //     title: event.notification!.title,
    //     messageColor: Colors.white,
    //     titleColor: Colors.white,
    //     textDirection: ui.TextDirection.rtl,
    //     padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 20),
    //     // maxWidth: double.infinity,
    //     isDismissible: true,
    //     duration: const Duration(seconds: 5),
    //     flushbarPosition: FlushbarPosition.TOP,
    //     barBlur: .1,
    //     backgroundColor: AppUI.mainColor,
    //     borderColor: Colors.white,
    //     margin: const EdgeInsets.all(8),
    //     borderRadius: BorderRadius.circular(8),
    //   ).show(context);
      // await HomeCubit.get(context).notification();
    // });
  }

  static getToken() async {
    // String? fcm = await FirebaseMessaging.instance.getToken();
    // return fcm;
  }

  static calculateTax(total){
    double tax = total - (total/1.15);
    tax = roundDouble(tax,2);
    return [tax,roundDouble(total+tax, 2)];
  }

  static double roundDouble(double value, int places){
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}