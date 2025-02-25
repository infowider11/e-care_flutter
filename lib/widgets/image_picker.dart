// ignore_for_file: avoid_print, unused_local_variable, non_constant_identifier_names

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
 
import 'package:image_picker/image_picker.dart';
import 'dart:io';







Future<File?> pickImage(bool isGallery) async {
  final ImagePicker picker = ImagePicker();

  File? image;
  String? _imageFile;
  try {
    print('about to pick image');
    XFile? pickedFile;
    if(isGallery){
      pickedFile = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 70);
    }
    else{
      pickedFile = await picker.pickImage(
          source: ImageSource.camera, imageQuality: 70);
    }

    int length = await pickedFile!.length();
    print('the length is');
    // print('size : ${length}');
    print('size: ${await pickedFile.readAsBytes()}');
    // File? croppedFile;
    // try {
    // croppedFile = await ImageCropper().cropImage(
    //       cropStyle: CropStyle.circle,
    //       // aspectRatio: CropAspectRatio(ratioX: 9, ratioY: 16),
    //       compressQuality: length > 100000 ? length > 200000 ? length > 300000
    //           ? length > 400000 ? 5 : 10
    //           : 20 : 30 : 50,
    //       sourcePath: pickedFile.path,
    //       aspectRatioPresets: [
    //         CropAspectRatioPreset.square,
    //         CropAspectRatioPreset.ratio3x2,
    //         CropAspectRatioPreset.original,
    //         CropAspectRatioPreset.ratio4x3,
    //         CropAspectRatioPreset.ratio16x9
    //
    //       ],
    //       androidUiSettings: AndroidUiSettings(
    //           activeControlsWidgetColor: MyColors.primaryColor,
    //           toolbarTitle: 'Adjust your Post',
    //           toolbarColor: MyColors.primaryColor,
    //           toolbarWidgetColor: MyColors.white,
    //           initAspectRatio: CropAspectRatioPreset.original,
    //           lockAspectRatio: true),
    //       iosUiSettings: IOSUiSettings(
    //         minimumAspectRatio: 1.0,
    //       ));
    //
    //
    // }catch(e){
    //   print('cropper--image ---$e');
    //   showSnackbar('Something went wrong $e');
    // }
    try{
      _imageFile = pickedFile.path;
      image = File(pickedFile.path);
    }catch(e){
      print('there is error in  image picker $e');
      // _imageFile = pickedFile!.path;
      // image = File(pickedFile.path);
    }


    // print('---croppedFile----$croppedFile');
    print('image image------$image');
    // setState(() {
    // });

    return image;
  } catch (e) {
    print("Image picker error --$e");
  }
  return null;



}

Future<List<XFile>?>Multiple_ImagePicker(context) async{
  final ImagePicker picker = ImagePicker();
  final List<XFile>? pickedFiels;
  try{
    pickedFiels = await picker.pickMultiImage(
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: MediaQuery.of(context).size.height,
      imageQuality: 10,
    );
    return pickedFiels;
  } catch(err) {
    print('multiple image catch err----$err');
  }
  return null;

}

Future<File?> Imagepicker_Without_Croper(bool isGallery) async {
  final ImagePicker picker = ImagePicker();
  File? image;
  String? _imageFile;
  try {
    print('about to pick image');
    XFile? pickedFile;
    FilePickerResult? file;
    if(isGallery){
      pickedFile = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 70);
    }
    else{
      pickedFile = await picker.pickImage(
          source: ImageSource.camera, imageQuality: 70);
    }
    print('the error is $pickedFile');
    // int length = await pickedFile!.length();
    print('the length is');
    // print('size : ${length}');
    // print('size: ${pickedFile.readAsBytes()}');

    image = isGallery?File(file!.files.single.path!):File(pickedFile!.path);
    // print(croppedFile);
    print(image);
    // setState(() {
    // });
    return image;
  } catch (e) {
    print("Image picker error $e");
  }
  return null;
}

