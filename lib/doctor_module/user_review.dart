
// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, non_constant_identifier_names

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/review_block.dart';
import 'package:flutter/material.dart';

import '../services/api_urls.dart';
import '../services/webservices.dart';

class UserReviewPage extends StatefulWidget {
  final String? booking_id;
  const UserReviewPage({Key? key,this.booking_id}) : super(key: key);

  @override
  State<UserReviewPage> createState() => _UserReviewPageState();
}

class _UserReviewPageState extends State<UserReviewPage> {
  List lists = [];
  bool load = false;

  @override
  void initState() {
    
    super.initState();
    get_reviews();
  }

  get_reviews() async{
    setState(() {
      load = true;
    });
    Map<String,dynamic> data = {
      'user_id':await getCurrentUserId(),
      // 'booking_id':widget.booking_id.toString(),
    };
    var res = await Webservices.postData(apiUrl: ApiUrls.reviews_list,body:data,context:context);
    // var res = await Webservices.getList(apiUrl: ApiUrls.reviews_list);
    print('successfully-------${res}');
    if(res['status'].toString()=='1'){
      lists=res['data'];
    }
    setState(() {
      load=false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(context: context, appBarColor: MyColors.BgColor),
      body: load?const CustomLoader():SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainHeadingText(text: 'User Reviews', fontFamily: 'light', fontSize: 32,),
            vSizedBox4,

            for(int i=0;i<lists.length;i++)
            ReviewBlock(
              name: '${lists[i]['user_data']['first_name']} ${lists[i]['user_data']['last_name']}',
              rate_msg: '${lists[i]['review']}',
              is_network_image: true,
              rating: double.parse(lists[i]['rate'].toString()),
              image_url: lists[i]['user_data']['profile_image'],
              time: '${lists[i]['time_ago']}',
            ),
            if(lists.length==0)
            const Center(
              child: Text('No reviews yet'),
            ),
            // ReviewBlock(),
            // ReviewBlock(),
            // ReviewBlock(),
            // ReviewBlock(),

          ],
        ),
      ),
    );
  }
}
