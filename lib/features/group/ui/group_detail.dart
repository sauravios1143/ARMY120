/*
import 'dart:math';

import 'package:army120/features/group/bloc/group_bloc.dart';
import 'package:army120/features/group/bloc/group_state.dart';
import 'package:army120/features/group/data/model/group.dart';
import 'package:army120/features/prayers/bloc/prayer_bloc.dart';
import 'package:army120/features/prayers/bloc/prayer_event.dart';
import 'package:army120/features/prayers/bloc/prayer_state.dart';
import 'package:army120/features/prayers/data/model/comment.dart';
import 'package:army120/features/prayers/data/model/new_post_request.dart';
import 'package:army120/features/prayers/data/model/prayer.dart';
import 'package:army120/features/prayers/data/prayer_repository.dart';
import 'package:army120/features/prayers/ui/comments.dart';
import 'package:army120/features/prayers/ui/prayer_detail.dart';
import 'package:army120/features/profile/bloc/profile_bloc.dart';
import 'package:army120/features/profile/data/profile_repository.dart';
import 'package:army120/features/profile/ui/user_detail_screen.dart';
import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/ValidatorFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_appbar.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';


class GroupDetail extends StatefulWidget {
  final Group group;

  GroupDetail({@required this.group});

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  bool _gotData = false;

  List<Prayer> prayerList = [];
  PrayerBloc _prayerBloc;
  int currentPage = 0;
  bool hideNewPostTab = true;
  TextEditingController _prayerController = new TextEditingController();

  final GlobalKey<FormState> _prayerFormKey = new GlobalKey<FormState>();

  //Getters

  get getTopBar {
    return CustomAppBar(
      title: "${widget?.group?.name}",
      trailing: getAppThemedFilledButton(title: "option", onpress: () {}),

    );
  }

  get getCustomDivider {
    return Divider(
      height: 40,
      thickness: 8,
    );
  }

  get getDivider {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Divider(
        height: 1,
        color: Colors.grey,
      ),
    );
  }

  get getBottomAppBar {
    TextStyle style = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              // Text("Created By: ${widget?.group?.}", style: style),
              Text(
               "Created at: ${ getFormattedDateString(
                    dateTime: DateTime.fromMillisecondsSinceEpoch(int.tryParse(widget?.group?.createdAt)*1000,isUtc: true))}",
                style: style,
              )
            ],
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  hideNewPostTab = !hideNewPostTab;
                });
              },
              icon: Icon(
                Icons.edit,
                color: AppColors.primaryColor,
              )),
        ],
      ),
    );
  }

  Widget get getPosts {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      itemCount: 2,
      itemBuilder: (context, i) {
        return getPrayerTile();
      },
      separatorBuilder: (context, i) {
        return getSpacer(height: 10);
      },
    );
  }

  Widget get getPrayerListView {
    double height = getScreenSize(context: context).height;
    return  prayerList?.isEmpty?getNoDataView(msg: "No Post found", onRetry: (){
      getPrayers();
    }): ListView.separated(
      padding: EdgeInsets.symmetric(vertical: height * 0.02),
      itemCount: prayerList.length,
      itemBuilder: (context, i) {
        return getPrayerTile(prayer: prayerList[i]);
      },
      separatorBuilder: (context, i) {
        return getSpacer(height: height * 0.02);
      },
    );
  }

  get geAddPrayerTile {
    return Material(
      color: Colors.black.withOpacity(0.3),
      child: InkWell(
        onTap: () {
          closeKeyboard(context: context, onClose: null);
          setState(() {
            hideNewPostTab = true;
          });
        },
        child: Container(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: getScreenSize(context: context).height * 0.2),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    height: 60,
                    width: 60,
                    child: ClipOval(
                      child: getCachedNetworkImage(url: "${LoggedInUser.getUserDetail?.profilePicture?.thumbnailUrl}",fit: BoxFit.cover),
                    ),
                  ),
                  Expanded(
                    child: Form(
                      key: _prayerFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          chatTextField(
                              context: context,
                              label: "Write your prayer",
                              controller: _prayerController,
                              focusNode: null,
                              validator: (text) {
                                return prayerValidator(prayer: text);
                              }),
                          getSpacer(height: 8),
                          getAppThemedFilledButton(
                              title: "Post",
                              onpress: () {
                                if (_prayerFormKey.currentState.validate()) {
                                  addPost();
                                }
                              })
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: getAppThemedAppBar(context,titleText: "${widget?.group?.name??""}",
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      hideNewPostTab = !hideNewPostTab;
                    });
                  },
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.primaryColor,
                  )),
            ]


          ),
          body: BlocBuilder<PrayerBloc, PrayersState>(
              builder: (context, state) {
            return Builder(
              builder: (context) {
                Widget _child;
                if (state is PrayersFetchSuccessState) {
                  _gotData = true;
                  prayerList = state?.prayer;
                  _child = getPrayerListView;
                } else if (state is FetchingPrayerState ||
                    state is PrayersIdleState) {
                  _child = CustomLoader();
                } else if (state is PrayerErrorState && !_gotData) {
                  _child = getNoDataView(
                      msg: state?.message,
                      onRetry: () {
                        _prayerBloc.add(FetchPrayers());
                      });
                } else {
                  _child = getPrayerListView;
                }

                return _child;
              },
            );
          }),
        ),
        BlocBuilder<GroupBloc, GroupState>(
          builder: (context, state) {
            return (state is GroupUpdatingState)
                ? CustomLoader(
                    isTransparent: false,
                  )
                : Container(
                    height: 0,
                    width: 0,
                  );
          },
        ),
        BlocListener<GroupBloc, GroupState>(
//                  bloc: blocA,
            child: Container(
              height: 0,
              width: 0,
            ),
            listener: (context, state) async {
              if (state is GroupErrorState) {
                showAlert(
                    context: context,
                    titleText: "Error",
                    message: state?.message ?? "",
                    actionCallbacks: {"Ok": () {}});
              }
              if (state is CreateNewGroupSuccess) {
                showAlert(
                    context: context,
                    titleText: "Success",
                    message: state?.response?.message ?? "",
                    actionCallbacks: {"Ok": () {}});
              }

//              if (state is PrayerCommentSuccess) {
//                _commentController.clear();
//                _prayerBloc.add(FetchPrayerDetail(prayerId: widget?.prayerId));
//              }
//              if (state is PrayAlongSuccessState) {
//                onPrayAlongSuccess(state:state);
//              }
            }),
        BlocListener<PrayerBloc, PrayersState>(
//                  bloc: blocA,
            child: Container(
              height: 0,
              width: 0,
            ),
            listener: (context, state) async {
              if (state is PrayerErrorState) {
                showAlert(
                    context: context,
                    titleText: "Error",
                    message: state?.message ?? "",
                    actionCallbacks: {"Ok": () {}});
              }
              if (state is CreateNewPostSuccess) {
                showAlert(
                    context: context,
                    titleText: "Success",
                    message: state?.response?.message ?? "",
                    actionCallbacks: {
                      "Ok": () {
                        setState(() {
                          _prayerController.clear();
                          closeKeyboard(context: context, onClose: () {});
                          hideNewPostTab = true;
                          _prayerBloc.add(
                              FetchPrayersOfGroup(groupId: widget?.group?.id, page: currentPage));
                        });
                      }
                    });
              }
//              if (state is PrayerCommentSuccess) {
//                _commentController.clear();
//                _prayerBloc.add(FetchPrayerDetail(prayerId: widget?.prayerId));
//              }
              if (state is PrayAlongSuccessState) {
                onPrayAlongSuccess(state: state);
              }
            }),
        Offstage(
          offstage: hideNewPostTab,
          child: geAddPrayerTile,
        ),
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
      ],
    );
  }
//Widgets
  Widget getPrayerTile({Prayer prayer}) {
    ValueNotifier<bool> _isExpandedNotifier = new ValueNotifier<bool>(false);
    double _borderRadius = 10;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(_borderRadius),
        splashColor: AppColors.ultraLightBGColor,
        onTap: () async {
          var x = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                return new BlocProvider(
                  create: (context) =>
                      PrayerBloc(prayerRepository: PrayerRepository()),
                  key: Key("key"),
                  child: new PrayerDetailScreen(
                    prayerId: prayer?.id,
                  ),
                );
              }));

          if (x == 1) {
            currentPage = 0;
            getPrayers();
          }
        },
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
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return new BlocProvider(
                                create: (context) =>
                                    ProfileBloc(repository: ProfileRepository()),
                                key: Key("key"),
                                child:
                                new UserDetailScreen(userId: prayer?.user?.id),
                              );
                            }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black),
                        height: 60,
                        width: 60,
                        child: ClipOval(
                            child: getCachedNetworkImage(
                                url: prayer
                                    ?.user?.profilePicture?.thumbnailUrl ??
                                    "",
                                defaultImage: AssetStrings.defaultProfile)),
                      ),
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
                    )
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
//                    ValueListenableBuilder<bool>(
//                        valueListenable: _isExpandedNotifier,
//                        builder: (context, value, _) {
//                          return getCommentList(
//                              commentList: prayer?.comments, isExpanded: value);
//                        }),
//                    ValueListenableBuilder<bool>(
//                        valueListenable: _isExpandedNotifier,
//                        builder: (context, value, _) {
//                          return Offstage(
//                            offstage: (_isExpandedNotifier.value) ||
//                                ((prayer?.comments?.length ?? 0) <= 2),
//                            child: InkWell(
//                              onTap: () {
//                                bool expanvalue = _isExpandedNotifier.value;
//                                _isExpandedNotifier.value = !expanvalue;
//                              },
//                              child: Text(
//                                "See more comments",
//                                style: TextStyle(
//                                    decoration: TextDecoration.underline),
//                              ),
//                            ),
//                          );
//                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //get Like Comment
  getPostListTile({Prayer prayer}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        getLiKeItem(
            onTap: () {
              prayAlong(prayer: prayer);
            },
            text: "${prayer?.prayAlongCount ?? ""}",
            icon: prayer?.iPrayedAlong ?? false
                ? AssetStrings.prayingHandActive
                : AssetStrings.prayingHands,
            isActive: prayer?.iPrayedAlong),
        getLiKeItem(
          text: "${prayer?.commentCount ?? ""}",
          icon: AssetStrings.comment,
          onTap: () {
            */
/*  Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BlocProvider(
                create: (context) =>
                    PrayerBloc(prayerRepository: PrayerRepository()),
                key: Key("key"),
                child: new CommentView(
                  prayerId: prayer?.id,
                ),
              );
            }));*//*

          },
        ),
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
//method return list of Comments
  Widget getCommentList({List<Comments> commentList, isExpanded}) {
    int length;

    if (isExpanded) {
      length = min(6, (commentList?.length ?? 0));
    } else {
      length = min(2, (commentList?.length ?? 0));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(length, (i) {
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
              */
/* child: ListTile(
                leading: ClipOval (
                  child: getCachedNetworkImage(url: commentList[i]?.user?.profilePicture),

                ),
                title:Text( commentList[i]?.text??""),
              ),*//*

              ),
        );
      }),
    );
  }

  //State methods

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_gotData) {
      _prayerBloc = BlocProvider.of<PrayerBloc>(context);
      _prayerBloc.add(
          FetchPrayersOfGroup(groupId: widget?.group?.id, page: currentPage));
    }
  }

  prayAlong({Prayer prayer}) {
    if(LoggedInUser?.user?.userId == prayer?.user?.id){

      return ;
    }
    _prayerBloc.add(PrayAlong(id: prayer?.id));
  }

  //ON PrayerAlong Success
  onPrayAlongSuccess({PrayAlongSuccessState state}) {
    if (state.success) {
      prayerList.forEach((x) {
        if (x.id == state.id) {
          x.iPrayedAlong = true; //!(x.iPrayedAlong);
          //todo  manage count
        }
      });
      setState(() {});
    }
  }

  //Create new Post
  addPost() {
    NewPostRequest _request = NewPostRequest(
        text: _prayerController.text, groupId: widget?.group?.id);
    _prayerBloc.add(CreateNewGroupPost(post: _request));
  }
  sharePrayer(Prayer prayer)async{

    await FlutterShare.share(
      title:"Prayer",
      text:  prayer?.text??"",
//        linkUrl: product?.permalink??"",
      //chooserTitle: 'Example Chooser Title'
    );

  }
  getPrayers(){
    _prayerBloc.add(
        FetchPrayersOfGroup(groupId: widget?.group?.id, page: currentPage));
  }
}
*/
