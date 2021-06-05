import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final Widget prefixItem;

  final Widget subfixItem;

  final Function onPress;

  final String text;

  final bool disabled;

  final double width;

  final double height;

  SettingItem(
      {this.onPress,
      this.text,
      this.prefixItem,
      this.subfixItem,
      this.disabled = false,
      this.width = 90,
      this.height = 45});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).accentColor;

    final textStyle = Theme.of(context)
        .textTheme
        .headline6
        .copyWith(fontSize: 14)
        .copyWith(color: textColor);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: RawMaterialButton(
        onPressed: disabled ? null : onPress,
        fillColor: Color(0xffbdbbbf),
        //primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          constraints: BoxConstraints(minWidth: double.infinity, minHeight: 50),
          child: Row(
            children: [
              prefixItem ?? SizedBox(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    text,
                    style: textStyle,
                  ),
                ),
              ),
              subfixItem ?? SizedBox()
            ],
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(-2, -2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
