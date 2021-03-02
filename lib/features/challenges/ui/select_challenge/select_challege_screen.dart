import 'package:army120/features/challenges/bloc/challenge_bloc.dart';
import 'package:army120/features/challenges/bloc/challenge_state.dart';
import 'package:army120/features/challenges/bloc/chanllenge_events.dart';
import 'package:army120/features/challenges/data/challenge_repository.dart';
import 'package:army120/features/challenges/data/model/category.dart';
import 'package:army120/features/challenges/data/model/custom_challenge_request.dart';
import 'package:army120/features/challenges/data/model/start_challenge_request.dart';
import 'package:army120/features/challenges/ui/select_challenge/accept_challenge.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/ValidatorFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectChallenge extends StatefulWidget {
  final String currentCateogry;

  SelectChallenge({this.currentCateogry});

  @override
  _SelectChallengeState createState() => _SelectChallengeState();
}

class _SelectChallengeState extends State<SelectChallenge> {

  String selectedChallege;
  bool _gotData = false;
  ChallengeBloc _challengeBloc;
  List<Categories> categoriesList = [];
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  GlobalKey<FormState> _prayerFormKey = new GlobalKey();
  TextEditingController _prayerController = TextEditingController();

  //getters
  get getTopBar {
    return Container(
      height: getScreenSize(context: context).height * 0.13,
      child: Stack(
        alignment: Alignment(0, 0),
        children: <Widget>[
          Positioned(
            top: 30,
            left: 20,
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.primaryColor,
                  size: 30,
                )),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: IconButton(
              onPressed: () {
                if(isLoggedIn()){
                  getCustomChallengePopup();
                }else{
                  showLoginBottomSheet(context);
                }
              },
              icon: Icon(
                Icons.edit,
                color: AppColors.primaryColor,
                size: 30,
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              child: Text(
                "Explore Challenges",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              )),
        ],
      ),
    );
  }

  get getChallengesList {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, i) {
        return getChallegeItem(index: i, category: categoriesList[i]);
      },
      itemCount: categoriesList?.length,
    );
  }

  getChallegeItem({index, Categories category}) {
    return InkWell(
      onTap: () async {
        setState(() {
          selectedChallege= category?.identifier;
        });
        if(isLoggedIn()){
          onCategoryTap(category);
        }else{
          showLoginBottomSheet(context);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: (category?.identifier == selectedChallege)
                ? Colors.transparent
                : AppColors.ultraLightBGColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                width: 2,
                color:(category?.identifier == selectedChallege)
                    ? AppColors.primaryColor
                    : AppColors.ultraLightBGColor)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Text(
                    capitalize(value: category?.identifier ?? ""),maxLines: 1,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),overflow: TextOverflow.ellipsis,
                  ),
                ),
                Hero(
                  tag: "${category?.id}",
                  child: Image.asset(
                    getCategoryAsset(identifier: category?.identifier),
                    height: 70,
                    width: 70,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Expanded(
              child: Text(
                category?.description ?? "",
              ),
            ),
          ],
        ),
      ),
    );
  }

  //State methods

  @override
  void initState() {
    selectedChallege= widget?.currentCateogry;
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_gotData) {
      _challengeBloc = BlocProvider.of<ChallengeBloc>(context);
      fetchChallenges();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppThemedAppBar(context,titleText: "Explore Challenges" ,actions: [
        IconButton(
          onPressed: () {
            if(isLoggedIn()){
              getCustomChallengePopup();
            }else{
              showLoginBottomSheet(context);
            }
          },
          icon: Icon(
            Icons.edit,
            color: AppColors.primaryColor,
            size: 30,
          ),
        ),
      ]),
        key: scaffoldKey,
        body: Stack(
          children: [
            getpage,
            BlocBuilder<ChallengeBloc, ChallengeState>(
              builder: (context, state) {
                return Offstage(
                  offstage: !(state is ChallengeUpdatingState),
                  child: CustomLoader(isTransparent: false),
                );
              },
            ),
            BlocListener<ChallengeBloc, ChallengeState>(
                child: Container(
                  height: 0,
                  width: 0,
                ),
                listener: (context, state) async {
                  if (state is ChallengeErrorState) {
                    showAlert(
                        context: context,
                        titleText: "Error",
                        message: state?.message ?? "",
                        actionCallbacks: {"Ok": () {}});
                  }

                  if (state is StartChallengeSuccessState) {
                    showAlert(
                        context: context,
                        titleText: "Success",
                        message: "Challenge started Successfully",
                        actionCallbacks: {
                          "Ok": () {
                            Navigator.pop(context, 1);
                          }
                        });
                  }
                })
          ],
        ));
  }

  Widget get getpage {
    return Column(
      children: <Widget>[
        // getTopBar,
        Divider(
          height: 8,
          color: Colors.grey[300],
          thickness: 10,
        ),
        Expanded(
          child: BlocBuilder<ChallengeBloc, ChallengeState>(
              builder: (context, state) {
            return Builder(
              builder: (context) {
                Widget _child;
                if (state is FetchChallengeSuccessState) {
                  setData(state);

                  _child = getChallengesList;
                } else if (state is FetchingChallengeState ||
                    state is ChallengeIdleState) {
                  _child = CustomLoader();
                } else if (state is ChallengeErrorState && !_gotData) {
                  _child = getNoDataView(
                      msg: state?.message,
                      onRetry: () {
                        fetchChallenges();
                      });
                } else {
                  _child = getChallengesList;
                }

                return _child;
              },
            );
          }),
        )
      ],
    );
  }

  //other methods

  getBottomSheet(Categories category) {
    scaffoldKey?.currentState?.showBottomSheet(
        (context) => getGeneralChallengeView(category),
        elevation: 0.4);
  }

  getGeneralChallengeView(Categories category) {
    double height = getScreenSize(context: context).height;
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 40,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          getSpacer(height: height * 0.01),
          Text(
            "Quit the ${widget?.currentCateogry} challenge?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          getSpacer(height: height * 0.03),
          Text(
            "Are you sure you want to lose the progress made in ${widget?.currentCateogry} challenge and start general challenge",
            style: TextStyle(),
            textAlign: TextAlign.center,
          ),
          getSpacer(height: height * 0.03),
          getButton(
            text: "Quit and start challenge",
            onTap: () {
              Navigator.pop(context);
              selectChallenge(category);
            },
            color: AppColors.primaryColor,
          ),
          getSpacer(height: height * 0.03),
          getButton(
            text: "Stay on current challenge",
            onTap: () {
              Navigator.pop(context);
            },
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  //create custom Challenge
  getCustomChallengePopup() {
    print("edit");
    showDialog(
        context: context,
        builder: (dialogContext) {
          return geAddPrayerTile(dialogContext);
        });
  }

  Widget geAddPrayerTile(BuildContext dialogcontext) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: AppColors.popUpBGColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _prayerFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Write your own prayer",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              getSpacer(height: 8),
              chatTextField(
                  context: context,
                  hint: "Write your prayer",
                  controller: _prayerController,
                  focusNode: null,
                  validator: (text) {
                    return prayerValidator(prayer: text);
                  }),
              getSpacer(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(dialogcontext);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                  FlatButton(
                      onPressed: () {
                        if (_prayerFormKey.currentState.validate()) {
                          Navigator.pop(dialogcontext);
                          //todo add method
                          createCustomChallenge();
                        }
                      },
                      child: Text(
                        "Post",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //fetch challenges category
  fetchChallenges() {
    _challengeBloc.add(FetchChallengesEvent());
  }

  //set category data
  setData(FetchChallengeSuccessState state) {
    _gotData = true;
    categoriesList = state?.categoryList;
  }

  selectChallenge(Categories category) async {
    var val =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BlocProvider(
          create: (context) => ChallengeBloc(repository: ChallengeRepository()),
          child: AcceptChallenge(
            category: category,
          ));
    }));

    if (val == 1) {
      Navigator.pop(context, 1);
    }
  }

  createCustomChallenge() {
    _challengeBloc.add(StartChallenge(
        request: StartChallengeRequest(
            category: "custom", text: _prayerController?.text)));
  }

  void onCategoryTap(Categories category) {

    if (widget?.currentCateogry == category.identifier) {
      showAlert(
          context: context,
          titleText: "Warning",
          message: "You are already on ${category?.identifier} challenge",
          actionCallbacks: {"Cancel": () {}});
    } else if (category?.identifier == "general" &&
        widget?.currentCateogry != null) {
      getBottomSheet(category);
    } else {
      selectChallenge(category);
    }
  }
}
