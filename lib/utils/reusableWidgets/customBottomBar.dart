import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomBottomBar extends StatefulWidget {
  final TabController controller;
  final List<NavigationBarItem> items;

  CustomBottomBar({@required this.controller, @required this.items});

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  final activeColor = AppColors.primaryColor;
  final disableColor = Colors.black;
  final activeStyle = TextStyle(color: AppColors.primaryColor, fontSize: 9,fontWeight: FontWeight.w600);
  final defaultStyle = TextStyle(color: Colors.black, fontSize: 9,fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return Container(
       color: AppColors.ultraLightBGColor,//AppColors.lightRed.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.items.length, (i) {
          return buildItem(
              index: i,
              item: widget.items[i],
              isActive: (i == widget.controller.index));
        }),
      ),
    );
  }

  Widget buildItem({NavigationBarItem item, isActive, int index}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          widget.controller
              .animateTo(index, duration: Duration(milliseconds: 100));
          setState(() {});
        },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
//            Icon(
//              item.icon,size: 30,
//              color: isActive ? activeColor : disableColor,
//            ),
                Image.asset(
                  isActive?item.activeImage:item.image,
                  width: 24,
                  height:24,
                  color: isActive ? activeColor : disableColor,
                ),
                SizedBox(height: 5.0,),
                Text(
                  item.title ?? "",
                  style: isActive ? activeStyle : defaultStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            )),
      ),
    );
  }
}

class NavigationBarItem {
  final IconData icon;
  final String title;
  final String activeImage;
  final String image;

  NavigationBarItem({this.icon, this.title, this.activeImage,this.image});
}
