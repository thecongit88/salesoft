import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/widgets/app_bar_price_list_widget.dart';


class EditHtmlContent extends StatefulWidget {
  final Function(String) callback;
  final String? value;

  EditHtmlContent({Key? key, required this.callback, required this.value})
      : super(key: key);

  @override
  State<EditHtmlContent> createState() => _EditHtmlContentState();
}


class _EditHtmlContentState extends State<EditHtmlContent> {
  final controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              ///undo - reset - redo
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        controller.undo();
                      },
                      child:
                      Text('Undo', style: TextStyle(color: Colors.white)),
                    ),
                    /*SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blueGrey
                      ),
                      onPressed: () {
                        controller.clear();
                      },
                      child:
                      Text('Reset', style: TextStyle(color: Colors.white)),
                    ),*/
                    SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blueGrey
                      ),
                      onPressed: () {
                        controller.redo();
                      },
                      child: Text(
                        'Redo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              HtmlEditor(
                controller: controller, //required
                htmlEditorOptions: HtmlEditorOptions(
                  hint: "Viết nội dung của bạn",
                  initialText: widget.value ?? "",
                  shouldEnsureVisible: true
                ),
                htmlToolbarOptions: HtmlToolbarOptions(
                  toolbarPosition: ToolbarPosition.aboveEditor, //by default
                  toolbarType: ToolbarType.nativeExpandable, //by default
                  onButtonPressed:
                      (ButtonType type, bool? status, Function? updateStatus) {
                    print(
                        "button '${describeEnum(type)}' pressed, the current selected status is $status");
                    return true;
                  },
                  onDropdownChanged: (DropdownType type, dynamic changed,
                      Function(dynamic)? updateSelectedItem) {
                    print(
                        "dropdown '${describeEnum(type)}' changed to $changed");
                    return true;
                  },
                  mediaLinkInsertInterceptor:
                      (String url, InsertFileType type) {
                    print(url);
                    return true;
                  },
                  mediaUploadInterceptor:
                      (PlatformFile file, InsertFileType type) async {
                    print(file.name); //filename
                    print(file.size); //size in bytes
                    print(file.extension); //file extension (eg jpeg or mp4)
                    return true;
                  },
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.blue,
      title: Text('Nội dung'),
      centerTitle: true,
      actions: [
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          iconSize: 24,
          icon: Icon(
            Icons.save,
            color: Colors.white,
          ),
          onPressed: () async {
            widget.callback.call(await controller.getText());
            Get.back();
          },
        )
      ],
    );
  }
}
