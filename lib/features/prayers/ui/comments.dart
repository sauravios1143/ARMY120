
import 'package:army120/features/prayers/bloc/prayer_bloc.dart';
import 'package:army120/features/prayers/bloc/prayer_event.dart';
import 'package:army120/features/prayers/bloc/prayer_state.dart';
import 'package:army120/features/prayers/data/model/comment.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:flutter/material.dart';
import "package:flutter_bloc/flutter_bloc.dart";

class CommentView extends StatefulWidget {
  final int prayerId;

  CommentView({this.prayerId});

  @override
  _CommentViewState createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  bool _gotData = false;
  List<Comments> commentList = [];
  ValueNotifier<bool> textNotifier = ValueNotifier(false);
  TextEditingController _messageController = TextEditingController();
  PrayerBloc paryerBloc;

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
            valueListenable: textNotifier,
            builder: (context, value, _) {
              return Material(
                clipBehavior: Clip.hardEdge,
                color: value
                    ? AppColors.primaryColor
                    : AppColors.ultraLightBGColor,
                shape: CircleBorder(),
                child: InkWell(
                  onTap: () {
                    addComment();
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
//          Material(
//            clipBehavior: Clip.hardEdge,
//            color: AppColors.primaryColor,
//            shape: CircleBorder(),
//            child: InkWell(
//              onTap: () {
//                sendMessage();
//              },
//              child: Padding(
//                padding: const EdgeInsets.all(12.0),
//                child: Icon(
//                  Icons.near_me,
//                  color: Colors.white,
//                ),
//              ),
//            ),
//          )
        ],
      ),
    );
  }

//state methods
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_gotData) {
      paryerBloc = BlocProvider.of<PrayerBloc>(context);
      fetchComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeKeyboard(context: context, onClose: () {});
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: getAppThemedAppBar(
              context,
              titleText: "Comments",
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: BlocBuilder<PrayerBloc, PrayersState>(
                        builder: (context, state) {
                      return Builder(
                        builder: (context) {
                          Widget _child;
                          if (state is PrayerDetailSuccessState) {
                            setData(state: state);
                            _child = getCommentList;
                          } else if (state is FetchingPrayerState ||
                              state is PrayersIdleState) {
                            _child = Center(child: CircularProgressIndicator());
                          } else if (state is PrayerErrorState && !_gotData) {
                            _child = getNoDataView(
                                msg: state?.message, onRetry: () {});
                          } else {
                            _child = getCommentList;
                          }

                          return _child;
                        },
                      );
                    }),
                  ),
                  _getComposer
                ],
              ),
            ),
          ),
          BlocListener<PrayerBloc, PrayersState>(
              child: Container(
                height: 0,
                width: 0,
              ),
              listener: (context, state) async {
                if (state is PrayerErrorState) {
                  showAlert(
                      context: context,
                      titleText: "Error",
                      message: state?.message,
                      actionCallbacks: {"ok": () {}});
                }
                if (state is PrayerCommentSuccess) {
                  onCommentSuccess();
                }
              })
        ],
      ),
    );
  }



  Widget get getCommentList {
    return ListView.separated(
        reverse: true,
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 16),
        itemBuilder: (context, i) {
          return getCommentItem(commentList[i]);
        },
        separatorBuilder: (context, i) {
          return Container(
            height: 10,
          );
        },
        itemCount: commentList?.length ?? 0);


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
              Container(
                height: 50,
                width: 50,
                child: ClipOval(
                  child: getCachedNetworkImage(
                      url: comment?.user?.profilePicture?.thumbnailUrl ?? "",fit:BoxFit.cover),
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
                     "${comment?.user?.firstName ?? ""} ${comment?.user?.lastName??""}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 8,),
                    Text(comment?.text ?? ""),
                    SizedBox(height: 8,),

                    Align(
                      alignment: Alignment.centerLeft,
                        child: Text(getFormattedDateString(dateTime: DateTime.tryParse(comment?.postedAt)),style: TextStyle(
                          color: Colors.grey,fontSize: 10

                        ),)),
                  ],
                ),
              ),
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

  /* Widget get getCommentList {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(commentList?.length ?? 0, (i) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Container(
              decoration: BoxDecoration(
                  color: AppColors.ultraLightBGColor,
                  borderRadius: BorderRadius.circular(4)),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    child: ClipOval(
                      child: getCachedNetworkImage(
                          url: commentList[i]?.user?.profilePicture ?? ""),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(commentList[i]?.text ?? ""),
                  ),
                ],
              )
              */ /* child: ListTile(
                leading: ClipOval (
                  child: getCachedNetworkImage(url: commentList[i]?.user?.profilePicture),

                ),
                title:Text( commentList[i]?.text??""),
              ),*/ /*
              ),
        );
      }),
    );
  }*/

  //return chat text field
  Widget get getChatField {
    return chatTextField(
        inputAction: TextInputAction.newline,
        controller: _messageController,
        context: context,
        onchange: changeValue,
        hint: "Type your message here",
        focusNode: null);
  }

  //on change fields text
  changeValue(String text) {
    if (text?.trim()?.isEmpty) {
      textNotifier.value = false;
    } else {
      textNotifier.value = true;
    }
  }

  //set Data
  setData({PrayerDetailSuccessState state}) {
    _gotData = true;
    commentList = state?.prayer?.comments ?? [];
  }

  //Add comment to prayer
  addComment() async {
    paryerBloc.add(CommentOnPrayer(
        comment: _messageController?.text ?? "", prayerId: widget?.prayerId));
  }

  fetchComments({bool isSilent: false}) {
    paryerBloc
        .add(FetchPrayerDetail(prayerId: widget?.prayerId, isSilent: isSilent));
  }

  onCommentSuccess() {
    _messageController?.clear();
    fetchComments(isSilent: true);
  }
}
