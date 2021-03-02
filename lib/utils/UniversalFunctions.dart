import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_share/flutter_share.dart';

//import 'package:cached_network_image/cached_network_image.dart';
import 'package:army120/features/auth/bloc/auth_bloc.dart';
import 'package:army120/features/auth/data/auth_repository.dart';
import 'package:army120/features/auth/ui/login_required_view.dart';
import 'package:army120/features/auth/ui/login_screen.dart';
import 'package:army120/features/challenges/bloc/challenge_bloc.dart';
import 'package:army120/features/challenges/data/challenge_repository.dart';
import 'package:army120/features/challenges/ui/accept_group_challenge.dart';
import 'package:army120/features/notifications/data/model/notification.dart';
import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/memory_management.dart';
import 'package:army120/utils/navigation/custom_navigation.dart';
import 'package:army120/utils/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


// Todo: actual

bool alertAlreadyActive = false;
const Color dialogContentColor = Colors.black;


// Returns screen size
Size getScreenSize({@required BuildContext context}) {
  return MediaQuery.of(context).size;
}

// Returns status bar height
double getStatusBarHeight({@required BuildContext context}) {
  return MediaQuery.of(context).padding.top;
}

bool isAndroidPlatform({@required BuildContext context}) {
  if (Platform.isAndroid) {
    return true;
  } else {
    return false;
  }
}

// Returns bottom padding for round edge screens
double getSafeAreaBottomPadding({@required BuildContext context}) {
  return MediaQuery.of(context).padding.bottom;
}

// Returns Keyboard size
bool isKeyboardOpen({@required BuildContext context}) {
  return MediaQuery.of(context).viewInsets.bottom > 0.0;
}



// Custom Push And Remove Until Splash
void customPushAndRemoveUntilSplash({
  @required BuildContext context,
}) {
/*  Navigator.pushAndRemoveUntil(
    context,
    new CupertinoPageRoute(builder: (BuildContext context) {
      return new Splash();
    }),
    (route) => false,
  );*/

//  Navigator.popUntil(
//    context,
//        (route) {
//      return route.runtimeType == Splash();
//    },
//  );
//  Navigator.push(context, new CupertinoPageRoute(builder: (BuildContext context) {
//    return new Splash();
//  }));
}


// Returns datetime parsing string of format "MM/dd/yy"
DateTime getDateFromString({
  @required String dateString,
}) {
  try {
    return DateTime.parse(dateString);
  } catch (e) {
    return DateTime.now();
  }
}

// CONVERTS DOUBLE INTO RADIANS
num getRadians({@required double value}) {
  return value * (3.14 / 180);
}


// Checks target platform
bool isAndroid() {
  return defaultTargetPlatform == TargetPlatform.android;
}

// Asks for exit
Future<bool> askForExit() async {
//  if (canExitApp) {
//    exit(0);
//    return Future.value(true);
//  } else {
//    canExitApp = true;
//    Fluttertoast.showToast(
//      msg: "Please click BACK again to exit",
//      toastLength: Toast.LENGTH_LONG,
//      gravity: ToastGravity.BOTTOM,
//    );
//    new Future.delayed(
//        const Duration(
//          seconds: 2,
//        ), () {
//      canExitApp = false;
//    });
//    return Future.value(false);
//  }
}



// Returns platform specific back button icon
IconData getPlatformSpecificBackIcon() {
  return defaultTargetPlatform == TargetPlatform.iOS
      ? Icons.arrow_back_ios
      : Icons.arrow_back;
}

// Sets name fields
String setName({
  @required String firstName,
  @required String lastName,
}) {
  return (getFirstLetterCapitalized(source: (firstName ?? "")) +
          " " +
          getFirstLetterCapitalized(source: (lastName ?? "")))
      .trim();
}

// Returns first letter capitalized of the string
String getFirstLetterCapitalized({@required String source}) {
  if (source == null && (source?.isNotEmpty ?? true)) {
    return "";
  } else {
    print("source: $source");
    String result = source.toUpperCase().substring(0, 1);
    if (source.length > 1) {
      result = result + source.toLowerCase().substring(1, source.length);
    }
    return result;
  }
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
      color: color ?? AppColors.appRed,
      strokeWidth: strokeWidth,
    ),
  );
}

// Returns app themed list view loader
Widget getChildLoader({
  Color color,
  double strokeWidth,
}) {
  return new Center(
    child: new CircularProgressIndicator(
      backgroundColor: Colors.transparent,
      valueColor: new AlwaysStoppedAnimation<Color>(
        color ?? Colors.white,
      ),
      strokeWidth: strokeWidth ?? 6.0,
    ),
  );
}

// Checks Internet connection
Future<bool> hasInternetConnection({
  @required BuildContext context,
  bool mounted,
  @required Function onSuccess,
  @required Function onFail,
  bool canShowAlert = true,
}) async {
  try {
    final result = await InternetAddress.lookup('google.com')
        .timeout(const Duration(seconds: 5));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      onSuccess();
      return true;
    } else {
      if (canShowAlert) {
        onFail();
        /* showAlert(
          context: context,
          titleText: Localization.of(context).trans(LocalizationValues.error),
          message: Messages.noInternetError,
          actionCallbacks: {
            Localization.of(context).trans(LocalizationValues.ok): () {
              return false;
            }
          },

        );*/
      }
    }
  } catch (_) {
    onFail();
    /*  showAlert(
        context: context,
        titleText: Localization.of(context).trans(LocalizationValues.error),
        message: Messages.noInternetError,
        actionCallbacks: {
          Localization.of(context).trans(LocalizationValues.ok): () {
            return false;
          }
        });*/
  }
  return false;
}



// Closes keyboard by clicking any where on screen
void closeKeyboard({
  @required BuildContext context,
  @required VoidCallback onClose,
}) {
  FocusScope.of(context).requestFocus(new FocusNode());
  if(onClose!=null){
    onClose();
  }

//  if (isKeyboardOpen(context: context)) {
//    FocusScope.of(context).requestFocus(new FocusNode());
//    try {
//      onClose();
//    } catch (e) {}
//  }
}
// Sets focus node
void setFocusNode({
  @required BuildContext context,
  @required FocusNode focusNode,
}) {
  FocusScope.of(context).requestFocus(focusNode);
}


//void launchUrl(String url) async {
////
//  print("launch url $url");
//  if (await canLaunch(url)) {
//    await launch(url);
//  } else {
//    print('Could not launch $url');
//  }
//}

String readTimestamp(String timestamp) {
  var now = new DateTime.now();
  var format = new DateFormat('hh:mm a');
  var date =
      new DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp) * 1000);
  var diff = date.difference(now);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + 'DAY AGO';
    } else {
      time = diff.inDays.toString() + 'DAYS AGO';
    }
  }

  return time;
}


// Returns formatted date string
String getFormattedDateString({
  String format,
  @required DateTime dateTime,
}) {
  return dateTime != null
      ? new DateFormat(format ?? "MMM dd, y").format(dateTime)
      : "-";
}


// Show alert dialog
void showAlert(
    {@required BuildContext context,
      String titleText,
      Widget title,
      String message,
      Widget content,
      Map<String, VoidCallback> actionCallbacks}) {
  Widget titleWidget = titleText == null
      ? title
      : new Text(
    titleText.toUpperCase(),
    textAlign: TextAlign.center,
    style: new TextStyle(
      color: dialogContentColor,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    ),
  );
  Widget contentWidget = message == null
      ? content != null ? content : new Container()
      : new Text(
    message,
    textAlign: TextAlign.center,
    style: new TextStyle(
      color: dialogContentColor,
      fontWeight: FontWeight.w400,
//            fontFamily: Constants.contentFontFamily,
    ),
  );

  OverlayEntry alertDialog;
  // Returns alert actions
  List<Widget> _getAlertActions(Map<String, VoidCallback> actionCallbacks) {
    List<Widget> actions = [];
    actionCallbacks.forEach((String title, VoidCallback action) {
      actions.add(
        new ButtonTheme(
          minWidth: 0.0,
          child: new CupertinoDialogAction(
            child: new Text(title,
                style: new TextStyle(
                  color: dialogContentColor,
                  fontSize: 16.0,
//                        fontFamily: Constants.contentFontFamily,
                )),
            onPressed: () {
              action();
              alertDialog?.remove();
              alertAlreadyActive = false;
            },
          ),
//          child: defaultTargetPlatform != TargetPlatform.iOS
//              ? new FlatButton(
//                  child: new Text(
//                    title,
//                    style: new TextStyle(
//                      color: IfincaColors.kPrimaryBlue,
////                      fontFamily: Constants.contentFontFamily,
//                    ),
//                    maxLines: 2,
//                  ),
//                  onPressed: () {
//                    action();
//                  },
//                )
//              :
// new CupertinoDialogAction(
//                  child: new Text(title,
//                      style: new TextStyle(
//                        color: IfincaColors.kPrimaryBlue,
//                        fontSize: 16.0,
////                        fontFamily: Constants.contentFontFamily,
//                      )),
//                  onPressed: () {
//                    action();
//                  },
//                ),
        ),
      );
    });
    return actions;
  }

  List<Widget> actions =
  actionCallbacks != null ? _getAlertActions(actionCallbacks) : [];

  OverlayState overlayState;
  overlayState = Overlay.of(context);

  alertDialog = new OverlayEntry(builder: (BuildContext context) {
    return new Positioned.fill(
      child: new Container(
        color: Colors.black.withOpacity(0.7),
        alignment: Alignment.center,
        child: new WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: new Dialog(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: new Material(
              borderRadius: new BorderRadius.circular(10.0),
              color: Colors.white,
              child: new Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                            ),
                            child: titleWidget,
                          ),
                          contentWidget,
                        ],
                      ),
                    ),
                    new Container(
                      height: 0.6,
                      margin: new EdgeInsets.only(
                        top: 24.0,
                      ),
                      color: dialogContentColor,
                    ),
                    new Row(
                      children: <Widget>[]..addAll(
                        new List.generate(
                          actions.length +
                              (actions.length > 1 ? (actions.length - 1) : 0),
                              (int index) {
                            return index.isOdd
                                ? new Container(
                              width: 0.6,
                              height: 30.0,
                              color: dialogContentColor,
                            )
                                : new Expanded(
                              child: actions[index ~/ 2],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  });

  if (!alertAlreadyActive) {
    alertAlreadyActive = true;
    overlayState.insert(alertDialog);
  }
}
bool isLoggedIn() {
  bool result = MemoryManagement?.getIsUserLoggedIn() ?? false;
  print("logged in Result ${result}");
  return result;
}
bool isSkipped() {
  bool result = MemoryManagement?.getISSkipped() ?? false;
  print("logged in Result ${result}");
  return result;
}

void onLogoutSuccess(BuildContext context){
  MemoryManagement.clearMemory();
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
    builder: (context){
      return BlocProvider(
        create: (context)=>AuthBloc(repository: AuthRepository()),
          child: LoginScreen());
    }
  ), (Route<dynamic> route) => false);

}

// Checks Internet connection for "POST" method
Future<bool> checkInternetForPostMethod({
  @required Function onSuccess,
  @required Function onFail,
}) async {
  try {
    final result = await InternetAddress.lookup('google.com')
        .timeout(const Duration(seconds: 5));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      onSuccess();
      return true;
    } else {
      onFail();

      return false;
    }
  } catch (_) {
    onFail();
    return false;
  }

}

String capitalize({String value:""}) {
  return "${value[0].toUpperCase()}${value.substring(1)}";
}

String getCategoryAsset({String identifier}) {
  String assetString = "";
  switch (identifier) {
    case "town":
      assetString = AssetStrings.town;
      break;
    case "church":
      assetString = AssetStrings.marriage;
      break;
    case "general":
      assetString = AssetStrings.general;
      break;
    case "parenting":
      assetString = AssetStrings.parenting;
      break;
    case "marriage":
      assetString = AssetStrings.marriage;
      break;
  }

  return assetString;
}

//show bottom sheet
showLoginBottomSheet(context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return BottomSheet(
        builder: (context) {
          return LoginRequiredView();
        },
        onClosing: () {},
      );
    },
    // isDismissible: false,
    enableDrag: false,
  );
}
showAcceptChallengeSheet(NotificationItem category,context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return BottomSheet(
        builder: (context) {
          return BlocProvider(
              create: (BuildContext context) =>
                  ChallengeBloc(repository: ChallengeRepository()),
              child: AcceptGroupChallenge(identifier: category?.data?.identifier,));
        },
        onClosing: () {},
      );
    },
    // isDismissible: false,
    enableDrag: false,
  );
}
onSessionExpire(){
  NavigationService().navigateTo(AppRoutes?.login);
}



