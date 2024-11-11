
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List categories(BuildContext context) {
  final app = AppLocalizations.of(context)!;

return [
  {
    "name": app.categoryDrinks,
    "icon": FontAwesomeIcons.wineBottle,
    "items": 5
  },
  {
    "name": app.categoryMiscellaneous,
    "icon": FontAwesomeIcons.cannabis,
    "items": 20
  },
  {
    "name": app.categoryDesert,
    "icon": FontAwesomeIcons.cakeCandles,
    "items": 9
  },
  {
    "name": app.categoryFastFood,
    "icon": FontAwesomeIcons.pizzaSlice,
    "items": 5
  },
  {
    "name": app.categoryMeals,
    "icon": FontAwesomeIcons.breadSlice,
    "items": 15
  },
];
}