import 'dart:io';

import 'package:ecare/services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_2_allergies.dart';
import 'package:ecare/pages/question_2_medication.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

import '../widgets/image_picker.dart';

class UploadedDocument extends StatefulWidget {
  const UploadedDocument({Key? key}) : super(key: key);

  @override
  State<UploadedDocument> createState() => UploadedDocumentState();
}

class UploadedDocumentState extends State<UploadedDocument>
    with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  List<File> upload_images = [];
  List upload_images2 = [];
  List<File> upload_lab = [];
  List upload_lab2 = [];
  List<File> upload_radiology = [];
  List upload_radiology2 = [];
  List<File> upload_other = [];
  List upload_other2 = [];

  bool load=false;

  get_uploaded_doc() async{
    setState(() {
      load=true;
    });
    var res = await Webservices.get(ApiUrls.get_document_image+'?user_id='+await getCurrentUserId());
    print('list-----$res');
    setState(() {
      load=false;
    });
    if(res['status'].toString()=='1'){
      for(int i=0;i<res['data'].length;i++){
        if(res['data'][i]['image_type'].toString()=='1'){
          upload_images2.add(res['data'][i]);
        }
        if(res['data'][i]['image_type'].toString()=='2'){
          upload_radiology2.add(res['data'][i]);
        }
        if(res['data'][i]['image_type'].toString()=='3'){
          upload_lab2.add(res['data'][i]);
        }
        if(res['data'][i]['image_type'].toString()=='4'){
          upload_other2.add(res['data'][i]);
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_uploaded_doc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: load?CustomLoader():SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSizedBox2,
              MainHeadingText(
                text: 'My uploaded medical documents ',
                fontSize: 32,
                fontFamily: 'light',
              ),
              vSizedBox2,
              ParagraphText(
                  fontSize: 16,
                  text:
                      'Kindly upload documents here that you would like your healthcare practitioner to review'),
              vSizedBox4,
              GestureDetector(
                onTap: () async {
                  print('00000');
                  upload_images=[];
                  await EasyLoading.show(
                      status: null, maskType: EasyLoadingMaskType.black);
                  List<XFile>? images =
                      await Multiple_ImagePicker(context) as List<XFile>?;
                  print('mutiple image ${images![0].path}');
                  for (int i = 0; i < images.length; i++) {
                    upload_images.add(File(images![i].path));
                    setState(() {

                    });
                  }
                  EasyLoading.dismiss();
                  upload_image('image',upload_images);
                  print('upload image array----${upload_images.length}');
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  width: 160,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(100)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        color: MyColors.white,
                        size: 18,
                      ),
                      MainHeadingText(
                        text: 'Upload images',
                        fontSize: 14,
                        fontFamily: 'light',
                        color: MyColors.white,
                      )
                    ],
                  ),
                ),
              ),
              vSizedBox,
              GestureDetector(
                onTap: () async {
                  upload_lab=[];
                  await EasyLoading.show(
                      status: null, maskType: EasyLoadingMaskType.black);
                  List<XFile>? images =
                  await Multiple_ImagePicker(context) as List<XFile>?;
                  print('mutiple image ${images![0].path}');
                  for (int i = 0; i < images.length; i++) {
                    upload_lab.add(File(images![i].path));
                    setState(() {

                    });
                  }
                  EasyLoading.dismiss();
                  upload_image('lab_image',upload_lab);
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  width: 180,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(100)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        color: MyColors.white,
                        size: 18,
                      ),
                      MainHeadingText(
                        text: 'Upload Lab results',
                        fontSize: 14,
                        fontFamily: 'light',
                        color: MyColors.white,
                      )
                    ],
                  ),
                ),
              ),
              vSizedBox,
              GestureDetector(
                onTap: () async {
                  upload_radiology=[];
                  await EasyLoading.show(
                      status: null, maskType: EasyLoadingMaskType.black);
                  List<XFile>? images =
                  await Multiple_ImagePicker(context) as List<XFile>?;
                  print('mutiple image ${images![0].path}');
                  for (int i = 0; i < images.length; i++) {
                    upload_radiology.add(File(images![i].path));
                    setState(() {

                    });
                  }
                  EasyLoading.dismiss();
                  upload_image('radiology_image',upload_radiology);
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  width: 215,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(100)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        color: MyColors.white,
                        size: 18,
                      ),
                      MainHeadingText(
                        text: 'Upload radiology reports',
                        fontSize: 14,
                        fontFamily: 'light',
                        color: MyColors.white,
                      )
                    ],
                  ),
                ),
              ),
              vSizedBox,
              GestureDetector(
                onTap: () async {
                  upload_other=[];
                  await EasyLoading.show(
                      status: null, maskType: EasyLoadingMaskType.black);
                  List<XFile>? images =
                  await Multiple_ImagePicker(context) as List<XFile>?;
                  print('mutiple image ${images![0].path}');
                  for (int i = 0; i < images.length; i++) {
                    upload_other.add(File(images![i].path));
                    setState(() {

                    });
                  }
                  EasyLoading.dismiss();
                  upload_image('other_image',upload_other);
                },
                child: Container(
                  width: 100,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(100)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        color: MyColors.white,
                        size: 18,
                      ),
                      MainHeadingText(
                        text: 'Other',
                        fontSize: 14,
                        fontFamily: 'light',
                        color: MyColors.white,
                      )
                    ],
                  ),
                ),
              ),
              vSizedBox2,
              Container(
                // width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainHeadingText(text: 'Upload Images:',fontFamily: 'light',),
                    if(upload_images.length==0&&upload_images2.length==0)
                    Center(child: Text('No Image Uploaded Yet.'),),
                    if(upload_images.length>0)
                    vSizedBox2,
                    if(upload_images.length>0)
                    File_gridViewImage(upload_images),
                    vSizedBox,
                    network_gridViewImage(upload_images2),
                  ],
                ),
              ),
              vSizedBox2,
              Container(
                // width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainHeadingText(text: 'Upload Lab Results:',fontFamily: 'light',),
                    if(upload_lab.length==0&&upload_lab2.length==0)
                      Center(child: Text('No Image Uploaded Yet.'),),
                    if(upload_lab.length>0)
                    vSizedBox2,
                    if(upload_lab.length>0)
                      File_gridViewImage(upload_lab),
                    vSizedBox,
                    network_gridViewImage(upload_lab2),
                  ],
                ),
              ),
              vSizedBox2,
              Container(
                // width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainHeadingText(text: 'Upload Radiology Reports:',fontFamily: 'light',),
                    if(upload_radiology.length==0&&upload_radiology.length==0)
                      Center(child: Text('No Image Uploaded Yet.'),),
                    if(upload_radiology.length>0)
                      vSizedBox2,
                    if(upload_radiology.length>0)
                      File_gridViewImage(upload_radiology),
                    vSizedBox,
                    network_gridViewImage(upload_radiology2),
                  ],
                ),
              ),
              vSizedBox2,
              Container(
                // width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainHeadingText(text: 'Others:',fontFamily: 'light',),
                    if(upload_other.length==0&&upload_other2.length==0)
                      Center(child: Text('No Image Uploaded Yet.'),),
                    if(upload_other.length>0)
                      vSizedBox2,
                    if(upload_other.length>0)
                      File_gridViewImage(upload_other),
                    vSizedBox,
                    network_gridViewImage(upload_other2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget File_gridViewImage(List Images) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      children: List.generate(Images.length, (index) {
        // Asset asset = images[index];
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: MyColors.primaryColor,width: 1.5)
          ),
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap:() async{

                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: Image.file(
                    Images[index],
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 2,
                right: 3,
                child: GestureDetector(
                  onTap: () {
                    print('delete image from List');
                    Images.removeAt(index);
                    setState(() {
                      print('set new state of images');
                    });
                  },
                  child: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget network_gridViewImage(List Images) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      children: List.generate(Images.length, (index) {
        // Asset asset = images[index];
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: MyColors.primaryColor,width: 1.5)
          ),
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap:() async{

                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: Image.network(
                    Images[index]['image'],
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 2,
                right: 3,
                child: GestureDetector(
                  onTap: () async{
                    print('delete image from List');
                    var res = await Webservices.get(ApiUrls.deletedocimage+'?id='+Images[index]['id'].toString());
                    Images.removeAt(index);
                    print('image remove----$res');
                    setState(() {
                      print('set new state of images');
                    });
                  },
                  child: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  upload_image(String image_type,List images) async{
    Map<String , dynamic> files={};
    Map<String,dynamic> data ={
      'user_id':await getCurrentUserId(),
    };
    for(int i=0;i<images.length;i++){
      files[image_type+'[${i}]']=images[i];
    }
    print('imagepass----$files');
    await EasyLoading.show(
      status:null,
      maskType: EasyLoadingMaskType.black
    );
    var res = await Webservices.postDataWithImageFunction(body: data, files: files, context: context, apiUrl: ApiUrls.documentimage);
    EasyLoading.dismiss();
    print('image upload-----$res');
    if(res['status'].toString()=='1'){
      showSnackbar( 'Document Uploaded Successfully.');
    }
  }

  showAlertDialog(BuildContext context,String id) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () async{
        await EasyLoading.show(
            status: null,
            maskType: EasyLoadingMaskType.black
        );
        var res = await Webservices.get(ApiUrls.deletedocimage+'?id='+id);
        EasyLoading.dismiss();
        if(res['status'].toString()=='1'){
          Navigator.pop(context);
          // get_lists();
        }
      },
    );

    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Remove Document"),
      content: Text("Are you sure?"),
      actions: [
        okButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}


