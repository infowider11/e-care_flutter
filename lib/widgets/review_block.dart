
// ignore_for_file: deprecated_member_use, non_constant_identifier_names, avoid_print

import 'package:ecare/widgets/custom_circular_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constants/colors.dart';
import '../constants/sized_box.dart';
import 'CustomTexts.dart';

class ReviewBlock extends StatelessWidget {
  final bool? is_network_image;
  final String? image_url;
  final String name;
  final String? time;
  final double? rating;
  final String? rate_msg;
  const ReviewBlock({Key? key,
    this.is_network_image=false,
    this.image_url,
    required this.name,
    this.rating=0,
    this.time = '8:00 pm - 9:00 pm',
    this.rate_msg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if(is_network_image!)
              CustomCircularImage(imageUrl: image_url!),
            // Image.asset('assets/images/23.png', width: 50,),
            hSizedBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainHeadingText(text: name, fontSize: 16,),
                MainHeadingText(text: time!, fontFamily: 'light', fontSize: 14, color: MyColors.onsurfacevarient,),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: rating!,//rating!,
                      minRating: 1,

                      direction:
                      Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 15,
                      itemPadding:
                      const EdgeInsets.symmetric(
                          horizontal: 0.0),
                      itemBuilder:
                          (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rate) {
                        print(
                            'rating------$rate');
                      },
                    ),
                  ],
                )
              ],
            )
          ],
        ),

        vSizedBox,
        if(rate_msg!=null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              // width: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: MyColors.lightBlue.withOpacity(0.11),
              ),
              child: MainHeadingText(text: rate_msg!, color: MyColors.onsurfacevarient, fontSize: 14, fontFamily: 'light',),
            ),
          ),
        vSizedBox4
      ],
    );
  }
}



// import 'package:flutter/material.dart';
//
// import '../constants/colors.dart';
// import '../constants/sized_box.dart';
// import 'CustomTexts.dart';
//
// class ReviewBlock extends StatelessWidget {
//   // final bool is_network_image;
//   const ReviewBlock({Key? key,
//   // this.is_
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Image.asset('assets/images/23.png', width: 50,),
//             hSizedBox,
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 MainHeadingText(text: 'John Smith', fontSize: 16,),
//                 MainHeadingText(text: '8:00 pm - 9:00 pm', fontFamily: 'light', fontSize: 14, color: MyColors.onsurfacevarient,),
//                 Row(
//                   children: [
//                     Icon(Icons.star, color: Colors.amber, size: 16,),
//                     Icon(Icons.star, color: Colors.amber, size: 16,),
//                     Icon(Icons.star, color: Colors.amber, size: 16,),
//                     Icon(Icons.star, color: Colors.amber, size: 16,),
//                     Icon(Icons.star, color: Colors.grey, size: 16,),
//                   ],
//                 )
//               ],
//             )
//           ],
//         ),
//
//         vSizedBox,
//         Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             color: MyColors.lightBlue.withOpacity(0.11),
//           ),
//           child: MainHeadingText(text: 'Is It a Good Choice to Buy Cryptocurrency, Bitcoin Now? Is It a Good Choice to Buy Cryptocurrency, Bitcoin Now? Is It a Good  to Buy Cryptocurrency, ', color: MyColors.onsurfacevarient, fontSize: 14, fontFamily: 'light',),
//         ),
//
//         vSizedBox4
//       ],
//     );
//   }
// }
