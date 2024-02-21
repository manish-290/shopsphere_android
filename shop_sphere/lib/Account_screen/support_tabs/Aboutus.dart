import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us',
        style:GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          color:Colors.white,
          fontSize: 16
        )),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body:Center(child: Column(children: [
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:15.0,vertical:15),
          child: Text(" This mobile app, including its content, design, logos, and images, is protected by copyright law. Unauthorized reproduction, distribution, or use of this app's content is strictly prohibited. ShopSphere is a registered trademark of ShopSphere, Inc. Any use of the ShopSphere trademark without written consent is prohibited. User-generated content, such as product reviews and comments, remains the property of the respective users. By contributing content, users grant ShopSphere a non-exclusive, worldwide license to use and display that content. ShopSphere is committed to DMCA compliance. If you believe your copyright has been violated within the app, please contact our designated copyright agent at copyright@shopsphere.com."
          ,style:GoogleFonts.lato(
            fontSize:13,
          )),
        ),
       const Gutter(),
       const Gutter(),
        Text("Copyright © 2023 ShopSphere. All rights reserved.",
        style:GoogleFonts.lato(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color:Colors.grey[600]
        ))
      ],))
    );
  }
}