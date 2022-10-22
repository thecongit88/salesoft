import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/app_global.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/image_button.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'line_widget.dart';

class ShareActionWidget extends StatelessWidget {
  final String dateStr;
  final String shareLink;

  const ShareActionWidget(
      {Key? key, required this.dateStr, required this.shareLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageButton(
          assetName: AppResource.icCalendar,
          padding: EdgeInsets.only(right: AppConstant.kSpaceHorizontalSmall),
          onTap: () {},
        ),
        Text(
          dateStr,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: AppColors.grey300),
        ),
        Expanded(child: SizedBox()),
        ImageButton(
          assetName: AppResource.icFacebook,
          onTap: () async {
            Clipboard.setData(ClipboardData(text: shareLink));
            showToast("Đã sao chép đường dẫn.");
            String fbProtocolUrl;
            if (Platform.isIOS) {
              fbProtocolUrl = 'fb://';
            } else {
              fbProtocolUrl = 'fb://';
            }

            String fallbackUrl = "https://www.facebook.com";

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
        // Container(
        //   color: AppColors.grey,
        //   width: 1,
        //   height: 10,
        // ),
        ImageButton(
          assetName: AppResource.icZaloShare,
          onTap: () async {
            Clipboard.setData(ClipboardData(text: shareLink));
            showToast("Đã sao chép đường dẫn.");
            if (Platform.isIOS) {
              if (await canLaunch('zalo://zalo.me/')) {
                await launch('zalo://zalo.me/', forceSafariVC: false);
              } else {
                if (await canLaunch('https://zalo.me/')) {
                  await launch('https://zalo.me/');
                } else {
                  throw 'Could not launch Zalo';
                }
              }
            } else {
              const url = 'https://zalo.me/';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }
          },
        ),
        // LineWidget(),
        // ImageButton(
        //   assetName: AppResource.icInstagram,
        //   onTap: () => {},
        // ),
        // LineWidget(),
        // ImageButton(
        //   assetName: AppResource.icTwitter,
        //   onTap: () => {},
        // ),
        // LineWidget(),
        // ImageButton(
        //   assetName: AppResource.icLinkedin,
        //   onTap: () => {},
        // ),
      ],
    );
  }
}
