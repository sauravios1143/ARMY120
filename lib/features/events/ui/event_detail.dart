import 'package:army120/features/events/data/model/event.dart' as appEvent;
import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:device_calendar/device_calendar.dart';

class EventDetail extends StatefulWidget {
  final appEvent.Event event;

  EventDetail({this.event});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {

  //props

  DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  List<Calendar> _calendars;
  Calendar _selectedCalendar;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool hideReminder =false;
  //getters


  Widget get getHeader {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: getScreenSize(context: context).height * 0.25,
//          color: Colors.yellow,
          child: Hero(
            tag: "${widget?.event?.id}",
            child: Image.asset(
              AssetStrings.church,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
            right: 20,
            top: 20,
            child: FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              mini: true,
              child: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ))
      ],
    );
  }

  Widget get getTitle {
    return Text(
      widget?.event?.name ?? "",
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget get getDescriptioin {
    return Text(
      widget?.event?.description ?? "",
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget get getDate {
    return Text(
      getFormattedDateString(
          dateTime: DateTime.tryParse(widget?.event?.startDateTime ?? "")),
      style: TextStyle(
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget get getAddReminderButton {
    return Offstage(
        offstage: hideReminder,
      child: Container(
        padding: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getAppThemedFilledButton(title: "Add remider", onpress: openBottomSheet),
          ],
        ),
      ),
    );
  }

  Widget get getDetail {
    double height = getScreenSize(context: context).height;
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: 50,
      ),
      child: Column(children: [
        getHeader,
        getSpacer(height: height * 0.03),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              getTitle,
              getSpacer(height: height * 0.03),
              getDescriptioin,
              getSpacer(height: height * 0.04),
              getDate,
            ],
          ),
        ),
      ]),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _retrieveCalendars();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: getDetail,
        bottomNavigationBar: getAddReminderButton,
      ),
    );
  }

  openBottomSheet() {

    _scaffoldKey.currentState.showBottomSheet((context) => buildBottomSheet());
  }

  void _retrieveCalendars() async {
    //Retrieve user's calendars from mobile device
    //Request permissions first if they haven't been granted
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      setState(() {
        _calendars = calendarsResult?.data;
      });
    } catch (e) {
      print(e);
    }
  }

  getBottomSheet(List<Calendar> calenderListItems) {
  
    
  }

  Widget buildBottomSheet() {
    return BottomSheet(
      elevation: 4,
      onClosing: () {
      },
      builder: (context) {
        
            List<Calendar> calenderListItems = [];
        for (int i = 0; i < _calendars?.length; i++) {
          print("Cagelen ${_calendars[i]?.name} ${_calendars[i].isDefault}");
          if (_calendars[i].isReadOnly) {
            continue;
          }
          calenderListItems.add(_calendars[i]);
        }
        
        return Container(
            // alignment: Align,
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: double.maxFinite,
                color: AppColors.primaryColor,
                alignment: Alignment.center,
                child: Text(
                  "Please select Calender ",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
            ...List.generate(calenderListItems.length,
                (index) => getCalenderItem(calenderListItems[index])),
          ],
        ));
      },
    );
  }

  getCalenderItem(Calendar item) {
    return Material(
        elevation: 4.0,
        child: InkWell(
          onTap: (){
              _setRemider(item);

          },
          child: Container(
              color: Colors.transparent,
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Text(item?.accountName ?? "")),
        ));
  }

  _setRemider(Calendar calender) async {
    Event eventToCreate = Event(calender.id);
    eventToCreate.start =/*DateTime(2020,12,13);*/ DateTime.tryParse(widget.event?.startDateTime);
    eventToCreate.title = widget?.event?.name;
    eventToCreate.end = /*DateTime(2020,12,14);*/DateTime.tryParse(widget.event?.endDateTime);
    eventToCreate.eventId = "${widget?.event?.id}";
    eventToCreate.description = widget?.event?.description ?? "";
    var result = await _deviceCalendarPlugin
        .createOrUpdateEvent(eventToCreate);

    Navigator.pop(context);//pop bottom sheet bar
    if (result?.isSuccess == true) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Event added Successfully"),
          duration: new Duration(milliseconds: 1200)));
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Failed to add event"),
          duration: new Duration(milliseconds: 3000)));
    }
  }
}
