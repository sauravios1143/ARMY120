import 'package:army120/features/auth/data/model/user.dart';
import 'package:army120/features/donate/bloc/donation_bloc.dart';
import 'package:army120/features/donate/data/donation_repository.dart';
import 'package:army120/features/donate/ui/donate.dart';
import 'package:army120/features/home/bloc/home_bloc.dart';
import 'package:army120/features/home/bloc/home_event.dart';
import 'package:army120/features/home/bloc/home_state.dart';
import 'package:army120/features/notifications/bloc/notification_bloc.dart';
import 'package:army120/features/notifications/data/notification_repository.dart';
import 'package:army120/features/notifications/ui/notificationListing.dart';
import 'package:army120/features/profile/bloc/profile_bloc.dart';
import 'package:army120/features/profile/data/profile_repository.dart';
import 'package:army120/features/profile/ui/profile_widget.dart';
import 'package:army120/utils/Constants/profileConstant.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:army120/utils/reusableWidgets/paginationLoader.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  //props

  double _horizontalPadding = 24.0;
  bool gotPatrons = false;
  CardController controller = CardController();
  HomeBloc _homeBloc;
  List<User> pathronList = [];
  int currentPage = 1;
  int perPageCount = 1;
  ScrollController _patronScrollController = ScrollController();
  ValueNotifier<bool> isLoading = new ValueNotifier<bool>(false);

  //getters

  Widget get getCustomDivider {
    return Divider(
      thickness: 8,
      height: 60,
    );
  }

  Widget get getPatronsSection {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return Builder(
        builder: (context) {
          Widget _child;
          if (state is FetchingPatronSuccessState) {
            setPatronList(state);

            _child = getPatron;
          } else if (state is FetchingPatronState || state is HomeIdleState) {
            _child = CustomLoader();
          } else if (state is HomeErrorState && !gotPatrons) {
            _child = getNoDataView(
                msg: state?.message,
                onRetry: () {
                  fetchPatrons();
                });
          } else {
            _child = getPatron;
          }

          return _child;
        },
      );
    });
  }

  Widget get getPatron {
    Size size = getScreenSize(context: context);
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Patrons",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              getAppThemedFilledButton(
                  title: "Become a Patron",
                  onpress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return BlocProvider(
                            create: (BuildContext context) => DonationBloc(
                                donationRepository: DonationRepository()),
                            child: Donation(),
                          );
                          ;
                        }));
                  }),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            height: size.height * 0.1,
            child: ListView.separated(
              controller: _patronScrollController,
              padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
              itemCount: pathronList?.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return i == pathronList.length
                    ? PaginationLoader(
                  loaderNotifier: isLoading,
                )
                    : getPatronItem(patron: pathronList[i]);
              },
              separatorBuilder: (context, i) {
                return SizedBox(
                  width: 10,
                );
              },
            )),
      ],
    );
  }

  Widget get getCarousel {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
//          aspectRatio: 1.0,
        enlargeCenterPage: false,
        viewportFraction: 1.0,
      ),
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return getCarouselItem();
          },
        );
      }).toList(),
    );
  }

  Widget get getTinderCard {
    return Container(
      height: getScreenSize(context: context).height * 0.2,
      child: TinderSwapCard(
        swipeUp: true,
        swipeDown: true,
        orientation: AmassOrientation.BOTTOM,
        totalNum: 4,
        stackNum: 3,
        swipeEdge: 4.0,
        maxWidth: MediaQuery.of(context).size.width * 0.9,
        maxHeight: MediaQuery.of(context).size.width * 0.9,
        minWidth: MediaQuery.of(context).size.width * 0.8,
        minHeight: MediaQuery.of(context).size.width * 0.8,
        cardBuilder: (context, index) => Card(child: getCarouselItem()),
        cardController: controller,
        swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
          /// Get swiping card's alignment
          if (align.x < 0) {
            //Card is LEFT swiping
          } else if (align.x > 0) {
            //Card is RIGHT swiping
          }
        },
        swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
          print("index ${index}");
        },
      ),
    );
  }

  Widget get gerProfileCard {
    return BlocProvider(
        create: (context) => ProfileBloc(repository: ProfileRepository()),
        child: ProfileWidget());
  }

  Widget get getNotifications {
    double height = getScreenSize(context: context).height;
    return Padding(
        padding: const EdgeInsets.only(left: 34.0, right: 16),
        child: BlocProvider(
            create: (BuildContext context) => NotificationBloc(
                notificationRepository: NotificationRepository()),
            child: NotificationListingView()));
  }

//State Methods

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _patronScrollController.addListener(_paginationLogic);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!gotPatrons) {
      _homeBloc = BlocProvider.of<HomeBloc>(context);
      fetchPatrons();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build");

    return Scaffold(
      appBar: getAppThemedAppBar(
        context,
        titleText: "Home",
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 24,
        ),
        child: Column(
          children: <Widget>[
            Offstage(
                offstage:false,//todo remove this shit
                /*    (
                    LoggedInUser
                        ?.getUserDetail?.profileCompletion?.completion ==
                    100),*/

                //_currentStatus!=ProfileStatus.Completed,
                child: gerProfileCard),
            Offstage(
                offstage: (LoggedInUser
                    ?.getUserDetail?.profileCompletion?.completion !=
                    100),
                //_currentStatus!=ProfileStatus.Completed,
                child: getPatronsSection),
//            CustomDivider,
//            getCarousel,
            getCustomDivider, //todo
            getTinderCard,
            getCustomDivider,

            Container(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
                alignment: Alignment(-1, 0),
                child: Text(
                  "Notifications",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )),
            getNotifications,
          ],
        ),
      ),
    );
  }

  // Widgets
  //get patron item
  Widget getPatronItem({User patron}) {
    Size size = getScreenSize(context: context);
    double imageSize = size.height * 0.08;
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle),
      alignment: Alignment.center,
      child: ClipOval(
          child: getCachedNetworkImage(
            url: patron?.profilePicture?.thumbnailUrl ?? "",
            width: imageSize,
            height: imageSize,
            fit: BoxFit.cover,
          ) //
      ),
    );
  }

  //get carousel item
  Widget getCarouselItem() {
    return Padding(
//      padding: EdgeInsets.symmetric(horizontal: 25),//todo
      padding: EdgeInsets.symmetric(horizontal: 0), //todo
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: AppColors.primaryColor,
        elevation: 0.0,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Share Aaron's \nprayers to Twitter",
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                getSpacer(height: 8),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.swap_calls,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  //fetch patrons
  fetchPatrons() {
    _homeBloc.add(FetchPatrons(
      currentPage: currentPage,
    ));
    // _homeBloc.add(FetchNotifications());
  }

  //set patrons data
  setPatronList(FetchingPatronSuccessState state) {
    gotPatrons = true;

    if (currentPage == 1) {
      pathronList = state?.patronList ?? [];
      perPageCount = state?.patronList?.length ?? 0;
    } else {
      pathronList.addAll(state?.patronList);
    }
    isLoading.value = false;
  }

  //pagination logic
  _paginationLogic() async {
    if (_patronScrollController.position.maxScrollExtent ==
        _patronScrollController.offset) {
      print("totalRecode ${pathronList?.length} " +
          "current page ${currentPage}  perpageCount ${perPageCount}");

      print("Paginatig");
      if ((pathronList?.length ?? 0) >= (perPageCount * currentPage ?? 0)) {
        if (!isLoading.value) //is not loading
            {
          isLoading.value = true;
          currentPage++;
          fetchPatrons();
        }
      }
    }
  }
}
