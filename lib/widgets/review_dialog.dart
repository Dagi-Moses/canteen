import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../../models/menus.dart';
import '../../models/review.dart';
import '../providers/userProvider.dart';
import '../providers/firebase functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ReviewDialog extends StatelessWidget {
  final String menuID;
  final Menus menu;
  const ReviewDialog({Key? key, required this.menuID, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseFunctions =
        Provider.of<FirebaseFunctions>(context, listen: false);

      final app = AppLocalizations.of(context)!;
    return RatingDialog(
      title:  Text(
        app.typeReview,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?

      submitButtonText:app.send,
      commentHint: app.typeHere,

      onSubmitted: (RatingDialogResponse res) async {
        String image = await firebaseFunctions.getUserImage();
      firebaseFunctions.uploadReview(
            menuId: menuID,
            model: Review(
              reviewDate: DateTime.now(),
              raterImage: image,
              raterId: FirebaseAuth.instance.currentUser!.uid,
              senderName:
                  Provider.of<UserProvider>(context, listen: false).user!.firstName!,
              description: res.comment,
              rating:res.rating,
            ), menu: menu);
      },
    );
  }
}
