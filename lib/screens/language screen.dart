import 'package:canteen/util/const.dart';
import 'package:canteen/util/routes.dart';
import 'package:canteen/util/screenHelper.dart';
import 'package:canteen/widgets/regularText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/language widget.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}



class _LanguageScreenState extends State<LanguageScreen> {
  late AppLocalizations app;
  late int crossAxisCount;
  @override
  Widget build(BuildContext context) {
    app = AppLocalizations.of(context)!;
    crossAxisCount = ScreenHelper.isDesktop(context)
        ? 4
        : ScreenHelper.isTablet(context)
            ? 3
            : 2;

    return Scaffold(
      body: SafeArea( 
        child: ScreenHelper(
          mobile: _buildMobileContent(),
          tablet: _buildTabletContent(),
          desktop: _buildTabletContent(),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
  EdgeInsets _commonPadding() {
    return EdgeInsets.only(
      right: 10,
      left: 10,
      bottom: MediaQuery.of(context).padding.bottom + 20,
    );
  }
Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Text(app.next),
      backgroundColor: Colors.red,
      onPressed: () {
        Navigator.pushReplacementNamed(context, Routes.walkThrough);
      },
    );
  }


  Widget _buildMobileContent() {
    return Center(
      child: Padding(
        padding: _commonPadding(),
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
                            _buildIcon(),
                            SizedBox(height: 30),
                            _selectLanguageText(),
                            SizedBox(height: 10),
                            _buildGrid(),
                            SizedBox(height: 60),
                            _changeLanguageText()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletContent() {
    return Padding(
      padding: _commonPadding(),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(),
                    Column(
                      children: [
                        _buildIcon(),
                        SizedBox(height: 30),
                        _selectLanguageText(),
                        SizedBox(height: 25),
                        _buildGrid(),
                      ],
                    ),
                    SizedBox(),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: _changeLanguageText()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Icon(
      Icons.fastfood,
      size: 110.0,
      color: Colors.red,
    );
  }

  Widget _selectLanguageText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        app.selectLanguage,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _changeLanguageText() {
    return CustomText(
      text: app.changeLanguage,
      fontWeight: FontWeight.bold,
      color: Colors.blue,
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1,
      ),
      itemCount: languageNames.length,
      // physics: NeverScrollableScrollPhysics(),
       shrinkWrap: true,
      itemBuilder: (context, index) => LanguageWidget(
        index: index,
        languageName: languageNames[index],
        languageCode: languageCodes[index],
      ),
    );
  }
}
