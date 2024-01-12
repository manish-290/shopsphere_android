import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/provider/app_provider.dart';

import '../../model/product_model/product_model.dart';


class SingleFavouriteItem extends StatefulWidget {
   final ProductModel singleProduct;
  const SingleFavouriteItem({super.key,required this.singleProduct});

  @override
  State<SingleFavouriteItem> createState() => _SingleFavouriteItemState();
}

class _SingleFavouriteItemState extends State<SingleFavouriteItem> {

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return   Container(
          margin: EdgeInsets.only(bottom: 12),
          child:Row(
            children: [
              Expanded(
                child: Container(
                  height: 140,
                  
                  color: Color.fromARGB(255, 2, 35, 62).withOpacity(0.3) ,
                  child: Image.network(
                    widget.singleProduct.image
                  ),
                ),
              ),
    
               Expanded(
                flex: 2,
                child: Container(
                  height: 145,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      
                      children: [
                  
                      Column(
                       
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                        Text(widget.singleProduct.name,style:TextStyle(
                          color:Color.fromARGB(255, 2, 35, 62),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                        SizedBox(height: 15,),
                        
                        Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: OutlinedButton(
                        style:OutlinedButton.styleFrom(
                          
                          side: BorderSide(color:const Color.fromARGB(255, 248, 21, 5),width: 3)
                        ),
                          onPressed: (){
                            
                      AppProvider appProvider = Provider.of<AppProvider>(context,listen: false);
                      appProvider.removeFavouriteProduct(widget.singleProduct);
                     setState(() {
                       widget.singleProduct.isFavourite = false;
                       print(widget.singleProduct.isFavourite);
                     });
                      
                            
                          },
                           child: Text('Remove from Wishlist',style:GoogleFonts.lato(
                            color: Color.fromARGB(255, 9, 53, 88),
                            fontSize: 8
                           ))),
                        ),
                        
                      ],),
                      Text("\$${widget.singleProduct.price}" ,style:GoogleFonts.lato(
                        color:Color.fromARGB(255, 43, 133, 46),
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                      )),
                    ]),
                    
                  ),
                  
                  
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              width: 3,
              color: Color.fromARGB(255, 2, 35, 62))
          ),
        );
      
    
  }
}