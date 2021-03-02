import 'dart:io';
import 'dart:math';

import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatefulWidget {
  final double height;
  final double width;
  final Function(File image)onSelect;
  final bool hideEditButton;
  final String defalutImage;

  ImageSelector({this.height:60,this.width:60,this.onSelect, this.hideEditButton:true ,this.defalutImage});
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}
class _ImageSelectorState extends State<ImageSelector> {
  double _height;
  double _width;
  double _iconWidth;
   File _image;
   bool _hideEditButton;
   
   Widget get getDefalutImage{
     return (widget?.defalutImage==null)?Icon(Icons.camera_enhance):ClipOval(child:getCachedNetworkImage(url:widget?.defalutImage,fit: BoxFit.cover));
   }
  @override
  void initState() {
    // TODO: implement initState
    _height= widget.height;
    _width=widget.width;
    _iconWidth=max(_height*0.4,40);
    _hideEditButton=widget.hideEditButton;



  }
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
    onTap: (){
      showDialog(context: context,builder: (dialogContext){
       return Dialog(child: _buildProfileImageSelector(dialogContext));
      });
    },
      child: Container(
        width: _hideEditButton ?_width:_width+_iconWidth/6,
        height: _hideEditButton?_width:_height+_iconWidth/6,
        child: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Container(
              child: Container(
                alignment: Alignment(0,0),
                height: _height,width:_width,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  color: AppColors.ultraLightBGColor
                ),
                child: _image==null? getDefalutImage:ClipOval(
                  child: Image.file(_image,fit: BoxFit.cover,height:_height,width: _width,),
                ),
              ),
            ),
            Positioned(
              right: 0,
            bottom: 0,
              child: Offstage(
                offstage: _hideEditButton,
                child: Container(
                  alignment: Alignment.center,
                  height: _iconWidth,
                  width: _iconWidth,

                  decoration: BoxDecoration(color: AppColors.ultraLightBGColor,shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey,width: 1)
                  ),
                  child: Icon(Icons.edit,color: Colors.black,),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  _buildProfileImageSelector(dialogContext) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Divider(
          height: 10,
          thickness: 2,
          color: AppColors.primaryColor,
        ),
        ListTile(
          leading: Icon(Icons.camera, color: AppColors.primaryColor),
          title: Text("Take Photo"),
          onTap: () {
            Navigator.of(dialogContext).pop();
            _openCameraOrGallery(isCam: true);
          },
        ),
        ListTile(
          leading: Icon(Icons.image, color: AppColors.primaryColor),
          title: Text("Choose Photo"),
          onTap: () {
            Navigator.of(dialogContext).pop();
            _openCameraOrGallery(isCam: false);
          },
        ),
      ],
    );
  }



//image selection and upload methods
  _openCameraOrGallery({@required isCam}) async {
    print("was here");
    try {
      var image = await ImagePicker.pickImage(
        source: isCam ? ImageSource.camera : ImageSource.gallery,
//        maxHeight: 500,
//        maxWidth: 500
      );
      if (image != null) {
        _image = image;
        setState(() {});
        widget.onSelect(image);
      }
    } catch (e) {
      print("Exception:: $e");
    }
  }
}
