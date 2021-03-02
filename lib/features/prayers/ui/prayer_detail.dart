import 'package:army120/features/prayers/bloc/prayer_bloc.dart';
import 'package:army120/features/prayers/bloc/prayer_event.dart';
import 'package:army120/features/prayers/bloc/prayer_state.dart';
import 'package:army120/features/prayers/data/model/comment.dart';
import 'package:army120/features/prayers/data/model/new_post_request.dart';
import 'package:army120/features/prayers/data/model/prayer.dart';
import 'package:army120/features/profile/bloc/profile_bloc.dart';
import 'package:army120/features/profile/data/profile_repository.dart';
import 'package:army120/features/profile/ui/user_detail_screen.dart';
import 'package:army120/utils/ValidatorFunctions.dart';
import 'package:army120/utils/reusableWidgets/prayingHandOverlay.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum prayerAction { delete, editOrReport }
enum commentAction { delete, report }

class PrayerDetailScreen extends StatefulWidget {
  final int prayerId;
  final bool isComment;



  PrayerDetailScreen({this.prayerId, this.isComment: false});

  @override
  _PrayerDetailScreenState createState() => _PrayerDetailScreenState();
}

class _PrayerDetailScreenState extends State<PrayerDetailScreen> {
  //Props

  TextEditingController _messageController = new TextEditingController();

  // final GlobalKey<FormState> _commentFormKey = new GlobalKey<FormState>();
  TextEditingController _prayerController = new TextEditingController();
  final GlobalKey<FormState> _prayerFormKey = new GlobalKey<FormState>();

  PrayerBloc _prayerBloc;
  bool isSilent;
  ValueNotifier<bool> canSendNotifier = ValueNotifier(false);
  Prayer prayerDetail;
  PrayingHandView view = PrayingHandView();
  //Getters

  Widget get getDivider {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Divider(
        height: 1,
        color: Colors.grey,
      ),
    );
  }

  Widget get getPrayerDetailView {
    return Stack(
      children: <Widget>[
        getPage,
        BlocBuilder<PrayerBloc, PrayersState>(
          builder: (context, state) {
            return (state is PrayerUpdatingState)
                ? CustomLoader(
                    isTransparent: false,
                  )
                : Container(
                    height: 0,
                    width: 0,
                  );
          },
        ),
        BlocListener<PrayerBloc, PrayersState>(
//                  bloc: blocA,
            child: Container(
              height: 0,
              width: 0,
            ),
            listener: (context, state) async {
              onTextChange(_prayerController?.text);
              if (state is PrayerErrorState) {
                showAlert(
                    context: context,
                    titleText: "Error",
                    message: state?.message ?? "",
                    actionCallbacks: {"Ok": () {}});
              }
              if (state is PrayerCommentSuccess) {
                refreshInBackground();
              }
              if (state is PrayAlongSuccessState) {
                onPrayAlongSuccess(state: state);
              }
              if (state is PrayerDeleteSuccessState) {
                Navigator.pop(context, 1);
              }
              if (state is PrayerUpdateSuccessState) {
                refreshInBackground();
              }
            })
      ],
    );
  }

  //getters
  Widget get _getComposer {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: getChatField,
          ),
          ValueListenableBuilder(
            valueListenable: canSendNotifier,
            builder: (context, value, _) {
              return Material(
                clipBehavior: Clip.hardEdge,
                color: value
                    ? AppColors.primaryColor
                    : AppColors.ultraLightBGColor,
                shape: CircleBorder(),
                child: InkWell(
                  onTap: () {
                    value ? addComment() : null;
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.near_me,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  //get Page view
  Widget get getPage {
    double height = getScreenSize(context: context).height;
    return Column(
      children: [
        getPrayerCard(prayer: prayerDetail),
        Expanded(child: getCommentList),
        _getComposer
      ],
    );
  }

  //return chat text field
  Widget get getChatField {
    return chatTextField(
        inputAction: TextInputAction.newline,
        controller: _messageController,
        context: context,
        onchange: onTextChange,
        hint: "Add comment",
        focusNode: null);
  }

  //get Like Comment
  getPostListTile({Prayer prayer}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        getLiKeItem(
            onTap: () {
              prayAlong();
            },
            text: "${prayer?.prayAlongCount ?? ""}",
            icon: prayer?.iPrayedAlong ?? false
                ? AssetStrings.prayingHandActive
                : AssetStrings.prayingHands,
            isActive: prayer?.iPrayedAlong),
        /*   getLiKeItem(
          text: "${prayer?.commentCount ?? ""}",
          icon: AssetStrings.comment,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BlocProvider(
                create: (context) =>
                    PrayerBloc(prayerRepository: PrayerRepository()),
                key: Key("key"),
                child: new CommentView(
                  prayerId: prayer?.id,
                ),
              );
            }));
          },
        ),*/
        getLiKeItem(
            text: "",
            icon: AssetStrings.share,
            onTap: () {
              sharePrayer(prayer);
            }),
      ],
    );
  }

  getLiKeItem({icon, text, isActive: false, onTap}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
            onTap: onTap,
            child: Image.asset(
              icon,
              height: 25,
              width: 25,
            )),
        SizedBox(
          width: 5,
        ),
        Text(
          text ?? "",
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  //get comment list
  Widget get getCommentList {
    return ListView.separated(
        shrinkWrap: true,
        reverse: false,
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 16),
        itemBuilder: (context, i) {
          return getCommentItem(prayerDetail?.comments[i]);
        },
        separatorBuilder: (context, i) {
          return Container(
            height: 10,
          );
        },
        itemCount: prayerDetail?.comments?.length ?? 0);
  }

  //State methods

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (prayerDetail == null) {
      _prayerBloc = BlocProvider.of<PrayerBloc>(context);
      _prayerBloc.add(FetchPrayerDetail(
          prayerId: widget?.prayerId, isComment: widget?.isComment));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = getScreenSize(context: context).height;
    return GestureDetector(
      onTap: () {
        closeKeyboard(context: context, onClose: () {});
      },
      child: Scaffold(
        appBar: getAppThemedAppBar(
          context,
          titleText: "Prayer Detail",
        ),
        body: BlocBuilder<PrayerBloc, PrayersState>(
//        bloc: _prayerBloc,
          builder: (context, state) {
            print("State $state");
            Widget _child;

            if (state is PrayerDetailSuccessState) {
              prayerDetail = state?.prayer;
              _child = getPrayerDetailView;
            } else if (state is FetchingPrayerState ||
                state is PrayersIdleState) {
              _child = CustomLoader();
            } else if (state is PrayerErrorState && prayerDetail == null) {
              _child = getNoDataView(
                  msg: state?.message,
                  onRetry: () {
                    _prayerBloc
                        .add(FetchPrayerDetail(prayerId: widget?.prayerId));
                  });
            } else {
              _child = getPrayerDetailView;
            }
            return _child;
          },
        ),
      ),
    );
  }

  // prayer card
  Widget getPrayerCard({Prayer prayer}) {
    ValueNotifier<bool> _isExpandedNotifier = new ValueNotifier<bool>(false);
    double _borderRadius = 10;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          border: Border.all(color: AppColors.appGrey),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    height: 60,
                    width: 60,
                    child: ClipOval(
                        child: getCachedNetworkImage(
                            url: prayer?.user?.profilePicture?.thumbnailUrl ??
                                "",
                            defaultImage: AssetStrings.defaultProfile)),
                  ),
                  getSpacer(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${prayer?.user?.firstName ?? ""} ${prayer?.user?.lastName ?? ""}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                              "${getFormattedDateString(dateTime: DateTime.fromMillisecondsSinceEpoch(int.tryParse(prayer?.postedAt)*1000))}"),
                        ),
                      ],
                    ),
                  ),
                  prayerPopUpButton(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(prayer?.text ?? ""),
                  getDivider,
                  getPostListTile(prayer: prayer),
                  getDivider,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget prayerPopUpButton() {
    return PopupMenuButton(
      enabled: isLoggedIn(),
      itemBuilder: (context) {
        return LoggedInUser.getUserDetail?.id != prayerDetail?.user?.id
            ? [
                PopupMenuItem(
                  child: Text(
                      LoggedInUser.getUserDetail?.id == prayerDetail?.user?.id
                          ? "Edit"
                          : "Report"),
                  value: prayerAction.editOrReport,
                ),
              ]
            : [
                PopupMenuItem(
                  child: Text(
                      LoggedInUser.getUserDetail?.id == prayerDetail?.user?.id
                          ? "Edit"
                          : "Report"),
                  value: prayerAction.editOrReport,
                ),
                PopupMenuItem(
                  child: Text("Delete"),
                  value: prayerAction.delete,
                ),
              ];
      },
      onSelected: (prayerAction value) {
        switch (value) {
          case prayerAction.delete:
            deletePrayer();
            break;
          case prayerAction.editOrReport:
            LoggedInUser.getUserDetail?.id == prayerDetail?.user?.id
                ? editPrayer()
                : reportPrayer();
            break;
        }
      },
    );
  }

  Widget commentPopUpButton(Comments comment) {
    return PopupMenuButton(
      enabled: isLoggedIn(),
      itemBuilder: (context) {
        return [
          (comment?.user?.id == LoggedInUser?.user?.userId)
              ? PopupMenuItem(
                  child: Text("Delete"),
                  value: commentAction.delete,
                )
              : PopupMenuItem(
                  child: Text("Report"),
                  value: commentAction.report,
                )
        ];
      },
      onSelected: (commentAction value) {
        switch (value) {
          case commentAction.delete:
            deleteComment(comment: comment);
            break;
          case commentAction.report:
            reportComment(comment: comment);
            break;
        }
      },
    );
  }

  //Add comment to prayer
  addComment() async {
    if (isLoggedIn()) {
      canSendNotifier?.value = false;
      _prayerBloc.add(CommentOnPrayer(
          comment: _messageController?.text ?? "", prayerId: prayerDetail?.id));
    } else {
      showLoginBottomSheet(context);
    }
  }

  //ON PrayerAlong Success
  onPrayAlongSuccess({PrayAlongSuccessState state}) {
    if (state.success) {
      prayerDetail.iPrayedAlong = true; //todo manage count
      setState(() {});
    }
  }

  //Pray Along

  //Pray Along
  prayAlong({Prayer prayer}) {
    print("was here");
    if (isLoggedIn()) {
      if(LoggedInUser?.user?.userId == prayer?.user?.id){
        return ;
      }

      _prayerBloc.add(PrayAlong(id: prayer?.id));

      if (prayerDetail.iPrayedAlong ?? false) {
        prayerDetail.iPrayedAlong = false;
        prayerDetail.prayAlongCount =
            (prayerDetail?.prayAlongCount ?? 0) - 1; //todo count
      } else {
        view.showPrayingHands(context);

        prayerDetail.iPrayedAlong = true;
        prayerDetail.prayAlongCount =
            (prayerDetail?.prayAlongCount ?? 0) + 1; //todo count

      }

      setState(() {});
    } else {
      showLoginBottomSheet(context);
    }
  }

  getCommentItem(Comments comment) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
          decoration: BoxDecoration(
//              color: AppColors.ultraLightBGColor,
              borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return new BlocProvider(
                      create: (context) =>
                          ProfileBloc(repository: ProfileRepository()),
                      key: Key("key"),
                      child: new UserDetailScreen(
                        userId: comment?.user?.id,
                      ),
                    );
                  }));
                },
                child: Container(
                  height: 50,
                  width: 50,
                  child: ClipOval(
                    child: getCachedNetworkImage(
                        url: comment?.user?.profilePicture?.thumbnailUrl ?? "",
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${comment?.user?.firstName ?? ""} ${comment?.user?.lastName ?? ""}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(comment?.text ?? ""),
                    SizedBox(
                      height: 8,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          getFormattedDateString(dateTime: DateTime.fromMillisecondsSinceEpoch(int.tryParse(comment?.postedAt)*1000)),
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        )),
                  ],
                ),
              ),
              commentPopUpButton(comment),
            ],
          )
          /* child: ListTile(
                leading: ClipOval (
                  child: getCachedNetworkImage(url: commentList[i]?.user?.profilePicture),

                ),
                title:Text( commentList[i]?.text??""),
              ),*/
          ),
    );
  }

  //share prayer
  sharePrayer(Prayer prayer) async {
    await FlutterShare.share(
      title: "Prayer",
      text: prayer?.text ?? "" + "\nPosted on 120 Army",
//        linkUrl: product?.permalink??"",
      //chooserTitle: 'Example Chooser Title'
    );
  }

  //on change fields text
  onTextChange(String text) {
    if (text?.trim()?.isEmpty) {
      canSendNotifier.value = false;
    } else {
      canSendNotifier.value = true;
    }
  }

  refreshInBackground() {
    _messageController.clear();
    canSendNotifier.value = false;
    _prayerBloc
        .add(FetchPrayerDetail(prayerId: widget?.prayerId, isSilent: true));
  }

  deletePrayer() {
    _prayerBloc.add(DeletePost(postId: prayerDetail?.id));
  }

  reportPrayer() {
    _prayerBloc.add(ReportPost(postId: prayerDetail?.id));
  }

  editPrayer() {
    print("edit");
    _prayerController?.text = prayerDetail?.text;
    showDialog(
        context: context,
        builder: (dialogContext) {
          return geAddPrayerTile(dialogContext);
        });
  }

  Widget geAddPrayerTile(BuildContext dialogcontext) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: AppColors.popUpBGColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _prayerFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Edit Prayer",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              getSpacer(height: 8),
              chatTextField(
                  context: context,
                  hint: "Write your prayer",
                  controller: _prayerController,
                  focusNode: null,
                  validator: (text) {
                    return prayerValidator(prayer: text);
                  }),
              getSpacer(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(dialogcontext);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                  FlatButton(
                      onPressed: () {
                        if (_prayerFormKey.currentState.validate()) {
                          Navigator.pop(dialogcontext);
                          //todo add method
                          updatePost();
                        }
                      },
                      child: Text(
                        "Update",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void reportComment({Comments comment}) {
    _prayerBloc.add(ReportComment(commentId: comment?.id));
  }

  void updatePost() {
    _prayerBloc.add(UpdatePost(
        post: NewPostRequest(text: _prayerController?.text),
        postId: prayerDetail?.id));
  }

  void deleteComment({Comments comment}) {
    _prayerBloc.add(DeleteComment(commentId: comment?.id));
  }
}
