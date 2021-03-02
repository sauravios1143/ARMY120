import 'package:army120/features/group/bloc/group_bloc.dart';
import 'package:army120/features/group/bloc/group_event.dart';
import 'package:army120/features/group/bloc/group_state.dart';
import 'package:army120/features/group/data/group_repository.dart';
import 'package:army120/features/group/data/model/group.dart';
import 'package:army120/features/group/data/revenukat_services.dart';
import 'package:army120/features/group/ui/create_new_croup.dart';
import 'package:army120/features/group/ui/group_detail.dart';
import 'package:army120/features/group/ui/add_member.dart';
import 'package:army120/features/group/ui/group_preview.dart';
import 'package:army120/features/prayers/bloc/prayer_bloc.dart';
import 'package:army120/features/prayers/data/prayer_repository.dart';
import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:army120/utils/Constants/enumConst.dart';

import 'new_group_deail.dart';

class GroupListing extends StatefulWidget {
  @override
  _GroupListingState createState() => _GroupListingState();
}

class _GroupListingState extends State<GroupListing> {
  //Props
  bool _gotData = false;
  FocusNode _searchFocus = new FocusNode();
  TextEditingController _searchController = new TextEditingController();

  List<Group> groupList = [];

  List<Group> freeList = [];
  List<Group> paidList = [];
  GroupBloc _prayerBloc;

  //getters

  Widget get getHeader {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: <Widget>[
          getAddGroupItem(),
          Text(
            "Groups",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget get getGroupLists {
    return RefreshIndicator(
      onRefresh: () async {
        fetchGroups();
      },
      child: CustomScrollView(
        slivers: [
          getListHeader("Groups", offstage: freeList.isEmpty),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, i) {
              return groupItem(group: freeList[i]);
            },
            childCount: freeList.length,
          )),
          getListHeader("Communities", offstage: paidList.isEmpty),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, i) {
              return groupItem(group: paidList[i]);
            },
            childCount: paidList.length,
          ))
        ],
      ),
    );
  }

  Widget get getSearchField {
    return appThemedTextFieldTwo(
        label: "Search",
        controller: _searchController,
        context: context,
        focusNode: _searchFocus,
        onChange: onTextChange,
        prefix: Icon(Icons.search));
  }

  //State methods

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_gotData) {
      _prayerBloc = BlocProvider.of<GroupBloc>(context);
      _prayerBloc.add(FetchGroup());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeKeyboard(context: context, onClose: () {});
      },
      child: Scaffold(
        appBar: getAppThemedAppBar(context, titleText: "Groups", actions: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(AssetStrings.add, height: 20, width: 20),
            ),
            onTap: () async {
              RevenueKatServices.getOffering();
              // RevenueKatServices.getProducts();
              // RevenueKatServices.getPurchaserInfo();

              showAddGroupPopUp();
            },
          ),
        ]),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: getSearchField,
            ),
            Expanded(
              child:
                  BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
                return Builder(
                  builder: (context) {
                    Widget _child;
                    if (state is GroupFetchSuccessState) {
                      setData(state);
                      _child = getGroupLists;
                    } else if (state is FetchingGroupState ||
                        state is GroupIdleState) {
                      _child = CustomLoader();
                    } else if (state is GroupErrorState && !_gotData) {
                      _child = getNoDataView(
                          msg: state?.message,
                          onRetry: () {
                            _prayerBloc.add(FetchGroup());
                          });
                    } else {
                      _child = getGroupLists;
                    }

                    return _child;
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget getAddGroupItem() {
    double size = getScreenSize(context: context).width * 0.2;
    return InkWell(
      onTap: () async {
        var x =
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BlocProvider(
              create: (context) =>
                  GroupBloc(groupRepository: GroupRepository()),
              child: AddMembers());
        }));

        if (x == 1) {
          //todo
          fetchGroups();
        }
      },
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.brown, width: 2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.add,
          color: Colors.brown,
          size: 30,
        ),
      ),
    );
  }

  Widget groupItem({@required Group group}) {
    double size = getScreenSize(context: context).width * 0.15;
    return Card(
      child: InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                child: ClipOval(
                    child: getCachedNetworkImage(
                  url: group?.icon?.thumbnailUrl ?? "",
                  fit: BoxFit.cover,
                  height: size,
                  width: size,
                )),
              ),
              getSpacer(width: 8),
              Expanded(
                child: Text(group?.name),
              )
            ],
          ),
        ),
        onTap: () async {
          var x = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<GroupBloc>(
                    create: (context) =>
                        GroupBloc(groupRepository: GroupRepository())),
                BlocProvider<PrayerBloc>(
                    create: (context) =>
                        PrayerBloc(prayerRepository: PrayerRepository())),
              ],
              child: GroupDetailScreen(
                group: group,
              ),
            );
          }));

          if (x == 1) {
            //todo
            fetchGroups();
          }
        },
      ),
    );
  }

  onTextChange(str) async {
    /* try {
      groupList.clear();
      if(str.isEmpty){
        groupList.addAll( mainGroupList);
      }else{
        mainGroupList.forEach((element) {
          print("name");
          if (element.name.contains(str)){
          groupList.add(element);
          }
        });

      }

      setState(() {
        print("local func");

      });
    }  catch (e) {
      print("----> $e");
      // TODO
    }
*/
  }

  //
  void setData(GroupFetchSuccessState state) {
    print("setData");
    _gotData = true;
    groupList = state?.groups;

    freeList = state?.groups
        ?.where((element) => element?.kind?.toLowerCase() == "free")
        ?.toList();
    paidList = state?.groups
        ?.where((element) => element?.kind?.toLowerCase() == "paid")
        ?.toList();
  }

  fetchGroups() {
    _prayerBloc.add(FetchGroup());
  }

  showAddGroupPopUp() async {
    var value = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          builder: (context) {
            return BlocProvider(
                create: (BuildContext context) =>
                    GroupBloc(groupRepository: GroupRepository()),
                child: CreateNewGroupPopUp());
          },
          onClosing: () {},
        );
      },
      // isDismissible: false,
      enableDrag: false,
    );
    if (value == groupType.free) {
      getCreateGroupScreen(groupType.free);
    } else if (value == groupType.community) {
      getCreateGroupScreen(groupType.community);
    }
  }

  getCreateGroupScreen(groupType type) async {
    var x = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BlocProvider(
          create: (context) => GroupBloc(groupRepository: GroupRepository()),
          child: GroupPreview(
            type: type,
            selectedUser: [],
          ));
    }));
    if (x == 1) {
      //for create group
      fetchGroups();
    }
  }

  Widget getListHeader(text, {offstage: false}) {
    return SliverToBoxAdapter(
      child: Offstage(
        offstage: offstage,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          color: AppColors.lightBGColor,
          child: Text(
            text ?? "",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
