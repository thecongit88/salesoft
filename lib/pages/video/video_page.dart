import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/model/AllVideoModel.dart';
import 'package:sale_soft/pages/home/video_player_page.dart';
import 'package:sale_soft/pages/video/Video_controller.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoState();
  }
}

class VideoState extends State<VideoPage>
    with AutomaticKeepAliveClientMixin<VideoPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = Get.put(VideoController());

    return controller.obx((allVideoModel) {
      return Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: () => {controller.getListVideo()},
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text("Giải pháp quản trị",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      GestureDetector(
                        onTap: () => {openYoutube()},
                        child: Text(
                          "Xem thêm",
                          style: TextStyle(
                            color: AppColors.orange,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  buildAdminVideo(allVideoModel),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text("Hướng dẫn sử dụng phần mềm",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      GestureDetector(
                        onTap: () => {openYoutube()},
                        child: Text(
                          "Xem thêm",
                          style: TextStyle(
                            color: AppColors.orange,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  buildTutorVideo(allVideoModel),
                ],
              )
            ],
          ),
        ),
      );
    }, onEmpty: EmptyDataWidget(
      onReloadData: () {
        controller.getListVideo();
      },
    ));
  }

  SizedBox buildAdminVideo(AllVideoModel? allVideoModel) {
    return SizedBox(
      height: 0.3.sh,
      child: ListView.builder(
          itemCount: allVideoModel?.listAdminVideo.length ?? 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var video = allVideoModel?.listAdminVideo[index];
            return buildVideoItem(
                video?.Name, video?.Image, context, video?.Url, video?.Date);
          }),
    );
  }

  SizedBox buildTutorVideo(AllVideoModel? allVideoModel) {
    return SizedBox(
      height: 0.3.sh,
      child: ListView.builder(
          itemCount: allVideoModel?.listTutorVideo.length ?? 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var video = allVideoModel?.listTutorVideo[index];
            return buildVideoItem(
                video?.Name, video?.Image, context, video?.Url, video?.Date);
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

openYoutube() async {
  if (Platform.isIOS) {
    if (await canLaunch(
        'youtube://www.youtube.com/channel/UCZl5Qs3mSvgQnPOKFMNuBfw')) {
      await launch('youtube://www.youtube.com/channel/UCZl5Qs3mSvgQnPOKFMNuBfw',
          forceSafariVC: false);
    } else {
      if (await canLaunch(
          'https://www.youtube.com/channel/UCZl5Qs3mSvgQnPOKFMNuBfw')) {
        await launch(
            'https://www.youtube.com/channel/UCZl5Qs3mSvgQnPOKFMNuBfw');
      } else {
        throw 'Could not launch https://www.youtube.com/channel/UCZl5Qs3mSvgQnPOKFMNuBfw';
      }
    }
  } else {
    const url = 'https://www.youtube.com/channel/UCZl5Qs3mSvgQnPOKFMNuBfw';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

Widget buildVideoItem(String? name, String? url, BuildContext context,
    String? videoUrl, String? date) {
  return InkWellWidget(
    onPress: () => {
      Get.to(YoutubePlayerPage(
        videoLink: videoUrl ?? "",
        videoTitle: name ?? "",
      ))
    },
    child: Container(
      width: 0.6.sw,
      margin:
          EdgeInsets.only(right: AppConstant.kSpaceHorizontalSmallExtraExtra),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 2 / 1,
                child: Image.network(
                  url ?? "",
                  fit: BoxFit.cover,
                ),
              ),
              Image.asset(
                AppResource.icPlayer,
                width: 36,
                height: 36,
              )
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            date ?? "",
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: AppColors.grey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            name ?? "",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    ),
  );
}
