
import 'package:flutter/material.dart';

class CustomImagePlaceHolderWidget extends StatelessWidget {
 
 

  const CustomImagePlaceHolderWidget({
    Key? key,
  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
                aspectRatio: 3 / 2, // Placeholder aspect ratio
                child: Container(
        
                    decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey[200], // Placeholder background
            ),
                  
                  child: Center(
                    child: Icon(
                      Icons.image, // Placeholder icon
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
        Positioned(
          right: 8.0, // Adjust to align with the image
          bottom: 8.0, // Adjust to align with the image
          child: RawMaterialButton(
            onPressed: (){},
            fillColor: Colors.white,
            shape: const CircleBorder(),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(
               Icons.favorite ,
                color: Colors.red,
                size: 17,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
