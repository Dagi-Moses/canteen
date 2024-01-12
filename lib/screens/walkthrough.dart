import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:canteen/screens/join.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class Walkthrough extends StatefulWidget {
  
  @override
  _WalkthroughState createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {

  // List pageInfos = [
  //   {
  //     "title": "Fresh Food",
  //     "body": "Experience the essence of freshness at our canteen. We take pride in serving you the "
  //     "finest, high-quality ingredients that create delectable dishes to tantalize your taste buds." 
  //     "From farm-fresh produce to carefully selected meats,"
  //     " every meal is a testament to our commitment to serving you the best.",
  //     "img": "assets/on1.png",
  //   },
  //   {
  //     "title": "Fast Delivery",
  //     "body": "Hungry and in a hurry? No worries! Our lightning-fast "
  //     "delivery ensures that your food is at your doorstep in no time. We understand the value of your time, and "
  //     "our quick and efficient service guarantees that you get your favorite meals hot and fresh when you need them.",
  //     "img": "assets/on2.png",
  //   },
  //   {
  //     "title": "Easy Payment",
  //     "body": "Convenience is key when it comes to payment at our canteen. We offer" 
  //     "hassle-free payment options that make your dining experience even more enjoyable." 
  //     "Whether it's cashless transactions, mobile payments, or "
  //     "traditional methods, we've got you covered for a seamless and easy payment process.",
  //     "img": "assets/on3.png",
  //   },
  // ];
  @override
  Widget build(BuildContext context) {
      final app = AppLocalizations.of(context)!;
    List<PageViewModel> pages = [
      for(int i = 0; i<app.pageInfos.length ; i++)
        _buildPageModel(app.pageInfos[i])
    ];

    return PopScope(
      canPop:false ,
      //onWillPop: ()=>Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: IntroductionScreen(
              pages: pages,
              onDone: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return JoinApp(canPop: true,);
                    },
                  ),
                );
              },
              onSkip: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return JoinApp(canPop: true,);
                    },
                  ),
                );
              },
              showSkipButton: true,
              skip: Text(app.skip),
              next: Text(
               app.next,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.red
                ),
              ),
              done: Text(
                app.done,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.red,
                ),
              ),
             dotsDecorator: DotsDecorator(
           activeColor: Colors.red,
           activeSize: Size.fromRadius(5),
          
                 ),
              
            ),
          ),
        ),
      ),
    );
  }

  _buildPageModel(Map item){
    return PageViewModel(
      title: item['title'],
      body: item['body'],
      image: Image.asset(
        item['img'],
        height: 185.0,
      ),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          
          fontSize: 32.0,
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
        bodyTextStyle: TextStyle(fontSize: 15.0),

        pageColor: Colors.white,
      ),
      
    );
  }
}