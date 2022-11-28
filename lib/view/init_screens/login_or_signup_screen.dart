import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:ahshiaka/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../auth/auth_screen.dart';
import '../layout/bottom_nav_screen/bottom_nav_tabs_screen.dart';

class LoginOrSignupScreen extends StatefulWidget {
  const LoginOrSignupScreen({Key? key}) : super(key: key);

  @override
  _LoginOrSignupScreenState createState() => _LoginOrSignupScreenState();
}

class _LoginOrSignupScreenState extends State<LoginOrSignupScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Image.asset(
              "${AppUI.imgPath}group.png",
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(SizeConfig.padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "welcomeToAlshiaka".tr(),
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.titleFontSize * 1.3,
                      ),
                      // SizedBox(
                      //   height: SizeConfig.padding / 2,
                      // ),
                      // CustomText(
                      //   text: "welcomeToAlshiaka".tr(),
                      //   fontSize: SizeConfig.textFontSize,
                      //   color: AppUI.shimmerColor,
                      // ),
                      SizedBox(
                        height: SizeConfig.padding,
                      ),
                      CustomButton(
                        text: "signup".tr(),
                        onPressed: () {
                          AppUtil.mainNavigator(
                              context, const AuthScreen(initialIndex: 0));
                        },
                      ),
                      SizedBox(
                        height: SizeConfig.padding,
                      ),
                      CustomButton(
                        text: "signin".tr(),
                        borderColor: AppUI.mainColor,
                        color: AppUI.whiteColor,
                        textColor: AppUI.mainColor,
                        onPressed: () {
                          AppUtil.mainNavigator(
                              context, const AuthScreen(initialIndex: 1));
                        },
                      ),
                      SizedBox(
                        height: SizeConfig.padding,
                      ),
                      InkWell(
                          onTap: () {
                            AppUtil.removeUntilNavigator(
                                context, const BottomNavTabsScreen());
                          },
                          child: CustomText(
                            text: "continueAsGuest".tr(),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
