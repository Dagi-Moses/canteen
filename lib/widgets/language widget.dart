import 'package:canteen/providers/app_provider.dart';
import 'package:canteen/util/const.dart';
import 'package:canteen/widgets/regularText.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageWidget extends StatefulWidget {
  final int index;
  final String languageName;
  final String languageCode;

  LanguageWidget({
    super.key,
    required this.index,
    required this.languageName,
    required this.languageCode,
  });

  @override
  State<LanguageWidget> createState() => _LanguageWidgetState();
}

class _LanguageWidgetState extends State<LanguageWidget> {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context, listen: true);

    return InkWell(
      onTap: () {
        app.setPreferredLanguage(widget.languageCode);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200]!,
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ]),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              app.selectedLanguageIndex == widget.index
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.red,
                      size: 20,
                    )
                  : SizedBox(),
              SizedBox(
                height: 5,
              ),
            //  Text(widget.languageName)
             CustomText(
                text: widget.languageName,
                fontWeight: FontWeight.bold, // Custom font weight
               // Custom text color
              ),

              

            ],
          ),
        ),
      ),
    );
  }
}
