import 'package:flutter/material.dart';

signout({required BuildContext context , required VoidCallback onTap}) {
  return showDialog(
      context: context,
      builder: (c) {
        return SimpleDialog(
          title: const Text(
            "Are you sure you want to sign out?",
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          children: [
            Row(
              children: [
                SimpleDialogOption(
                  child: const Center(
                    child: Text(
                      "Yes",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  onPressed: onTap,
                ),
                SimpleDialogOption(
                  child: const Center(
                    child: Text(
                      "No",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  onPressed: () => {Navigator.pop(context)},
                ),
              ],
            )
          ],
        );
      });
}
