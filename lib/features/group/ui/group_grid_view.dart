import 'package:army120/features/group/bloc/group_bloc.dart';
import 'package:army120/features/group/bloc/group_event.dart';
import 'package:army120/features/group/bloc/group_state.dart';
import 'package:army120/features/group/data/group_repository.dart';
import 'package:army120/features/group/data/model/group.dart';
import 'package:army120/features/group/ui/group_detail.dart';
import 'package:army120/features/group/ui/add_member.dart';
import 'package:army120/features/group/ui/group_preview.dart';
import 'package:army120/features/group/ui/new_group_deail.dart';
import 'package:army120/features/prayers/bloc/prayer_bloc.dart';
import 'package:army120/features/prayers/data/prayer_repository.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupGridView extends StatefulWidget {
  final bool isSelectType;

  GroupGridView({this.isSelectType: false});

  @override
  _GroupGridViewState createState() => _GroupGridViewState();
}

class _GroupGridViewState extends State<GroupGridView> {
  //Props
  bool _gotData = false;

  List<Group> groupList = [];
  GroupBloc _prayerBloc;

  //getters

  Widget get getHeader {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Align(
                alignment: Alignment(-1, 0),
                child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.primaryColor,
                    ))),
          ),
          getSpacer(height: 10),
          Text(
            "Groups",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget get getGroups {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: (groupList?.length ?? 0) + 1,
      itemBuilder: (context, i) {
        return (i == groupList.length ?? 0)
            ? getAddGroupItem()
            : groupItem(group: groupList[i]);
      },
    );
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Column(
        children: <Widget>[
          Expanded(
            child:
                BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
              return Builder(
                builder: (context) {
                  Widget _child;
                  if (state is GroupFetchSuccessState) {
                    setData(state);

                    _child = getGroups;
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
                    _child = getGroups;
                  }

                  return _child;
                },
              );
            }),
          )
        ],
      ),
    );
  }

  Widget getAddGroupItem() {
    double size = getScreenSize(context: context).width * 0.2;
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BlocProvider(
              create: (context) =>
                  GroupBloc(groupRepository: GroupRepository()),
              child: GroupPreview(
                selectedUser: [],
              ));
        }));
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
    double size = getScreenSize(context: context).width * 0.2;
    return InkWell(
      onTap: () {
        onGroupSelect(group);
      },
      child: ClipOval(
          child: Container(
        decoration: BoxDecoration(
          color: Colors.brown,
        ),
        height: size,
        width: size,
        child: getCachedNetworkImage(
            url: group?.icon?.thumbnailUrl ?? "", fit: BoxFit.cover),
      )),
    );
  }

  setData(GroupFetchSuccessState state) {
    _gotData = true;
    groupList = state?.groups;
  }

  //on group select
  onGroupSelect(Group group) {
    if (widget?.isSelectType ?? false) {
      Navigator.pop(context, group);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
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
    }
  }
}
