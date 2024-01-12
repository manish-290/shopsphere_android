import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/model/product_model/product_model.dart';
import 'package:shop_sphere/provider/app_provider.dart';

class SingleCartItem extends StatefulWidget {
 final ProductModel singleProduct;
   const SingleCartItem({super.key, required this.singleProduct});


  @override
  State<SingleCartItem> createState() => _SingleCartItemState();
}

class _SingleCartItemState extends State<SingleCartItem> {
  double counter = 1;

@override
void initState(){
  super.initState();
  counter = (widget.singleProduct.counter??1.0) as double;
}
void  showAlertDialog(BuildContext context) async{
  
   showDialog(
                              
                  barrierColor: Colors.transparent,
                  context: context,
                  
                   builder: (context)=>AlertDialog(
                    elevation: 10,
                    icon: Icon(Icons.check_box,color: const Color.fromARGB(255, 5, 242, 13),),
                    backgroundColor: Color.fromARGB(111, 110, 164, 206),
                    title: Text('Removed from the cart',style:GoogleFonts.lato(
                      color:const Color.fromARGB(255, 2, 56, 100),
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )),
                   ));
                 await  Future.delayed(Duration(seconds: 1),(){
                   
                      Navigator.pop(context);
                    
                      
                    
                    
                   });
}

  @override
  Widget build(BuildContext context) {
 AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
          margin: EdgeInsets.only(bottom: 12),
          child:Row(
            children: [
              Expanded(
                child:  Container(
                  height: 140,
                  color: Color.fromARGB(255, 2, 35, 62).withOpacity(0.3) ,
                  child:  Image.network(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        FittedBox(
                          child: Text(widget.singleProduct.name,style:TextStyle(
                            color:Color.fromARGB(255, 2, 35, 62),
                            fontWeight: FontWeight.bold
                          )),
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              
                              style: ElevatedButton.styleFrom(
                               
                                shape: CircleBorder(),
                                backgroundColor: Colors.pink
                              ),
                              onPressed: (){
                                 if(counter>0){
                                    setState(() {
                                      counter--;
                                });
                                  }
                                
                                appProvider.updateQuantity(
                                  widget.singleProduct, counter);
                              },
                               child:Icon(Icons.remove,color:Colors.white) ),
                      
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:1.0),
                              child: Text("$counter",style:GoogleFonts.lato(
                                color:Color.fromARGB(255, 2, 35, 62),
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                              )),
                            ),
                      
                                 ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Colors.pink
                              ),
                              onPressed: (){
                                setState(() {
                                  counter++;
                                });
                                appProvider.updateQuantity(
                                  widget.singleProduct, counter );
                              },
                               child:Icon(Icons.add,color:Colors.white) ),
                      
                          ],
                        ),
                        
                        Row(
                          
                          children: [
                          Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: OutlinedButton(
                          style:OutlinedButton.styleFrom(
                            
                            side: BorderSide(color:Color.fromARGB(255, 6, 59, 103),width: 3)
                          ),
                            onPressed: (){
                              
                              setState(() {
                                  widget.singleProduct.isFavourite = !widget.singleProduct.isFavourite;
                              if(!appProvider.getFavouriteProductList.contains( widget.singleProduct
                             )){
                                appProvider.addFavouriteProduct(widget.singleProduct);
                              }else{
                                appProvider.removeFavouriteProduct(widget.singleProduct);
                              }
                              });

                            },
                             child: Text(appProvider.getFavouriteProductList.contains(
                              widget.singleProduct
                             )?'Remove from the Wishlist':'Add to Wishlist',style:GoogleFonts.lato(
                              color: Color.fromARGB(255, 9, 53, 88),
                              fontSize: 8
                             ))),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 248, 22, 5)
                          ),
                          onPressed: () {   
                                   
                           
                           appProvider.removeCartProduct(widget.singleProduct);
                          

                          //  showAlertDialog(context); 
                          },
                           child: Icon(Icons.delete,color:Colors.white))
                        ],),
                        
                      ],),
                      Text("\$${appProvider.IndividualPrice(widget.singleProduct).toString()}" ,style:GoogleFonts.lato(
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