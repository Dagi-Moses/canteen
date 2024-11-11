import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PageInfo {
  final String title;
  final String body;
  final String img;

  PageInfo({
    required this.title,
    required this.body,
    required this.img,
  });
}

List<PageInfo> pageInfos(BuildContext context) {
   final app = AppLocalizations.of(context)!;
  return [
    PageInfo(
      title: app.pageInfo1Title,
      body: app.pageInfo1Body,
      img: app.pageInfo1Img,
    ),
    PageInfo(
      title: app.pageInfo2Title,
      body: app.pageInfo2Body,
      img: app.pageInfo2Img,
    ),
    PageInfo(
      title: app.pageInfo3Title,
      body: app.pageInfo3Body,
      img: app.pageInfo3Img,
    ),
  ];
}
