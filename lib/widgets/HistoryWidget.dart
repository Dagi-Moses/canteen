import 'package:canteen/widgets/smooth_star_rating.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/menus.dart';
import '../../models/searchHistoryManager.dart';
import '../screens/details.dart';
import '../util/const.dart';

class HistoryWidget extends StatefulWidget {
  final Menus menu;
  final FocusNode focusNode;
  HistoryWidget({super.key, required this.menu, required this.focusNode});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  final SearchManager _history = SearchManager();
  @override
  Widget build(BuildContext context) {
       final app = AppLocalizations.of(context)!;
    return ListTile(
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
            starCount: 1,
            color: Constants.ratingBG,
            allowHalfRating: true,
            rating: 5,
            size: 12.0,
          ),
          SizedBox(width: 6.0),
          Text(
            " ${widget.menu.rating.toString()} (${widget.menu.raters.length.toString() + app.reviews} )",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
      onTap: () {
        widget.focusNode.unfocus();
        _history.saveMenusToSharedPreferences(widget.menu);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductDetails(
                isFav: widget.menu.likes
                    .contains(FirebaseAuth.instance.currentUser!.uid),
                model: widget.menu,
              );
            },
          ),
        );
      },
    );
  }
}
