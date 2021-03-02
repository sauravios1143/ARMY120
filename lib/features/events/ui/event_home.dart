import 'package:army120/features/events/bloc/event_bloc.dart';
import 'package:army120/features/events/data/event_repository.dart';
import 'package:army120/features/events/ui/physical_tab.dart';
import 'package:army120/features/events/ui/virtual_tab.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventHome extends StatefulWidget {
  @override
  _EventHomeState createState() => _EventHomeState();
}

class _EventHomeState extends State<EventHome>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppThemedAppBar(
        context,
        titleText: "Events",
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primaryColor,
            indicatorWeight: 4,
            tabs: <Widget>[
              getTabBarItem(title: "Virtual"),
              getTabBarItem(title: "Physical")
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                BlocProvider(
                    create: (BuildContext context) =>
                        EventBloc(eventRepository: EventRepository()),
                    child: VirtualTab()),
                BlocProvider(
                    create: (BuildContext context) =>
                        EventBloc(eventRepository: EventRepository()),
                    child: PhysicalTab()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getTabBarItem({title}) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          title,
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        ));
  }
}
