import 'package:canteen/providers/menusProvider.dart';
import 'package:canteen/util/arguments.dart';
import 'package:canteen/util/routes.dart';
import 'package:canteen/util/screenHelper.dart';
import 'package:canteen/widgets/slider_item.dart';
import 'package:canteen/widgets/smooth_star_rating.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/menus.dart';
import '../../models/searchHistoryManager.dart';

import '../util/const.dart';




class HistoryWidget extends StatefulWidget {
  final Menus menu;
  final FocusNode focusNode;
  final MenuProvider menuProvider;
  HistoryWidget({super.key, required this.menu, required this.focusNode, required this.menuProvider});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}
class _HistoryWidgetState extends State<HistoryWidget> {
  final SearchManager _history = SearchManager();

  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context)!;

    final isCompact = ScreenHelper.isMobile(context); // Adjust threshold as needed

    return isCompact
        ? _buildCompactLayout(
           app ) // Compact layout for single-column or mobile
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SliderItem(model: widget.menu, menuProvider: widget.menuProvider, onTap: _handleTap,),
        );
  }

  Widget _buildCompactLayout(app) {
    return  ListTile(
      title: Text(
        widget.menu.menuTitle,
        style: TextStyle(
//                    fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
      leading: CircleAvatar(
        radius: 25.0,
        backgroundImage: NetworkImage(
          widget.menu.thumbnailUrl,
        ),
      ),
      trailing: RichText(
          text: TextSpan(
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242)),
              children: [
            const TextSpan(
              text: r"₦",
            ),
            TextSpan(
              text: widget.menu.menuPrice.toString(),
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ])),
      subtitle: Row(
        children: <Widget>[
           SmoothStarRating(
              borderColor: Constants.ratingBG,
              starCount: 5.0,
              color: Constants.ratingBG,
              allowHalfRating: true,
              rating: widget.menu.rating,
              size: 12.0,
            ),
         
          SizedBox(width: 6.0),
          Text(
          "${widget.menu.rating.toStringAsFixed(1)} (${widget.menu.raters.length} ${widget.menu.raters.length == 1 ? app.review : app.reviews})",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
      onTap: _handleTap
    );
  }


  void _handleTap()async {
    widget.focusNode.unfocus();
   _history.saveMenusToSharedPreferences(widget.menu);
   await Future.delayed(Duration.zero);
    Navigator.pushNamed(
      context,
      Routes.productDetails,
      arguments: ProductDetailsArguments(model: widget.menu),
    );
  }
}
