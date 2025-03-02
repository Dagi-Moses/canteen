import 'package:canteen/widgets/placeHolders.dart/profilePlaceHolder.dart';
import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatelessWidget {
  String? imageUrl;
  VoidCallback onTap;
  double size;

  ProfilePictureWidget({
    Key? key,
    required this.imageUrl,
    required this.onTap,
    this.size = 120.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[600]!, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipOval(
              child: Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            width: size,
            height: size,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child; // Image loaded
              } else {
                return profilePlaceholder();
              }
            },
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              return profilePlaceholder();
            },
          )),
        ),

        // Camera Icon
        Positioned(
          right: 4,
          bottom: 4,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
