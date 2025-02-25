// ignore_for_file: camel_case_types, deprecated_member_use

import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/welcome_next.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants/sized_box.dart';
import 'constants/colors.dart';
import 'constants/image_urls.dart';

class Welcome_Page extends StatefulWidget {
  const Welcome_Page({Key? key}) : super(key: key);

  @override
  State<Welcome_Page> createState() => _Welcome_PageState();
}
bool loading = false;

class _Welcome_PageState extends State<Welcome_Page> {
  PageController controller = PageController();
  page1() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,

        ),

        Positioned(
          top: 0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                vSizedBox2,
                vSizedBox4,
                Center(
                  child: Image.asset(
                    width: MediaQuery.of(context).size.width,
                    MyImages.logo,
                    fit: BoxFit.fitHeight,
                    height: 170,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            height: MediaQuery.of(context).size.height - 350,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      MyImages.welcome_background,
                    ),
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomLeft), // color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                )),
            child:  const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                vSizedBox8,
                vSizedBox16,
                MainHeadingText(
                  text: 'Expert Healthcare at \nyour fingertips',
                  color: MyColors.white,
                  fontSize: 32,
                  fontFamily: 'light',
                  height: 1.2,
                ),


                vSizedBox16,
                ParagraphText(
                  text:
                      'Access to Expert HPCSA Board-certified Healthcare practitioners from around South Africa',
                  color: MyColors.white,
                  fontSize: 16,
                ),
                vSizedBox4,
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                itemCount: 1,
                controller: controller,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return page1();
                    default:
                      return page1();
                  }
                },
              ),
              Positioned(
                bottom: 40,
                // alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmoothPageIndicator(
                          controller: controller, // PageController
                          count: 1,
                          effect: ExpandingDotsEffect(
                            // activeStrokeWidth: 2.6,
                            // activeDotScale: 1.3,
                            // maxVisibleDots: 5,
                            radius: 8,
                            spacing: 6,
                            dotHeight: 8,
                            dotWidth: 15,
                            activeDotColor: MyColors.primaryColor,
                            dotColor: const Color(0xFF567DF4).withOpacity(0.2),
                          ), // your preferred effect
                          onDotClicked: (index) {}),
                      // if (page1())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        backgroundColor: const Color(0xFFCAE6FF),
        onPressed: () {
          push(context: context, screen: const Welcome_Page_Next());
        },
        tooltip: 'Increment',
        child: const Icon(
          Icons.arrow_forward_outlined,
          size: 20,
          color: MyColors.headingcolor,
        ),
      ),
    );
  }

  
}
