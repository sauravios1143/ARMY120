import 'package:army120/features/events/bloc/event_bloc.dart';
import 'package:army120/features/events/bloc/event_event.dart';
import 'package:army120/features/events/bloc/event_state.dart';
import 'package:army120/features/events/data/model/event.dart';
import 'package:army120/features/events/ui/event_detail.dart';
import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/Constants/event_type.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhysicalTab extends StatefulWidget {
  @override
  _PhysicalTabState createState() => _PhysicalTabState();
}

class _PhysicalTabState extends State<PhysicalTab> {
  //Props
  bool _gotData = false;
  EventBloc eventBloc;
  List<Event> eventList = [];

  get getGridView {
    double width = getScreenSize(context: context).width;
    return (eventList?.isEmpty)
        ? getNoDataView(
            msg: "No Physical Event found",
            onRetry: () {
              fetchEvent();
            })
        : GridView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: width * 0.1),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: width * 0.1,
                crossAxisSpacing: width * 0.1),
            itemCount: eventList?.length ?? 0,
            itemBuilder: (context, i) {
              return getEventItem(event: eventList[i]);
            });
  }

  //State methods

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_gotData) {
      eventBloc = BlocProvider.of<EventBloc>(context);
      fetchEvent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        getPage,
        BlocBuilder<EventBloc, EventState>(
          builder: (context,state){
            return Offstage(
              offstage: !(state is EventUpdatingState),
              child: CustomLoader(isTransparent: false),
            );
          },
        ),
        BlocListener<EventBloc, EventState>(
            child: Container(
              height: 0,
              width: 0,
            ),
            listener: (context, state) async {

              if (state is EventErrorState) {
                showAlert(
                    context: context,
                    titleText: "Error",
                    message: state?.message ?? "",
                    actionCallbacks: {"Ok": () {}});
              }
              if (state is BookMarkSuccess) {
                showAlert(
                    context: context,
                    titleText: "Success",
                    message: "Event bookmarked succesfully",
                    actionCallbacks: {
                      "Ok": () {
                        fetchEvent();

                      }
                    });
              }
            })
      ],
    );
  }

  Widget get getPage{
    return BlocBuilder<EventBloc, EventState>(builder: (context, state) {
      return Builder(
        builder: (context) {
          Widget _child;
          if (state is EventFetchSuccessState) {
            setData(state: state);
            _child = getGridView;
          } else if (state is FetchingEventState ||
              state is EventIdleState) {
            _child = CustomLoader();
          } else if (state is EventErrorState && !_gotData) {
            _child = getNoDataView(
                msg: state?.message,
                onRetry: () {
                  fetchEvent();
                });
          } else {
            _child = getGridView;
          }

          return _child;
        },
      );
    });
  }

  Widget getEventItem({Event event}) {
    return GridTile(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EventDetail(event: event);
          }));
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: "${event?.id}",
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        AssetStrings.church,
                        fit: BoxFit.fill,
                      )),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(child: Text(event?.name??"",maxLines: 1,overflow: TextOverflow.ellipsis,)),
//                  getAppThemedChipButon(onTap: () {}, title: "Attend"),
//                  SizedBox(width: 8,),
                  InkWell(
                      onTap: () {
                        bookMark(event: event);
                      },
                      child: Image.asset(
                        (event?.isBookmarked ?? false)
                            ? AssetStrings.bookMartActive
                            : AssetStrings.bookMark,
                        height: 20,
                        width: 20,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //set data to Ui
  setData({EventFetchSuccessState state}) {
    _gotData = true;
    eventList = state?.events //todo
        ?.where((element) => element?.kind?.toLowerCase() == EventType.physical)
        ?.toList();

  }

  //fetch events
  fetchEvent() {
    eventBloc.add(FetchEvent());
  }

  //book mark event
  bookMark({Event event}) {
    eventBloc.add(BookmarkEvent(event: event));
  }
}
