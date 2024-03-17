import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/cart_screen/single_cart_item.dart';
import 'package:shop_sphere/favourite-screen/widget_of_favourite/single_favourite_item.dart';
import 'package:shop_sphere/provider/app_provider.dart';

import '../model/product_model/product_model.dart';

class FavouriteScreen extends StatefulWidget {
  
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
 
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider =Provider.of<AppProvider>(context,listen:false);
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.transparent,
          flexibleSpace:Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color.fromARGB(255, 3, 65, 115), Color.fromARGB(255, 176, 5, 202)], // Add your desired colors here
              ),
            ),
          ) ,
        centerTitle: true,
        title: Text('My Favourites',style:GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ))
      ),
      
      body: 
      Consumer<AppProvider>(
        builder: (context,appProvider,child){
        
          return   appProvider.getFavouriteProductList.isEmpty?Center(child:Text("No Favourites"))
         : ListView.builder(
        itemCount: appProvider.getFavouriteProductList.length,
        padding: EdgeInsets.all(12),
        itemBuilder: (context,index){
        return SingleFavouriteItem(singleProduct:appProvider.getFavouriteProductList[index],);
      });
        },)
    );
  }
}