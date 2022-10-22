import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/model/question_model.dart';
import 'package:sale_soft/pages/home/childs_page/question_controller.dart';
import 'package:sale_soft/widgets/expanded_widget.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with AutomaticKeepAliveClientMixin<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = Get.put(QuestionController());
    return controller.obx(
      (contentDisplay) {
        return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
            child: SmartRefresher(
              controller: controller.refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () => {controller.fetchListContent()},
              onLoading: () => {controller.fetchListContent(isLoadMore: true)},
              child: ListView.builder(
                padding:
                    EdgeInsets.only(bottom: AppConstant.kSpaceVerticalLarge),
                itemBuilder: (context, index) {
                  final QuestionModel item = contentDisplay![index];
                  return _QuestionItemView(item: item);
                },
                itemCount: contentDisplay?.length ?? 0,
              ),
            ));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _QuestionItemView extends StatefulWidget {
  const _QuestionItemView({
    Key? key,
    required this.item,
  }) : super(key: key);

  final QuestionModel item;

  @override
  _QuestionItemViewState createState() => _QuestionItemViewState();
}

class _QuestionItemViewState extends State<_QuestionItemView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: AppConstant.kSpaceVerticalSmallExtraExtra),
      child: InkWellWidget(
        onPress: () {
          setState(() {
            widget.item.isExpanded = !widget.item.isExpanded;
          });
        },
        borderRadius: 8.0,
        child: Container(
          padding: EdgeInsets.only(
              left: AppConstant.kSpaceHorizontalSmallExtraExtra,
              right: AppConstant.kSpaceHorizontalSmallExtraExtra,
              top: AppConstant.kSpaceVerticalSmallExtraExtra,
              bottom: AppConstant.kSpaceVerticalSmallExtraExtra),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(
                color: AppColors.grey50,
              ),
              shape: BoxShape.rectangle),
          child: Column(
            children: [
              _TitleView(item: widget.item, isExpanded: widget.item.isExpanded),
              ExpandedWidget(
                expand: widget.item.isExpanded,
                child: Padding(
                    padding: EdgeInsets.only(
                        top: AppConstant.kSpaceVerticalSmallExtra),
                    child: HtmlWidget(widget.item.reply ?? '',
                        textStyle: Theme.of(context).textTheme.bodyText1 ??
                            TextStyle())),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleView extends StatelessWidget {
  final bool isExpanded;

  const _TitleView({
    Key? key,
    required this.item,
    required this.isExpanded,
  }) : super(key: key);

  final QuestionModel item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            item.name ?? "",
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: isExpanded ? AppColors.blue : Colors.black,
                fontWeight: isExpanded ? FontWeight.w600 : FontWeight.normal),
          ),
        ),
        Icon(
          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: AppColors.grey300,
        )
      ],
    );
  }
}
