import 'package:canteen/models/pageInfo.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:canteen/screens/join.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Walkthrough extends StatefulWidget {
  
  @override
  _WalkthroughState createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {
  @override
  Widget build(BuildContext context) {
      final app = AppLocalizations.of(context)!;
    List<PageViewModel> pages = [
      for(int i = 0; i<pageInfos(context).length ; i++)
        _buildPageModel(pageInfos(context)[i])
    ];

    return PopScope(
      canPop:false ,
      //onWillPop: ()=>Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child:  Padding(
            padding: EdgeInsets.all(10.0),
            child: IntroductionScreen(
              allowImplicitScrolling: true,
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

  _buildPageModel(PageInfo item){
    return PageViewModel(

      title: item.title,
      //body: item.body,
      bodyWidget: LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 850), // Adjust max width as needed
            child: Text(
              item.body,
              style: TextStyle(fontSize: 15.0), // Keep body text style
              textAlign: TextAlign.center, // Center align for better readability
            ),
          ),
        );
      },
    ),

      image: Image.asset(
        item.img,
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