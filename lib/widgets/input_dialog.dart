import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/number_formater.dart';
import 'package:sale_soft/common/utils.dart';

enum InputNumberType { QUANTITY, PRICE, PERCENTAGE }

class InputDialog extends StatefulWidget {
  final InputNumberType type;
  final String title;
  final double value;
  final double priceMin;

  final Function(double) callback;

  const InputDialog(
      {Key? key,
      required this.title,
      required this.callback,
      this.value = 0,
      this.type = InputNumberType.QUANTITY,
      this.priceMin = 0})
      : super(key: key);

  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _controller.text = kFormatCurrency.format(widget.value);
    _controller.text = widget.type == InputNumberType.QUANTITY || widget.type == InputNumberType.PRICE ? widget.value.toDouble().toAmountFormat().toString() : widget.value.toDouble().toString();
    _controller.text = _controller.text.trim() == "0" ? "" : _controller.text;
    _controller.selection = TextSelection(
        baseOffset: _controller.value.text.length,
        extentOffset: _controller.value.text.length);
    return new AlertDialog(
      title: Text(
        widget.title,
        style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              focusNode: _focusNode,
              controller: _controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              onSubmitted: (value) {
                onDone();
              },
              inputFormatters:
              widget.type == InputNumberType.QUANTITY || widget.type == InputNumberType.PRICE ?
                <TextInputFormatter>[
                  getCurrencyFormatVND()
                ]
                  : null,
              decoration: InputDecoration(
                  hintText: '0'
              ),
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          textColor: AppColors.blue,
          child: const Text(
            "Huỷ bỏ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        new FlatButton(
          onPressed: onDone,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          textColor: AppColors.blue,
          child: const Text(
            "Đồng ý",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void onDone() {
    try {
      var value =
          double.parse(_controller.text.replaceAll(RegExp('[^0-9.]'), ''));
      if (widget.type == InputNumberType.QUANTITY && value <= 0) {
        Fluttertoast.showToast(
            msg: "Số lượng phải lớn hơn 0.", gravity: ToastGravity.CENTER);
        return;
      }

      if (widget.type == InputNumberType.PERCENTAGE && value > 100) {
        Fluttertoast.showToast(
            msg: "Giá trị lớn nhất có thể nhập là 100%.",
            gravity: ToastGravity.CENTER);
        return;
      }

      if (value < 0) {
        Fluttertoast.showToast(
            msg: "Không thể nhập số nhỏ hơn 0.", gravity: ToastGravity.CENTER);
        return;
      }

      if (widget.type == InputNumberType.PRICE && value < widget.priceMin) {
        String priceMin = widget.priceMin.toAmountFormat();
        Fluttertoast.showToast(
            msg: "Không thể nhập thấp hơn giá sàn là $priceMin",
            gravity: ToastGravity.CENTER);
        return;
      }

      widget.callback.call(value);
      Navigator.of(context).pop();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Vui lòng nhập đúng định dạng số.",
          gravity: ToastGravity.CENTER);
    }
  }
}
