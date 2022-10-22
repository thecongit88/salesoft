import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/common/app_colors.dart';

class MyComboBox<T> extends StatelessWidget {
  final String? hint;
  final List<T>? items;
  final T? value;
  final String Function(T item)? bindTitle;
  final ValueChanged<T?>? onChanged;
  final FormFieldSetter<T?>? onSaved;
  final bool isValidator;
  final Decoration? decoration;

  const MyComboBox({
    Key? key,
    this.hint,
    required this.items,
    required this.bindTitle,
    this.decoration,
    this.onChanged,
    this.onSaved,
    this.isValidator = true,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.all(8.0),
          decoration: decoration != null
              ? decoration
              : BoxDecoration(
            color: AppColors.blue100,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: DropdownButtonFormField<T>(
            dropdownColor: AppColors.blue50,
            iconSize: 50,
            value: value,
            icon: Icon(
              Icons.arrow_drop_down,
              size: 24,
            ),
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            decoration: InputDecoration.collapsed(
              hintText: hint ?? '',
              hintStyle: TextStyle(fontSize: 15.sp)
            ),
            validator: (value) {
              if (isValidator==true && value == null) {
                return "Thông tin bắt buộc.";
              }
              return null;
            },
            isExpanded: true,
            onSaved: onSaved,
            items: items?.map((value) {
              return DropdownMenuItem<T>(
                value: value,
                child: Text(
                  bindTitle?.call(value) ?? '',
                  // maxLines: 1,
                  // softWrap: false,
                  // overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 15.sp),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        )
      ],
    );
  }
}