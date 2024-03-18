import 'package:ecare/widgets/showSnackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../constants/colors.dart';



enum FileType {
  Gallery,
  Camera,
  Video,
}
Future pickImage01( fileType) async {
  File? image;
  final ImagePicker imagePicker = ImagePicker();
  XFile? pickedFile;
  if (fileType == FileType.Camera) {
    // Camera Part
    pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 480,
      maxHeight: 640,
      imageQuality: 25, // pick your desired quality
    );

      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
        return;
      }

  } else if (fileType == FileType.Gallery) {
    // Gallery Part
    pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 480,
      maxHeight: 640,
      imageQuality: 25,
    );
  } else {
    print('No image selected.');
    return;
  }
  image=File(pickedFile!.path);
return image;
}


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
    File? croppedFile;
    try {
    croppedFile = await ImageCropper().cropImage(
          cropStyle: CropStyle.circle,
          // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: length > 100000 ? length > 200000 ? length > 300000
              ? length > 400000 ? 5 : 10
              : 20 : 30 : 50,
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            // CropAspectRatioPreset.ratio3x2,
            // CropAspectRatioPreset.original,
            // CropAspectRatioPreset.ratio4x3,
            // CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              activeControlsWidgetColor: MyColors.primaryColor,
              toolbarTitle: 'Adjust your Post',
              toolbarColor: MyColors.primaryColor,
              toolbarWidgetColor: MyColors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));


    }catch(e){
      print('cropper--image ---$e');
      showSnackbar('Something went wrong $e');
    }
    try{
      _imageFile = croppedFile!.path;
      image = File(croppedFile.path);
    }catch(e){
      showSnackbar('dddkk $e');
      _imageFile = pickedFile!.path;
      image = File(pickedFile.path);
    }


    print('---croppedFile----$croppedFile');
    print('image image------$image');
    // setState(() {
    // });

    return image;
  } catch (e) {
    print("Image picker error --$e");
  }



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
}

