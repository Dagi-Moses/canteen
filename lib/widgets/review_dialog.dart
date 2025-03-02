import 'package:canteen/providers/menusProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import '../../models/menus.dart';
import '../../models/review.dart';
import '../providers/userProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ReviewDialog extends StatelessWidget {

   Menus menu;
   ReviewDialog({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuProvider =
        Provider.of<MenuProvider>(context);
    final userProvider = Provider.of<UserProvider>(
      context,
    );
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
   
      menuProvider.uploadReview(
         
            model: Review(
              reviewDate: DateTime.now(),
              raterImage:  userProvider.user!.profileImage ?? "" ,
              raterId: FirebaseAuth.instance.currentUser!.uid,
              senderName:
                 userProvider.user!.firstName!,
              description: res.comment,
              rating:res.rating,
            ), menu: menu);
      },
    );
  }
}
