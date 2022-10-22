import 'package:flutter/cupertino.dart';
import 'package:flutter/physics.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshConfigWidget extends StatelessWidget {
  final Widget child;

  const RefreshConfigWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => ClassicHeader(
        refreshingText: "",
        idleText: '',
        completeText: '',
        releaseText: '',
      ), // Configure the default header indicator. If you have the same header indicator for each page, you need to set this
      footerBuilder: () => ClassicFooter(
        loadingText: "",
        failedText: "",
        noDataText: "",
        canLoadingText: "",
        idleText: "",
      ), // Configure default bottom indicator
      headerTriggerDistance: 80.0, // header trigger refresh trigger distance
      springDescription: SpringDescription(
          stiffness: 170,
          damping: 16,
          mass:
              1.9), // custom spring back animate,the props meaning see the flutter api
      maxOverScrollExtent:
          100, //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
      maxUnderScrollExtent: 0, // Maximum dragging range at the bottom
      enableScrollWhenRefreshCompleted:
          true, //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
      enableLoadingWhenFailed:
          true, //In the case of load failure, users can still trigger more loads by gesture pull-up.
      hideFooterWhenNotFull:
          false, // Disable pull-up to load more functionality when Viewport is less than one screen
      enableBallisticLoad: true, // trigger load more by BallisticScrollActivity
      child: child,
    );
  }
}
