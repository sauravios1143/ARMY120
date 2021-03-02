import 'dart:math';
import 'package:army120/features/group/bloc/group_bloc.dart';
import 'package:army120/features/group/data/group_repository.dart';
import 'package:army120/features/group/ui/group_listing_screen.dart';
import 'package:army120/features/prayers/bloc/prayer_bloc.dart';
import 'package:army120/features/prayers/bloc/prayer_event.dart';
import 'package:army120/features/prayers/bloc/prayer_state.dart';
import 'package:army120/features/prayers/data/model/comment.dart';
import 'package:army120/features/prayers/data/model/new_post_request.dart';
import 'package:army120/features/prayers/data/model/prayer.dart';
import 'package:army120/features/prayers/data/prayer_repository.dart';
import 'package:army120/features/prayers/ui/comments.dart';
import 'package:army120/features/prayers/ui/prayer_detail.dart';
import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/ValidatorFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:army120/utils/reusableWidgets/paginationLoader.dart';
import 'package:army120/utils/reusableWidgets/prayingHandOverlay.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter/cupertino.dart';

class MyPrayers extends StatefulWidget {
  final int userId;

  MyPrayers({this.userId});

  @override
  _MyPrayersState createState() => _MyPrayersState();
}

class _MyPrayersState extends State<MyPrayers> {
  //Props

  TextEditingController _prayerController = new TextEditingController();
  bool _anonymousValue = false;
  bool _gotData = false;
  int currentPage = 0;
  int perPageCount = 0;
  PrayerBloc _prayerBloc;
  final GlobalKey<FormState> _prayerFormKey = new GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> isLoading = new ValueNotifier<bool>(false);

  List<Prayer> prayerList = [];
  PrayingHandView view = PrayingHandView();


  //Getters
  get geAddPrayerTile {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primaryColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              height: 60,
              width: 60,
            ),
            Expanded(
              child: Form(
                key: _prayerFormKey,
                child: Column(
                  children: <Widget>[
                    chatTextField(
                        context: context,
                        hint: "Write your prayer",
                        controller: _prayerController,
                        focusNode: null,
                        validator: (text) {
                          return prayerValidator(prayer: text);
                        }),
//                    appThemedTextFieldTwo(
//                        context: context,
//                        label: "Write your prayer",
//                        controller: _prayerController,
//                        focusNode: null,
//                        validator: (text) {
//                          return prayerValidator(prayer: text);
//                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Checkbox(
                              activeColor: AppColors.appRed,
                              value: _anonymousValue,
                              onChanged: (x) {
                                setState(() {
                                  _anonymousValue = !_anonymousValue;
                                });
                              },
                            ),
                            Text("Anonymous"),
                          ],
                        ),
                        getAppThemedFilledButton(
                            title: "Post",
                            onpress: () {
                              if (_prayerFormKey.currentState.validate()) {
                                addPost();
                              }
                            })
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
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

  Widget getPrayerTile({Prayer prayer}) {
    ValueNotifier<bool> _isExpandedNotifier = new ValueNotifier<bool>(false);
    double _borderRadius = 10;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(_borderRadius),
        splashColor: AppColors.ultraLightBGColor,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return new BlocProvider(
              create: (context) =>
                  PrayerBloc(prayerRepository: PrayerRepository()),
              key: Key("key"),
              child: new PrayerDetailScreen(
                prayerId: prayer?.id,
              ),
            );
          }));
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
           /* Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BlocProvider(
                create: (context) =>
                    PrayerBloc(prayerRepository: PrayerRepository()),
                key: Key("key"),
                child: new CommentView(
                  prayerId: prayer?.id,
                ),
              );
            }));*/
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
                          url: commentList[i]
                                  ?.user
                                  ?.profilePicture
                                  ?.thumbnailUrl ??
                              ""),
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
              /* child: ListTile(
                leading: ClipOval (
                  child: getCachedNetworkImage(url: commentList[i]?.user?.profilePicture),

                ),
                title:Text( commentList[i]?.text??""),
              ),*/
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
      getPrayers();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_paginationLogic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppThemedAppBar(
        context,
        titleText: "User Posts",
      ),
      body: getPage,
    );
  }

  Widget get getPage {
    double height = getScreenSize(context: context).height;
    return BlocBuilder<PrayerBloc, PrayersState>(builder: (context, state) {
      return Stack(
        children: <Widget>[
//          Column(
//            children: <Widget>[
//              getDivider,
//              geAddPrayerTile,
//              getSpacer(height: height * 0.02),
//              Divider(
//                height: 10,
//                color: Colors.grey[300],
//                thickness: 6,
//              ),
//              Expanded(
//                child: Builder(
//                  builder: (context) {
//                    Widget _child;
//                    if (state is PrayersFetchSuccessState) {
//                      _gotData = true;
//                      prayerList = state?.prayer;
//                      _child = getPrayerListView;
//                    } else if (state is FetchingPrayerState ||
//                        state is PrayersIdleState) {
//                      _child = CustomLoader();
//                    } else if (state is PrayerErrorState && !_gotData) {
//                      _child = getNoDataView(
//                          msg: state?.message,
//                          onRetry: () {
//                            _prayerBloc.add(FetchPrayers());
//                          });
//                    } else {
//                      _child = getPrayerListView;
//                    }
//
//                    return _child;
//                  },
//                ),
//              ),
//            ],
//          ),
          RefreshIndicator(
            onRefresh: () async {
              currentPage = 0;
              getPrayers();
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
//                SliverToBoxAdapter(
//                  child: Column(
//                    children: [
//                      getDivider,
//                      geAddPrayerTile,
//                      getSpacer(height: height * 0.02),
//                      Divider(
//                        height: 10,
//                        color: Colors.grey[300],
//                        thickness: 6,
//                      ),
//                    ],
//                  ),
//                ),
                Builder(
                  builder: (context) {
                    Widget _child;
                    if (state is PrayersFetchSuccessState) {
                      setData(state);
                      _child = getPrayerListView;
                    } else if (state is FetchingPrayerState ||
                        state is PrayersIdleState) {
                      _child = SliverFillRemaining(child: CustomLoader());
                    } else if (state is PrayerErrorState && !_gotData) {
                      _child = SliverFillRemaining(
                        child: getNoDataView(
                            msg: state?.message,
                            onRetry: () {
                              getPrayers();
                            }),
                      );
                    } else {
                      _child = getPrayerListView;
                    }

                    return _child;
                  },
                ),
              ],
            ),
          ),
          BlocListener<PrayerBloc, PrayersState>(
//                  bloc: blocA,
              child: Offstage(
                offstage: state is! PrayerUpdatingState,
                child: CustomLoader(isTransparent: false),
              ),
              listener: (context, state) async {
                if (state is PrayerErrorState) {
                  showAlert(
                      context: context,
                      titleText: "Error",
                      message: state?.message ?? "",
                      actionCallbacks: {"Ok": () {}});
                }

                if (state is PrayAlongSuccessState) {
                  onPrayAlongSuccess(state: state);
                }
                if (state is CreateNewPostSuccess) {
                  showAlert(
                      context: context,
                      titleText: "Success",
                      message: state?.response?.message ?? "",
                      actionCallbacks: {
                        "Ok": () {
                          onCreateNewPostSuccess();
                        }
                      });
                }
              }),
        ],
      );
    });
  }

  Widget get getPrayerListView {
//    double height = getScreenSize(context: context).height;
    return prayerList.isEmpty
        ? SliverFillRemaining(
            child: getNoDataView(msg: "No Prayers found", onRetry: () {
              getPrayers();
            }))
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return index == prayerList.length
                    ? PaginationLoader(loaderNotifier: isLoading)
                    : getPrayerTile(prayer: prayerList[index]);
              },
              childCount: (prayerList?.length ?? 0) + 1,
            ),
          );
    /*return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: height * 0.02),
      itemCount: prayerList.length,
      itemBuilder: (context, i) {
        return getPrayerTile(prayer: prayerList[i]);
      },
      separatorBuilder: (context, i) {
        return getSpacer(height: height * 0.02);
      },
    );*/
  }

  //Create new Post
  addPost() {
    if(isLoggedIn()){
      NewPostRequest _request = NewPostRequest(
          text: _prayerController.text, isAnonymous: _anonymousValue);
      _prayerBloc.add(CreateNewPost(post: _request));
    }else{
      showLoginBottomSheet(context);
    }


  }

  //Pray Along
  prayAlong({Prayer prayer}) {

    if(isLoggedIn()){
      if(LoggedInUser?.user?.userId == prayer?.user?.id){
        return ;
      }
      _prayerBloc.add(PrayAlong(id: prayer?.id));
      view.showPrayingHands(context);

      int index = prayerList.indexOf(prayer);
      if (index != null) {
        prayerList[index].iPrayedAlong = true; //todo count
        view.showPrayingHands(context);

        setState(() {});
      }
    }else{
      showLoginBottomSheet(context);
    }

  }

  //ON PrayerAlong Success
  onPrayAlongSuccess({PrayAlongSuccessState state}) {
    if (state.success) {
      prayerList.forEach((x) {
        if (x.id == state.id) {
          x.iPrayedAlong = true; //!(x.iPrayedAlong);
//          x.prayAlongCount= (x.prayAlongCount??0)+1;
          //todo  manage count
        }
      });
      setState(() {});
    }
  }

  //fetch prayers
  getPrayers() {
    _prayerBloc
        .add(FetchMyPrayers(currentPage: currentPage, userId: widget?.userId));
  }

  //on new post success
  onCreateNewPostSuccess() {
    _prayerController.clear();
    closeKeyboard(context: context, onClose: () {});
    getPrayers();
  }

  sharePrayer(Prayer prayer) async {
    await FlutterShare.share(
      title: "Prayer",
      text: prayer?.text ?? "" + "\nPosted on 120 Army",
//        linkUrl: product?.permalink??"",
      //chooserTitle: 'Example Chooser Title'
    );
  }

  setData(PrayersFetchSuccessState state) {
    print("data set");
    _gotData = true;
    isLoading.value = false;
    if (currentPage == 0) {
      prayerList = state?.prayer;
      perPageCount = state?.prayer?.length ?? 0;
    } else {
      prayerList.addAll(state?.prayer);
    }
  }

  //pagination logic
  _paginationLogic() async {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
//      print("totalRecode ${totalRecord} " +
//          "current page ${currentPage} length = ${actionList?.length} perpageCount ${totalRecord}");

      print("Paginatig");
      if ((prayerList?.length ?? 0) >= (perPageCount * currentPage ?? 0)) {
        if (!isLoading.value) //is not loading
        {
          isLoading.value = true;
          currentPage++;
          getPrayers();
        }
      }
    }
  }
}
