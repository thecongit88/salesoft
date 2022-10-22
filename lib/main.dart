import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sale_soft/application.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/text_theme_app.dart';
import 'package:sale_soft/main_controller.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/pages/account/account_page.dart';
import 'package:sale_soft/pages/home/home_page.dart';
import 'package:sale_soft/pages/notification/notification_page.dart';
import 'package:sale_soft/pages/support/support_page.dart';
import 'package:sale_soft/pages/video/video_page.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:sale_soft/widgets/refresh_config_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'common/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



Future<void> main() async {
  // await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotificationManager(
      child: RefreshConfigWidget(
        child: ScreenUtilInit(
          designSize: Size(360, 690),
          builder: () {
            return GetMaterialApp(
              enableLog: true,
              initialRoute: ERouter.mainPage.name,
              getPages: RouterPage.routers,
              theme: ThemeData(
                  brightness: Brightness.light,
                  accentColor: Colors.white,
                  primaryColor: Colors.white,
                  textTheme: TextThemeApp.textTheme,
                  fontFamily: "Roboto"),
              themeMode: ThemeMode.light,
              localizationsDelegates: [
                // ... app-specific localization delegate[s] here
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('vi'),
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
}

class MainPage extends GetView<MainController> {
  MainPage({Key? key}) : super(key: key);

  final List<Widget> childsPage = [
    HomePage(),
    VideoPage(),
    SupportPage(),
    NotificationPage(),
    AccountPage()
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 780),
        orientation: Orientation.portrait);
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              title: _TitleAppBarWidget(
                controller: controller,
              ),
            ),
            body: controller.obx((state) {
              return Obx(() => childsPage[controller.pageIndex.value]);
            }, onEmpty: _HandleEmptyWidget()),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
            floatingActionButton: Visibility(
                visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
                child: SizedBox(
                  width: 56.r,
                  height: 56.r,
                  child: FloatingActionButton(
                    backgroundColor: AppColors.orange,
                    onPressed: () {
                      controller.pageIndex.value = 2;
                    },
                    child: Image.asset(
                      AppResource.icMainActon,
                      fit: BoxFit.fitWidth,
                      width: 32.r,
                    ),
                  ),
                )),
            bottomNavigationBar: controller.obx((state) {
              return _bottomAppBarView(controller);
            })));
  }

  ///
  /// Bottom bar view
  ///
  BottomAppBar _bottomAppBarView(MainController controller) {
    return BottomAppBar(
      child: Padding(
        padding: EdgeInsets.only(
            top: AppConstant.kSpaceVerticalSmallExtraExtra,
            left: AppConstant.kSpaceHorizontalMedium,
            right: AppConstant.kSpaceHorizontalMedium),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _NavigationItemView(
                canShowBadge: false,
                label: 'Trang chủ',
                assetName: AppResource.icHome,
                assetColor: AppColors.grey,
                index: 0,
                onPress: () => controller.pageIndex.value = 0),
            _NavigationItemView(
                canShowBadge: false,
                label: 'Video',
                index: 1,
                assetName: AppResource.icPlay,
                onPress: () => controller.pageIndex.value = 1),
            _NavigationItemView(
                canShowBadge: false,
                label: 'Hỗ trợ',
                index: 2,
                onPress: () => controller.pageIndex.value = 2),
            _NavigationItemView(
                canShowBadge: true,
                label: 'Thông báo',
                index: 3,
                badgeContent: controller.listNotificationUnread.length,
                assetName: AppResource.icNotification,
                onPress: () => controller.pageIndex.value = 3),
            _NavigationItemView(
                canShowBadge: false,
                label: 'Tài khoản',
                index: 4,
                assetName: AppResource.icUser,
                onPress: () => controller.pageIndex.value = 4),
          ],
        ),
      ),
      shape: CircularNotchedRectangle(),
      color: AppColors.greyBackground,
    );
  }
}

class _HandleEmptyWidget extends StatelessWidget {
  const _HandleEmptyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) => AlertDialog(
    //           content: const Text(
    //               'Bạn phải cập nhật phiên bản mới  để tiếp tục sử dụng'),
    //           actions: <Widget>[
    //             TextButton(
    //               onPressed: () {},
    //               child: const Text('OK'),
    //             ),
    //           ],
    //         ));
    return EmptyDataWidget();
  }
}

class _TitleAppBarWidget extends StatelessWidget {
  final MainController controller;
  const _TitleAppBarWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LeadingTitleView(),
        Expanded(child: SizedBox()),

        /*
        AppConstant.spaceHorizontalSmall,
        IconButton(
          icon: Icon(
            Icons.qr_code,
            color: AppColors.blue50,
          ),
          onPressed: () {},
        ),
        */

        _CircleIconWidget(
          imageAssetName: AppResource.icMessenger,
          onPress: () async {
            String fbProtocolUrl;
            if (Platform.isIOS) {
              fbProtocolUrl = 'fb://profile/2153389004951515';
            } else {
              fbProtocolUrl = 'fb://page/2153389004951515';
            }

            String fallbackUrl = controller.appInfo?.facebook ?? "";

            try {
              bool launched = await launch(fbProtocolUrl, forceSafariVC: false);

              if (!launched) {
                await launch(fallbackUrl, forceSafariVC: false);
              }
            } catch (e) {
              await launch(fallbackUrl, forceSafariVC: false);
            }
          },
        ),
        AppConstant.spaceHorizontalSmall,
        _CircleIconWidget(
          imageAssetName: AppResource.icZalo,
          onPress: () async {
            if (Platform.isIOS) {
              if (await canLaunch(
                  'zalo://zalo.me/403836356098407297?gidzl=mqUh9Y4haKpANwyZ8ZMGJSnUgo4vDiKTq5to8ZzXpKpL2_SZQ6F07u5Q_29fCv18XbZxA6NRMWzPAIMIJ0')) {
                await launch(
                    'zalo://zalo.me/403836356098407297?gidzl=mqUh9Y4haKpANwyZ8ZMGJSnUgo4vDiKTq5to8ZzXpKpL2_SZQ6F07u5Q_29fCv18XbZxA6NRMWzPAIMIJ0',
                    forceSafariVC: false);
              } else {
                if (await canLaunch(
                    'https://zalo.me/403836356098407297?gidzl=mqUh9Y4haKpANwyZ8ZMGJSnUgo4vDiKTq5to8ZzXpKpL2_SZQ6F07u5Q_29fCv18XbZxA6NRMWzPAIMIJ0')) {
                  await launch(
                      'https://zalo.me/403836356098407297?gidzl=mqUh9Y4haKpANwyZ8ZMGJSnUgo4vDiKTq5to8ZzXpKpL2_SZQ6F07u5Q_29fCv18XbZxA6NRMWzPAIMIJ0');
                } else {
                  throw 'Could not launch Zalo';
                }
              }
            } else {
              const url =
                  'https://zalo.me/403836356098407297?gidzl=mqUh9Y4haKpANwyZ8ZMGJSnUgo4vDiKTq5to8ZzXpKpL2_SZQ6F07u5Q_29fCv18XbZxA6NRMWzPAIMIJ0';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }
          },
        ),
        AppConstant.spaceHorizontalSmall,
        _CircleIconWidget(
          imageAssetName: AppResource.icYoutube,
          onPress: () {
            controller.pageIndex.value = 1;
          },
        ),
        AppConstant.spaceHorizontalSmall,
        _CircleIconWidget(
          imageAssetName: AppResource.icMenu,
          onPress: () {
            controller.pageIndex.value = 4;
          },
        ),
      ],
    );
  }
}

class _CircleIconWidget extends StatelessWidget {
  final String imageAssetName;
  final Function()? onPress;

  const _CircleIconWidget({
    Key? key,
    required this.imageAssetName,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onPress: onPress,
      padding: const EdgeInsets.all(4),
      borderRadius: 22.r,
      child: Image.asset(
        imageAssetName,
        fit: BoxFit.fill,
        width: 28.r,
        height: 28.r,
      ),
    );
  }
}

class _LeadingTitleView extends StatelessWidget {
  const _LeadingTitleView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: 'SALE',
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(color: AppColors.blue, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
                text: 'SOFT',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: AppColors.orange,
                      fontWeight: FontWeight.bold,
                    ))
          ]),
    );
  }
}

///
/// Item trong BottomBar
///
class _NavigationItemView extends StatelessWidget {
  final Function()? onPress;
  final String? assetName;
  final Color? assetColor;
  final String? label;
  final int? index;
  final bool? canShowBadge;
  final int badgeContent;

  const _NavigationItemView(
      {Key? key,
      this.onPress,
      this.assetName,
      this.label,
      this.assetColor,
      this.index = -1,
      this.canShowBadge,
      this.badgeContent = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find();
    return Expanded(
      child: InkWellWidget(
        borderRadius: 4.r,
        padding: EdgeInsets.only(top: 4.h),
        onPress: onPress,
        child: Container(
            height: ScreenUtil().bottomBarHeight > 0 ? 42.h : 60.h,
            child: Obx(
              () => Column(
                children: [
                  Stack(
                    children: [
                      _buildIcon(controller),
                      Visibility(
                        visible: (canShowBadge == true) && badgeContent != 0,
                        child: Positioned(
                          right: 0,
                          child: Container(
                            constraints: BoxConstraints(
                              minWidth: 16.r,
                              minHeight: 16.r,
                            ),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Center(
                              child: Text(
                                badgeContent.toString(),
                                style: TextStyle(
                                    fontSize: 10.sp, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  AppConstant.spaceVerticalSmall,
                  Text(
                    label ?? '',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 10.sp,
                        color: controller.pageIndex.value == index
                            ? AppColors.orange
                            : AppColors.grey300),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildIcon(MainController controller) {
    if (assetName?.isNotEmpty == true) {
      return Container(
        alignment: Alignment.center,
        width: 28.r,
        height: 24.r,
        child: Image.asset(
          assetName ?? '',
          width: 20.r,
          height: 20.r,
          fit: BoxFit.fill,
          color: controller.pageIndex.value == index
              ? AppColors.orange
              : AppColors.grey,
        ),
      );
    } else {
      return SizedBox(
        width: 20.r,
        height: 20.r,
      );
    }
  }
}
