import 'package:army120/features/group/bloc/group_bloc.dart';
import 'package:army120/features/group/data/group_repository.dart';
import 'package:army120/features/group/ui/group_grid_view.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class SelectGroupView extends StatefulWidget {
  @override
  _SelectGroupViewState createState() => _SelectGroupViewState();
}

class _SelectGroupViewState extends State<SelectGroupView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppThemedAppBar(context,titleText: "Select group"),
      body: BlocProvider(
        create: (BuildContext context )=>GroupBloc(groupRepository: GroupRepository()),
        child: GroupGridView(
          isSelectType: true,

        ),
      ),
    );
  }
}
