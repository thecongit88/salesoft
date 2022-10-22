import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/date_time_helper.dart';
import 'package:sale_soft/pages/home/childs_page/widgets/share_action_widget.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';

class NewsItemView extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? summay;
  final DateTime? date;
  final String? link;
  final Function()? onTap;

  const NewsItemView(
      {Key? key,
      this.onTap,
      this.imageUrl,
      this.title,
      this.summay,
      this.date,
      this.link})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onPress: onTap,
      child: Column(
        children: [
          Image.network(imageUrl ?? ""),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppConstant.spaceVerticalSmallMedium,
                Text(
                  title ?? '',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                ShareActionWidget(
                  shareLink: link ?? "",
                  dateStr: DateTimeHelper.dateToStringFormat(date: date) ?? '',
                ),
                SizedBox(
                  height: 4,
                ),
                _ContentWidget(summay: summay)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ContentWidget extends StatelessWidget {
  const _ContentWidget({
    Key? key,
    required this.summay,
  }) : super(key: key);

  final String? summay;

  @override
  Widget build(BuildContext context) {
    if (summay != null && summay?.isNotEmpty == true) {
      return Text(
        summay ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: Theme.of(context).textTheme.bodyText1,
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
