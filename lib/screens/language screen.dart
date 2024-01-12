import 'package:canteen/providers/app_provider.dart';
import 'package:canteen/screens/walkthrough.dart';
import 'package:canteen/util/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../widgets/language widget.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    final List<String> languageNames = [
      "English",
      "Français",
      "Yorùbá",
      "Igbo",
    ];
    final List<String> languageCodes = [
      "en",
      "fr",
      "yo",
      "ig",
    ];
    
    final app = AppLocalizations.of(context)!;
  
    return Scaffold(
      body: SafeArea(
        child: Center(
                child: Padding(
        padding: EdgeInsets.only(
          right: 10,
          left: 10,
            bottom: MediaQuery.of(context).padding.bottom + 20),
            
        child: Column(
          children: [
            Expanded(
                child: Center(
              child: Scrollbar(
                  child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(5),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Icon(
                            Icons.fastfood,
                            size: 110.0,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(app.selectLanguage),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                          ),
                          itemCount: languageNames.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => LanguageWidget(
                           
                          
                            index: index,
                            languageName: languageNames[index],
                            languageCode: languageCodes[index],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(child: Text(app.changeLanguage)),
                      ],
                    ),
                  ),
                ),
              )),
            ))
          ],
        ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Text(app.next),
          backgroundColor: Colors.red,
          onPressed: () {
             
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
              return Walkthrough();
            }));
          }),
    );
  }
}
