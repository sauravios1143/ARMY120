import 'dart:convert';
import 'dart:io';
import 'package:army120/utils/AssetStrings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

import 'UniversalFunctions.dart';
import 'app_theme/app_colors.dart';

double minimumDefaultButtonHeight = 55;
// Returns "App themed text field" centered label
Widget appThemedTextFieldOne({
  @required String label,
  @required TextEditingController controller,
  @required BuildContext context,
  bool obscureText,
  @required FocusNode focusNode,
  TextInputType keyboardType,
  Function(String) validator,
  List<TextInputFormatter> inputFormatters,
  Function(String) onFieldSubmitted,
  int maxLength,
  int maxLines,
  bool enabled,
  TextStyle textStyle,
  TextStyle labelStyle,
  Color borderColor,
  String suffixAsset,
  Widget suffixSecondaryAsset,
  Widget prefixOneAsset,
  Function onPrefixOneTap,
  Widget prefixTwoAsset,
  Function onPrefixTwoTap,
  TextInputAction inputAction,
  TextCapitalization textCapitalization,
}) {
  // Defaults
  const TextStyle defaultLabelStyle = const TextStyle(
    color: Colors.white,
  );

  const TextStyle defaultTextStyle = const TextStyle(
    color: Colors.white,
  );

  const Color defaultBorderColor = Colors.white;

  return new Stack(
    children: <Widget>[
      new Column(
        children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              suffixAsset != null
                  ? new Container(
                      width: getScreenSize(context: context).width * 0.105,
                      height: getScreenSize(context: context).width * 0.1,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        bottom: 6.0,
                        left: 8.0,
                      ),
                      child: new Image.asset(
                        suffixAsset,
                        width: getScreenSize(context: context).width * 0.04,
                        height: getScreenSize(context: context).width * 0.05,
                        fit: BoxFit.fill,
                      ),
                    )
                  : new Container(),
              new Container(
                height: getScreenSize(context: context).width * 0.074,
                child: suffixSecondaryAsset ?? new Container(),
              ),
              new Offstage(
                offstage: suffixSecondaryAsset == null,
                child: getSpacer(
                  width: 4.0,
                ),
              ),
              new Expanded(
                child: new Container(
                  child: new InkWell(
                    onTap: () {
                      FocusScope.of(context).requestFocus(focusNode);
                    },
                    child: new TextFormField(
                      textCapitalization:
                          textCapitalization ?? TextCapitalization.none,
                      textInputAction: inputAction ?? TextInputAction.next,
                      controller: controller,
                      obscureText: obscureText ?? false,
                      focusNode: focusNode,
                      keyboardType: keyboardType,
                      validator: validator,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(maxLength ?? 1000),
                      ]..addAll(inputFormatters ?? []),
                      onFieldSubmitted: onFieldSubmitted,
                      enabled: enabled,
                      maxLines: maxLines == 3 ? null : 1,
                      style: textStyle ?? defaultTextStyle,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                          top: 0.0,
                          bottom: 0.0,
                        ),
                        labelText: label,
                        labelStyle: labelStyle ?? defaultLabelStyle,
                        errorStyle: new TextStyle(
                          fontSize: 10.0,
                          color: labelStyle?.color ?? defaultLabelStyle?.color,
                        ),
                        helperStyle: new TextStyle(
                          fontSize: 0.0,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ),
              new Offstage(
                offstage: prefixOneAsset == null,
                child: new InkWell(
                  onTap: onPrefixOneTap,
                  child: new Container(
                    width: getScreenSize(context: context).width * 0.105,
                    height: getScreenSize(context: context).width * 0.1,
                    padding: const EdgeInsets.only(
                      bottom: 6.0,
                      right: 8.0,
                    ),
                    child: prefixOneAsset == null
                        ? new Container()
                        : new Container(
                            child: prefixOneAsset,
                            width: getScreenSize(context: context).width * 0.04,
                            height:
                                getScreenSize(context: context).width * 0.05,
                          ),
                  ),
                ),
              ),
              new Offstage(
                offstage: prefixTwoAsset == null,
                child: new InkWell(
                  onTap: onPrefixTwoTap,
                  child: new Container(
//                  color: Colors.amber,
                    width: getScreenSize(context: context).width * 0.07,
                    height: getScreenSize(context: context).width * 0.1,
                    padding: const EdgeInsets.only(
                      bottom: 6.0,
                      right: 8.0,
                    ),
                    child: prefixTwoAsset == null
                        ? new Container()
                        : new Container(
                            child: prefixTwoAsset,
                            width: getScreenSize(context: context).width * 0.04,
                            height:
                                getScreenSize(context: context).width * 0.05,
                          ),
                  ),
                ),
              ),
            ],
          ),
          getSpacer(
            height: 4.0,
          ),
          new Container(
            height: 1.0,
            color: borderColor ?? defaultBorderColor,
          ),
        ],
      ),
      new Positioned.fill(
        child: new Offstage(
          offstage: enabled ?? true,
          child: new Container(
            color: Colors.cyanAccent.withOpacity(0.0),
          ),
        ),
      ),
    ],
  );
}

// Returns "App themed image picker text field" centered label
/*Widget appThemedImagePickerTextFieldOne({
  @required String label,
  @required TextEditingController controller,
  @required BuildContext context,
  bool obscureText,
  @required FocusNode focusNode,
  TextInputType keyboardType,
  Function(String) validator,
  List<TextInputFormatter> inputFormatters,
  Function(String) onFieldSubmitted,
  int maxLength,
  int maxLines,
  bool enabled,
  TextStyle textStyle,
  TextStyle labelStyle,
  Color borderColor,
  @required String suffixAsset,
  Widget suffixSecondaryAsset,
  Widget prefixOneAsset,
  Function onPrefixOneTap,
  Widget prefixTwoAsset,
  Function onPrefixTwoTap,
  TextInputAction inputAction,
  TextCapitalization textCapitalization,
  @required bool mounted,
  @required Function(File) onFileSelected,
  @required Function onCancel,
}) {
  return new Stack(
    children: <Widget>[
      appThemedTextFieldOne(
        focusNode: focusNode,
        context: context,
        suffixAsset: suffixAsset,
        controller: controller,
        label: label,
        validator: validator,
        obscureText: obscureText,
        onPrefixOneTap: () {
          controller.clear();
          print("CANCEL CLICKED");
          if (onCancel != null) {
            onCancel();
          }
        },
        prefixOneAsset: controller.text.isEmpty
            ? new Container()
            : new Align(
                alignment: Alignment.bottomRight,
                child: new Icon(
                  Icons.cancel,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
        prefixTwoAsset: prefixTwoAsset != null
            ? new Align(
                alignment: Alignment.bottomRight,
                child: prefixTwoAsset,
              )
            : prefixTwoAsset,
        onPrefixTwoTap: onPrefixTwoTap,
        onFieldSubmitted: onFieldSubmitted,
        labelStyle: labelStyle,
        borderColor: borderColor,
        enabled: true,
        inputAction: inputAction,
        textStyle: textStyle,
      ),
      new Positioned(
        right: prefixTwoAsset != null
            ? controller.text.isEmpty
                ? getScreenSize(context: context).width * 0.105
                : 2 * getScreenSize(context: context).width * 0.105
            : controller.text.isEmpty
                ? 0.0
                : getScreenSize(context: context).width * 0.105,
        top: 0.0,
        left: 0.0,
        bottom: 0.0,
        child: new InkWell(
          onTap: () async {
            File file = await showMediaAlert(context: context);
            if (file != null) {
              if (file.lengthSync() <= 40000000) {
                controller.text = file.path.split("/").last;
                if (onFileSelected != null) {
                  onFileSelected(file);
                }
              } else {
                showAlert(
                  context: context,
                  titleText:
                      Localization.of(context).trans(LocalizationValues.error),
                  message: Localization.of(context)
                      .trans(LocalizationValues.fileSizeCheck),
                  actionCallbacks: {
                    Localization.of(context).trans(LocalizationValues.ok):
                        () {},
                  },
                );
              }
            }
          },
          child: new Container(
            color: Colors.white.withOpacity(0.0),
          ),
        ),
      ),
    ],
  );
}*/

// Returns "App themed Phone text field " centered label
/*Widget appThemedPhoneTextFieldOne({
  @required String label,
  @required Country initialSelectedCountry,
  @required TextEditingController controller,
  @required BuildContext context,
  @required Function(Country) onCountrySelected,
  bool obscureText,
  @required FocusNode focusNode,
  TextInputType keyboardType,
  Function(String) validator,
  List<TextInputFormatter> inputFormatters,
  Function(String) onFieldSubmitted,
  bool enabled,
  TextStyle textStyle,
  TextStyle labelStyle,
  Color borderColor,
  int maxLength,
  String suffixAsset,
  Widget prefixAsset,
  Function onPrefixTap,
  TextInputAction inputAction,
}) {
  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      );

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: new CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(
                hintText:
                    Localization.of(context).trans(LocalizationValues.search) +
                        '...'),
            isSearchable: true,
            title: new Text(Localization.of(context)
                .trans(LocalizationValues.selectYourPhoneCode)),
            onValuePicked: onCountrySelected,
            itemBuilder: _buildDialogItem,
          ),
        ),
      );

  return new Stack(
    children: <Widget>[
      appThemedTextFieldOne(
        focusNode: focusNode,
        context: context,
        suffixAsset: suffixAsset,
        suffixSecondaryAsset: new InkWell(
          child: new Container(
//        color: Colors.blue,
            child: new Row(
              children: <Widget>[
                new Text(
                  "+${initialSelectedCountry.phoneCode}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: textStyle?.color ?? Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                new Icon(
                  Icons.expand_more,
                  color: textStyle?.color ?? Colors.white,
                  size: 15,
                ),
              ],
            ),
          ),
          onTap: _openCountryPickerDialog,
        ),
        controller: controller,
        label: label,
        validator: validator,
        obscureText: obscureText,
        inputFormatters: [
          WhitelistingTextInputFormatter(RegExp("[0-9]")),
          LengthLimitingTextInputFormatter(maxLength ?? 1000),
        ]..addAll(inputFormatters ?? []),
        keyboardType: TextInputType.phone,
        onPrefixOneTap: onPrefixTap,
        prefixOneAsset: prefixAsset,
        onFieldSubmitted: onFieldSubmitted,
        labelStyle: labelStyle,
        borderColor: borderColor,
        enabled: enabled,
        inputAction: inputAction,
        textStyle: textStyle,
      ),
      new Positioned.fill(
        child: new Offstage(
          offstage: enabled ?? true,
          child: new Container(
            color: Colors.cyanAccent.withOpacity(0.0),
          ),
        ),
      )
    ],
  );
}*/

// Returns "App themed text field" left sided label
Widget appThemedTextFieldTwo({
  @required String label,
  @required TextEditingController controller,
  @required BuildContext context,
  bool obscureText,
  @required FocusNode focusNode,
  TextInputType keyboardType,
  Function(String) validator,
  List<TextInputFormatter> inputFormatters,
  Function(String) onFieldSubmitted,
  Function(String) onChange,
  bool enabled = true,
  bool autoValidate,
  TextStyle textStyle,
  TextStyle labelStyle,
  Color borderColor,
  int maxLines,
  int maxLength,
  Widget suffix,
  Widget prefix,
  TextInputAction inputAction,
  Widget suffixWidget,
  Function onPrefixOneTap,
  TextCapitalization textCapitalization,
}) {
  // Defaults
  const TextStyle defaultLabelStyle = const TextStyle(
    color: Colors.grey, //
    fontSize: 14.0,
  );
  final TextStyle defaultTextStyle = new TextStyle(
    //    fontWeight: FontWeight.w600,
    color: enabled ? Colors.black : Colors.black.withOpacity(0.6),
//    fontSize: 18.0,
  );
  const Color defaultBorderColor = AppColors.kGrey;
  final double _height = getScreenSize(context: context).height * 0.067;
  final double defaultHeight = _height > minimumDefaultButtonHeight
      ? _height
      : minimumDefaultButtonHeight;

  return new Card(
    elevation: 0.0,
    color: Colors.red.withOpacity(0.06),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    child: new Stack(
      children: <Widget>[
        new Container(
          height: defaultHeight,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 24.0, right: 10),
          child: new Row(
            children: <Widget>[
              prefix ?? new Container(),
              new SizedBox(
                width: 10,
              ),
              new Expanded(
                child: new TextFormField(
                  textInputAction: inputAction ?? TextInputAction.next,
                  controller: controller,
                  textCapitalization:
                      textCapitalization ?? TextCapitalization.none,
                  obscureText: obscureText ?? false,
                  focusNode: focusNode,
                  keyboardType: keyboardType,
                  validator: validator,
                  autovalidate: autoValidate ?? false,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(maxLength ?? 1000),
                  ]..addAll(inputFormatters ?? []),
                  onFieldSubmitted: onFieldSubmitted,
                  style: textStyle ?? defaultTextStyle,
                  maxLines: maxLines ?? 1,
                  onChanged: onChange,
                  decoration: new InputDecoration(
                    labelText: label,
                    labelStyle: labelStyle ?? defaultLabelStyle,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                      top: 0.0,
                      bottom: 0.0,
                    ),
                    errorStyle: new TextStyle(
                      fontSize: 10.0,
//                      color: labelStyle?.color ?? defaultLabelStyle?.color,
                    ),
                    helperStyle: new TextStyle(
                      fontSize: 0.0,
                      color: Colors.black,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              new Offstage(
                offstage: suffixWidget == null,
                child: new InkWell(
                  onTap: onPrefixOneTap,
                  child: new Container(
                    width: getScreenSize(context: context).width * 0.105,
                    height: getScreenSize(context: context).width * 0.1,
                    padding: const EdgeInsets.only(
                      bottom: 6.0,
                      right: 8.0,
                    ),
                    child: suffixWidget == null
                        ? new Container()
                        : new Container(
                            child: suffixWidget,
                            width: getScreenSize(context: context).width * 0.04,
                            height:
                                getScreenSize(context: context).width * 0.05,
                          ),
                  ),
                ),
              ),

              //  suffix ?? new Container(),
            ],
          ),
        ),
        new Positioned.fill(
          child: new Offstage(
            offstage: enabled,
            child: new Container(
              color: Colors.cyanAccent.withOpacity(0.0),
            ),
          ),
        ),
      ],
    ),
  );
}

// Returns "App themed text field" left sided label
Widget appThemedTextField({
   String label,
  String hint,
  @required TextEditingController controller,
  @required BuildContext context,
  bool obscureText,
  @required FocusNode focusNode,
  TextInputType keyboardType,
  Function(String) validator,
  List<TextInputFormatter> inputFormatters,
  Function(String) onFieldSubmitted,
  bool enabled = true,
  bool autoValidate,
  TextStyle textStyle,
  TextStyle labelStyle,
  Color borderColor,
  int maxLines,
  int maxLength,
  Widget suffix,
  Widget prefix,
  TextInputAction inputAction,
  Widget suffixWidget,
  Function onPrefixOneTap,
  TextCapitalization textCapitalization,
}) {
  // Defaults
  const TextStyle defaultLabelStyle = const TextStyle(
    color: Colors.grey, //
    fontSize: 14.0,
  );
  final TextStyle defaultTextStyle = new TextStyle(
    //    fontWeight: FontWeight.w600,
    color: enabled ? Colors.black : Colors.black.withOpacity(0.6),
//    fontSize: 18.0,
  );
  const Color defaultBorderColor = AppColors.kGrey;
  final double _height = getScreenSize(context: context).height * 0.067;
  final double defaultHeight = _height > minimumDefaultButtonHeight
      ? _height
      : minimumDefaultButtonHeight;

  return new Card(
    elevation: 0.0,
    color: Colors.red.withOpacity(0.06),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    child: new Stack(
      children: <Widget>[
        new Container(
          height: defaultHeight,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 24.0, right: 10),
          child: new Row(
            children: <Widget>[
              prefix ?? new Container(),
              new SizedBox(
                width: 10,
              ),
              new Expanded(
                child: new TextFormField(
                  textInputAction: inputAction ?? TextInputAction.next,
                  controller: controller,
                  textCapitalization:
                      textCapitalization ?? TextCapitalization.none,
                  obscureText: obscureText ?? false,
                  focusNode: focusNode,
                  keyboardType: keyboardType,
                  validator: validator,
                  autovalidate: autoValidate ?? false,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(maxLength ?? 1000),
                  ]..addAll(inputFormatters ?? []),
                  onFieldSubmitted: onFieldSubmitted,
                  style: textStyle ?? defaultTextStyle,
                  maxLines: maxLines ?? 1,
                  decoration: new InputDecoration(
                    labelText: label ,
                    hintText: hint ?? "",

//                    labelStyle: labelStyle ?? defaultLabelStyle,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                      top: 0.0,
                      bottom: 0.0,
                    ),
                    errorStyle: new TextStyle(
                      fontSize: 10.0,
//                      color: labelStyle?.color ?? defaultLabelStyle?.color,
                    ),
                    helperStyle: new TextStyle(
                      fontSize: 0.0,
                      color: Colors.black,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              new Offstage(
                offstage: suffixWidget == null,
                child: new InkWell(
                  onTap: onPrefixOneTap,
                  child: new Container(
                    width: getScreenSize(context: context).width * 0.105,
                    height: getScreenSize(context: context).width * 0.1,
                    padding: const EdgeInsets.only(
                      bottom: 6.0,
                      right: 8.0,
                    ),
                    child: suffixWidget == null
                        ? new Container()
                        : new Container(
                            child: suffixWidget,
                            width: getScreenSize(context: context).width * 0.04,
                            height:
                                getScreenSize(context: context).width * 0.05,
                          ),
                  ),
                ),
              ),

              //  suffix ?? new Container(),
            ],
          ),
        ),
        new Positioned.fill(
          child: new Offstage(
            offstage: enabled,
            child: new Container(
              color: Colors.cyanAccent.withOpacity(0.0),
            ),
          ),
        ),
      ],
    ),
  );
}

// Returns "App themed text field" left sided label
Widget appThemedTextFieldTwoWithoutPadding({
  @required String label,
  @required TextEditingController controller,
  @required BuildContext context,
  bool obscureText,
  @required FocusNode focusNode,
  TextInputType keyboardType,
  Function(String) validator,
  List<TextInputFormatter> inputFormatters,
  Function(String) onFieldSubmitted,
  bool enabled = true,
  bool autoValidate,
  TextStyle textStyle,
  TextStyle labelStyle,
  Color borderColor,
  int maxLines,
  int maxLength,
  Widget suffix,
  Widget prefix,
  TextInputAction inputAction,
  TextCapitalization textCapitalization,
}) {
  // Defaults
  const TextStyle defaultLabelStyle = const TextStyle(
    color: AppColors.kGrey,
    fontSize: 14.0,
  );
  final TextStyle defaultTextStyle = new TextStyle(
    //    fontWeight: FontWeight.w600,
    color: enabled ? Colors.black : Colors.black.withOpacity(0.6),
//    fontSize: 18.0,
  );
  const Color defaultBorderColor = AppColors.kGrey;
  final double _height = getScreenSize(context: context).height * 0.067;
  final double defaultHeight = _height > minimumDefaultButtonHeight
      ? _height
      : minimumDefaultButtonHeight;

  return new Card(
    elevation: 2.0,
    shape: const StadiumBorder(),
    child: new Stack(
      children: <Widget>[
        new Container(
          height: defaultHeight,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            left: 24.0,
          ),
          child: new Row(
            children: <Widget>[
              prefix ?? new Container(),
              new SizedBox(
                width: 5,
              ),
              new Expanded(
                child: new TextFormField(
                  textInputAction: inputAction ?? TextInputAction.next,
                  controller: controller,
                  textCapitalization:
                      textCapitalization ?? TextCapitalization.none,
                  obscureText: obscureText ?? false,
                  focusNode: focusNode,
                  keyboardType: keyboardType,
                  validator: validator,
                  autovalidate: autoValidate ?? false,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(maxLength ?? 1000),
                  ]..addAll(inputFormatters ?? []),
                  onFieldSubmitted: onFieldSubmitted,
                  style: textStyle ?? defaultTextStyle,
                  maxLines: maxLines ?? 1,
                  decoration: new InputDecoration(
                    labelText: label,
                    labelStyle: labelStyle ?? defaultLabelStyle,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                      top: 0.0,
                      bottom: 0.0,
                    ),
                    errorStyle: new TextStyle(
                      fontSize: 10.0,
//                      color: labelStyle?.color ?? defaultLabelStyle?.color,
                    ),
                    helperStyle: new TextStyle(
                      fontSize: 0.0,
                      color: Colors.black,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              suffix ?? new Container(),
            ],
          ),
        ),
        new Positioned.fill(
          child: new Offstage(
            offstage: enabled,
            child: new Container(
              color: Colors.cyanAccent.withOpacity(0.0),
            ),
          ),
        ),
      ],
    ),
  );
}

// Returns "App themed text field" left sided label
Widget appThemedTextFieldThree({
  @required String label,
  @required TextEditingController controller,
  @required BuildContext context,
  bool obscureText,
  @required FocusNode focusNode,
  TextInputType keyboardType,
  Function(String) validator,
  List<TextInputFormatter> inputFormatters,
  Function(String) onFieldSubmitted,
  bool enabled = true,
  TextStyle textStyle,
  TextStyle labelStyle,
  Color borderColor,
  int maxLines,
  int maxLength,
  Widget suffix,
  Widget prefix,
}) {
  // Defaults
  const TextStyle defaultLabelStyle = const TextStyle(
    color: Colors.black,
    fontSize: 14.0,
  );
  final TextStyle defaultTextStyle = new TextStyle(
//    fontWeight: FontWeight.w600,
    color: enabled ? Colors.black : Colors.black.withOpacity(0.6),
    fontSize: 18.0,
  );
  const Color defaultBorderColor = AppColors.kGrey;

  return new Theme(
    data: new ThemeData(
      hintColor: Colors.black,
      primaryColor: Colors.black,
    ),
    child: new TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      focusNode: focusNode,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength ?? 1000),
      ]..addAll(inputFormatters ?? []),
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      style: textStyle ?? defaultTextStyle,
      maxLines: maxLines ?? 1,
      decoration: new InputDecoration(
        labelText: label,
        labelStyle: labelStyle ?? defaultLabelStyle,
//      border: InputBorder.none,
        contentPadding: const EdgeInsets.only(
          top: 5.0,
          bottom: 0.0,
        ),
        errorStyle: new TextStyle(
          fontSize: 10.0,
          color: Colors.red,
        ),
        helperStyle: new TextStyle(
          fontSize: 0.0,
        ),
        isDense: true,
        suffixIcon: suffix,
        prefixIcon: prefix,
      ),
    ),
  );
}

Widget getAppOutlineButton({
  @required VoidCallback onPressed,
  @required BuildContext context,
  Widget title,
  Color titleTextColor,
  @required String titleText,
  double height,
  Color backGroundColor,
  double borderRadius,
  double borderWidth,
  Color borderColor,
  bool inheritCc,
}) {
  // Defaults
  const double defaultBorderRadius = 30.0;
  const Color defaultBorderColor = Colors.white;
  const Color defaultBackGroundColor = Colors.transparent;
  const Color defaultDisabledBackgroundColor = Colors.grey;
  const double defaultBorderWidth = 0.8;
  final double _height = getScreenSize(context: context).height * 0.067;
  final double defaultHeight = _height > minimumDefaultButtonHeight
      ? _height
      : minimumDefaultButtonHeight;

  return new Material(
    color: onPressed != null
        ? backGroundColor ?? defaultBackGroundColor
        : defaultDisabledBackgroundColor,
    shape: StadiumBorder(),
    elevation: 0.0,
    clipBehavior: Clip.hardEdge,
    child: new InkWell(
      onTap: onPressed,
      child: new Container(
        height: height ?? defaultHeight,
        width: getScreenSize(context: context).width,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          border: new Border.all(
            color: borderColor ?? defaultBorderColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular((height ?? defaultHeight) / 2.0),
        ),
        child: new Text(
              titleText,
              style: new TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13.0,
                color: titleTextColor ?? Colors.white,
              ),
            ) ??
            title,
      ),
    ),
  );
}

Widget getAppThemedButton(
    {title, onpress, horizontalPadding: 16.0, verticalPadding: 16.0}) {
  return InkWell(
    onTap: onpress,
    child: Container(
      width: null,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1.5, color: Colors.red)),
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: Text(
        title ?? "",
        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
      ),
    ),
  );
}

Widget getAppThemedFilledButton({title, onpress}) {
  return InkWell(
    onTap: onpress,
    child: Container(
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1.5, color: Colors.red)),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title ?? "",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget getAppThemedChipButton({title, onpress}) {
  double height = 55;

  return InkWell(
    onTap: onpress,
    child: Container(
//      height: height,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
//    alignment: Alignment(0,0),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Text(
        title ?? "",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
            fontSize: 18),
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

// Returns spacer
Widget getSpacer({double height, double width}) {
  return new SizedBox(
    height: height ?? 0.0,
    width: width ?? 0.0,
  );
}

// Returns cached image
Widget getCachedNetworkImage(
    {@required String url, BoxFit fit, height, width, defaultImage}) {
  return new CachedNetworkImage(
    width: width ?? double.infinity,
    height: height ?? double.infinity,
    imageUrl: url ?? "",
    matchTextDirection: true,
    fit: fit??BoxFit.cover,
    placeholder: (context, String val) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: new Center(
          child: new CupertinoActivityIndicator(),
        ),
      );
    },
    errorWidget: (BuildContext context, String error, Object obj) {
      return new Center(
        child: new Image.asset(
          AssetStrings.logo,
          fit: BoxFit.cover,
//          height: 24.0,
        ),
      );
    },
  );
}

// Returns app themed loader
Widget getAppThemedLoader({
  @required BuildContext context,
  Color bgColor,
  Color color,
  double strokeWidth,
}) {
  return new Container(
    color: bgColor ?? const Color.fromRGBO(1, 1, 1, 0.6),
    height: getScreenSize(context: context).height,
    width: getScreenSize(context: context).width,
    child: getChildLoader(
      color: color ?? AppColors.primaryColor,
      strokeWidth: strokeWidth,
    ),
  );
}

// Returns app themed loader
Widget getFullScreenLoader({
  @required Stream<bool> stream,
  @required BuildContext context,
  Color bgColor,
  Color color,
  double strokeWidth,
}) {
  return new StreamBuilder<bool>(
    stream: stream,
    initialData: false,
    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      bool status = snapshot.data;
      return status
          ? getAppThemedLoader(
              context: context,
            )
          : new Container();
    },
  );
}

Widget appThemedDatePickerTextField({
  @required String label,
  @required TextEditingController controller,
  @required BuildContext context,
  bool obscureText,
  @required FocusNode focusNode,
  TextInputType keyboardType,
  Function(String) validator,
  List<TextInputFormatter> inputFormatters,
  Function(String) onFieldSubmitted,
  bool enabled,
  TextStyle textStyle,
  TextStyle labelStyle,
  Color borderColor,
  @required DateTime initialDate,
  DateTime lastDate,
  DateTime firstDate,
  @required Function(DateTime) onDatePicked,
  String dateFormat,
  @required String suffixAsset,
}) {
  return new GestureDetector(
    onTap: () async {
      DateTime _today = ((DateTime time) =>
          new DateTime.utc(time.year, time.month, time.day))(DateTime.now());

      DateTime _picked = await showDatePicker(
        context: context,
        firstDate: firstDate ?? _today,
        lastDate: lastDate ?? _today.add(new DateTime.now().timeZoneOffset),
        initialDate: initialDate ?? firstDate,
      );

      if (_picked != null) {
        controller.text = getFormattedDateString(
          format: "MMM dd, y",
          dateTime: _picked,
        );
        onDatePicked(_picked);
      }
    },
    child: new Stack(
      children: <Widget>[
        appThemedTextFieldOne(
          context: context,
          focusNode: focusNode,
          validator: validator,
          controller: controller,
          label: label,
          suffixAsset: suffixAsset,
        ),
        new Positioned(
          top: 0.0,
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: new Container(
            color: Colors.cyanAccent.withOpacity(
              0.0,
            ),
          ),
        ),
      ],
    ),
  );
}

// Returns app themed pop up textfield one
Widget appThemedPopUpTextFieldOne({
  @required String label,
  @required TextEditingController controller,
  @required BuildContext context,
  bool obscureText,
  @required FocusNode focusNode,
  TextInputType keyboardType,
  Function(String) validator,
  List<TextInputFormatter> inputFormatters,
  Function(String) onFieldSubmitted,
  bool enabled = true,
  TextStyle textStyle,
  TextStyle labelStyle,
  Color borderColor,
  Color dropDownIconColor,
  @required Map<String, String> options,
  bool allowInput = false,
  VoidCallback onValueChanged,
}) {
  List _options = options.keys.toList();
  List _values = options.values.toList();

  return new Stack(
    children: <Widget>[
      new PopupMenuButton<String>(
        child: new Stack(
          children: <Widget>[
            appThemedTextFieldOne(
              focusNode: focusNode,
              context: context,
              suffixAsset: null,
              controller: controller,
              label: label,
              validator: validator,
              obscureText: obscureText,
              onFieldSubmitted: onFieldSubmitted,
              labelStyle: labelStyle,
              borderColor: borderColor,
              enabled: false,
              prefixTwoAsset: new Align(
                alignment: Alignment.bottomRight,
                child: options.isEmpty
                    ? new CupertinoActivityIndicator(
                        radius: 8.0,
                      )
                    : new Icon(
                        Icons.keyboard_arrow_down,
                        color: dropDownIconColor ?? Colors.white,
                      ),
              ),
              textStyle: textStyle,
            ),
            new Positioned.fill(
              child: new Container(
                color: Colors.cyanAccent.withOpacity(0.0),
              ),
            ),
          ],
        ),
        onSelected: (String result) {
          controller.text = result;
          if (onValueChanged != null) {
            onValueChanged();
          }
        },
        itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<String>>[]..addAll(
                new List.generate(
                  options.keys.length,
                  (int index) {
                    return new PopupMenuItem<String>(
                      value: _options[index],
                      child: new Text(_values[index]),
                    );
                  },
                ),
              ),
      ),
      new Positioned.fill(
        child: new Visibility(
          visible: !enabled || options.isEmpty,
          child: new Container(
            color: Colors.cyanAccent.withOpacity(0.0),
          ),
        ),
      ),
    ],
  );
}

// Returns app themed pop up textfield two
Widget appThemedPopUpTextFieldTwo({
  @required String label,
  @required TextEditingController controller,
  @required BuildContext context,
  bool obscureText,
  @required FocusNode focusNode,
  TextInputType keyboardType,
  Function(String) validator,
  List<TextInputFormatter> inputFormatters,
  Function(String) onFieldSubmitted,
  bool enabled,
  TextStyle textStyle,
  TextStyle labelStyle,
  Color borderColor,
  @required Map<String, String> options,
  bool allowInput = false,
  VoidCallback onValueChanged,
}) {
  Map<String, String> optionsList = enabled ? options : {};
  List _options = optionsList.keys.toList();
  List _values = optionsList.values.toList();

  return new Stack(
    children: <Widget>[
      new PopupMenuButton<String>(
        child: new Stack(
          children: <Widget>[
            appThemedTextFieldTwo(
              focusNode: focusNode,
              context: context,
              controller: controller,
              label: label,
              validator: validator,
              obscureText: obscureText,
              onFieldSubmitted: onFieldSubmitted,
              labelStyle: labelStyle,
              borderColor: borderColor,
              enabled: false,
              textStyle: textStyle,
            ),
            new Positioned.fill(
              child: new Container(
                color: Colors.cyanAccent.withOpacity(0.0),
              ),
            ),
          ],
        ),
        onSelected: (String result) {
          controller.text = result;
          if (onValueChanged != null) {
            onValueChanged();
          }
        },
        itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<String>>[]..addAll(
                new List.generate(
                  optionsList.keys.length,
                  (int index) {
                    return new PopupMenuItem<String>(
                      value: _options[index],
                      child: new Text(_values[index]),
                    );
                  },
                ),
              ),
      ),
      new Positioned(
        top: 0.0,
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: new Offstage(
          offstage: optionsList.isNotEmpty,
          child: new Container(
            color: Colors.cyanAccent.withOpacity(0.0),
          ),
        ),
      ),
    ],
  );
}

//getAppThemed AppBar
getAppThemedAppBar(
  context, {
  bool canRouteBack: true,
  Widget title,
  bool automaticallyImplyLeading: true,
  // Widget actionButton,
  titleText: "",
  actions,
}) {
  return AppBar(
    iconTheme: IconThemeData(color: AppColors.primaryColor),
    automaticallyImplyLeading: automaticallyImplyLeading,
    title: Text(
      titleText,
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
    ),
    centerTitle: true,
    actions: actions == null ? [] : actions,
//    elevation: 4.0,
  );
}

Widget chatTextField({
  String label,
  @required TextEditingController controller,
  @required BuildContext context,
  bool obscureText,
  String hint,
  @required FocusNode focusNode,
  TextInputType keyboardType,
  Function(String) validator,
  Function(String) onchange,
  List<TextInputFormatter> inputFormatters,
  Function(String) onFieldSubmitted,
  bool enabled = true,
  bool autoValidate,
  TextStyle textStyle,
  TextStyle labelStyle,
  Color borderColor,
  int maxLines,
  int maxLength,
  Widget suffix,
  Widget prefix,
  TextInputAction inputAction,
  TextCapitalization textCapitalization,
}) {
  // Defaults
  const TextStyle defaultLabelStyle = const TextStyle(
    color: Colors.black,
    fontSize: 14.0,
  );
  final TextStyle defaultTextStyle = new TextStyle(
    //    fontWeight: FontWeight.w600,
    color: enabled ? Colors.black : Colors.black.withOpacity(0.6),
//    fontSize: 18.0,
  );
  final double _height = MediaQuery.of(context).size.height * 0.067;
//    final double defaultHeight = 55;

  return new Card(
    elevation: 2.0,
    color: AppColors.ultraLightBGColor,
//      shape: StadiumBorder(),
//    shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.all(Radius.circular(50))),
    child: new Stack(
      children: <Widget>[
        new Container(
//          constraints: BoxConstraints(
//            maxHeight: 150,
//            minHeight: 0.0
//          ),

          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
          child: new Row(
            children: <Widget>[
              prefix ?? new Container(),
              new SizedBox(
                width: 10,
              ),
              new Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 100,
                    minHeight: 0,
                  ),
                  child: new TextFormField(
                    textInputAction: inputAction ?? TextInputAction.next,
                    controller: controller,
                    textCapitalization:
                        textCapitalization ?? TextCapitalization.none,
                    obscureText: obscureText ?? false,
                    focusNode: focusNode,
                    keyboardType: keyboardType,
                    validator: validator,

                    autovalidate: autoValidate ?? false,

                    inputFormatters: [
                      LengthLimitingTextInputFormatter(maxLength ?? 1000),
                    ]..addAll(inputFormatters ?? []),
                    onFieldSubmitted: onFieldSubmitted,
                    onChanged: onchange,
                    style: textStyle ?? defaultTextStyle,
                    maxLines: null,
                    //maxLines ?? 1,
                    decoration: new InputDecoration(
                      hintText: hint,
                      labelText: label,
                      labelStyle: labelStyle ?? defaultLabelStyle,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                        top: 0.0,
                        bottom: 0.0,
                      ),
                      errorStyle: new TextStyle(
                        fontSize: 10.0,
//                      color: labelStyle?.color ?? defaultLabelStyle?.color,
                      ),
                      helperStyle: new TextStyle(
                        fontSize: 0.0,
                        color: Colors.black,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              suffix ?? new Container(),
            ],
          ),
        ),
        new Positioned.fill(
          child: new Offstage(
            offstage: enabled,
            child: new Container(
              color: Colors.cyanAccent.withOpacity(0.0),
            ),
          ),
        ),
      ],
    ),
  );
}

// Returns no data view
Widget getNoDataView({
  @required String msg,
  TextStyle messageTextStyle,
  @required VoidCallback onRetry,
}) {
  return new Center(
    child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(
          msg ?? "No data found",
          style: messageTextStyle ??
              const TextStyle(
                fontSize: 18.0,
              ),
          textAlign: TextAlign.center,
        ),
        new InkWell(
          onTap: onRetry ?? () {},
          child: new Text(
            "REFRESH",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    ),
  );
}

//get App themed Button
Widget getAppThemedChipButon({@required onTap, @required title}) {
  return Material(
    clipBehavior: Clip.hardEdge,
    shape: StadiumBorder(
      side: BorderSide(
        color: AppColors.primaryColor,
        width: 1.0,
      ),
    ),
    child: InkWell(
      splashColor: AppColors.primaryColor.withOpacity(0.5),
      onTap: onTap,
      child: new Container(
        child: new Text(
          title ?? "",
          style: const TextStyle(color: AppColors.primaryColor, fontSize: 12),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 12.0,
        ),
        decoration: new ShapeDecoration(
          color: Colors.transparent,
          shape: new StadiumBorder(
            side: const BorderSide(
              color: AppColors.primaryColor,
              width: 1.0,
            ),
          ),
        ),
      ),
    ),
  );


}
Widget getButton({String text, onTap, color}) {
  return Material(
    elevation: 0.4,
    clipBehavior: Clip.hardEdge,
    color: color,
    shape: StadiumBorder(),
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        alignment: Alignment.center,
        width: double.maxFinite,
        child: Text(
          text ?? "",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
