import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'loader.dart';
enum CustomFileType { asset, network, file }

class CustomCircularImage extends StatelessWidget {
  final double height;
  final double width;
  final double? borderRadius;
  final String imageUrl;
  final CustomFileType fileType;
  final File? image;
  final BoxFit? fit;
  const CustomCircularImage({
    Key? key,
    required this.imageUrl,
    this.image,
    this.height = 60,
    this.width = 60,
    this.borderRadius,
    this.fileType = CustomFileType.network,
    this.fit
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius??height),
        image:fileType==CustomFileType.asset?  DecorationImage(
            image: AssetImage(
                imageUrl
            )
        ):fileType==CustomFileType.file?
        DecorationImage(
            image: FileImage(
                image!
            ))
            :
        // DecorationImage(
        //   image: NetworkImage(
        //     imageUrl
        //   ),
        //
        //   fit: fit??BoxFit.cover,
        // ),
        null
      ),
      child: fileType==CustomFileType.network?CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => Padding(
          padding: const EdgeInsets.all(14.0),
          child: CustomLoader(),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ):null,

    );
  }
}
// class CustomCircularImage1 extends StatelessWidget {
//   final double height;
//   final double width;
//   final double? borderRadius;
//   final String imageUrl;
//   final CustomFileType fileType;
//   final File? image;
//   final BoxFit? fit;
//   const CustomCircularImage1({
//     Key? key,
//     required this.imageUrl,
//     this.image,
//     this.height = 60,
//     this.width = 60,
//     this.borderRadius,
//     this.fileType = CustomFileType.network,
//     this.fit
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(borderRadius??height),
//           image:fileType==CustomFileType.asset?  DecorationImage(
//               image: AssetImage(
//                   imageUrl
//               )
//           ):DecorationImage(
//             image: NetworkImage(
//                 imageUrl
//             ),
//
//             fit: fit,
//           )
//       ),
//
//
//     );
//   }
// }