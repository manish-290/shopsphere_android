import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/Account_screen/order_screen.dart';
import 'package:shop_sphere/checkout/checkout.dart';
import 'package:shop_sphere/cart_screen/cart_screen.dart';
import 'package:shop_sphere/favourite-screen/favourite_screen.dart';
import 'package:shop_sphere/model/product_model/product_model.dart';
import 'package:shop_sphere/provider/app_provider.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel singleProduct;
  const ProductDetails({super.key,required this.singleProduct});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  double counter =1;
  bool isLoading = false;
  


void _showAlertDialog(BuildContext context) {

  setState(() {
    showDialog(
    barrierColor: Colors.transparent,
    context: context,
    builder: (context) => AlertDialog(
      elevation: 10,
      icon: Icon(Icons.check_box, color: Color.fromARGB(255, 4, 163, 10)),
      backgroundColor: Color.fromARGB(110, 97, 164, 215),
      title: Text(
        'Added to Cart',
        style: GoogleFonts.lato(
          color: const Color.fromARGB(255, 2, 56, 100),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
  });

  // This Future.delayed should be inside the showDialog builder callback
  Future.delayed(Duration(seconds: 1),(){
           Navigator.of(context,rootNavigator: true).pop();
    });
}


  @override
  Widget build(BuildContext context) {
      AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Color.fromARGB(255, 2, 35, 62),
        elevation: 0.0,
        iconTheme: IconThemeData(color:Colors.white),
        title:Text("Product Details",style:TextStyle(
          fontWeight: FontWeight.bold,color: Colors.white
        ))
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Center(child: Container(
              color: const Color.fromARGB(255, 213, 233, 249),
              child: Padding(
              padding: const EdgeInsets.symmetric(vertical:35.0),
              child: Image.network(
                widget.singleProduct.image,
                height:200,
                width: 500,
                ),
                
            ),
            )),
            SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(widget.singleProduct.name,
                    style:GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Color.fromARGB(255, 2, 56, 100)
                    )),
                    Padding(
                      padding: const EdgeInsets.only(left:14.0,top:8),
                      child: Text(("\$${widget.singleProduct.price}") as String ,style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green
                      ),),
                    )
                  ],
                ),
              IconButton(
                onPressed: (){
                 
                  //  widget.singleProduct.isFavourite = false;
                  setState(() {
                    //for toggle
                    
                   widget.singleProduct.isFavourite = !widget.singleProduct.isFavourite;
                    print(widget.singleProduct.isFavourite);
                   if(widget.singleProduct.isFavourite){
                   
                    appProvider.addFavouriteProduct(widget.singleProduct);   
                  }else{
                    appProvider.removeFavouriteProduct(widget.singleProduct);
                  }
                  });
                  
                },
                 icon:Icon(appProvider.getFavouriteProductList.contains(widget.singleProduct)? Icons.favorite:Icons.favorite_border,
                              color:appProvider.getFavouriteProductList.contains(widget.singleProduct) ?Colors.red:Colors.black,
                                ),

                 
                  ),
              ],
            ),
            SizedBox(height:12 ,),
            Text(widget.singleProduct.description,style:GoogleFonts.lato(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold
      
            )),
            SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               ElevatedButton(
                style:ElevatedButton.styleFrom(
                 shape:CircleBorder(),
                  fixedSize: Size(7,3),
                  primary: Colors.pink
                ),
                onPressed: (){
                setState(() {
                  if(counter>0){
                      counter--;
                  }
                
                });
               }, child: Icon(Icons.remove,color:Colors.white)),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal:12.0),
                 child: Text('$counter',style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:const Color.fromARGB(255, 2, 40, 72))),
               ),
            ElevatedButton(
              style:ElevatedButton.styleFrom(
                  shape:CircleBorder(),
                  fixedSize: Size(7,3),
                  primary: Colors.pink
                ),
              onPressed: (){
              setState(() {
                counter++;
              });
            }, child: Icon(Icons.add,color:Colors.white))
            ],),
            SizedBox(height:28,),
            Row(
             mainAxisAlignment: MainAxisAlignment.center,
              children: [
             OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color.fromARGB(255, 2, 35, 62)),
                primary: Color.fromARGB(255, 2, 35, 62)
              ),
              onPressed: (){
              AppProvider appProvider = Provider.of<AppProvider>(context,listen: false);
              ProductModel productModel = widget.singleProduct.copyWith(counter:counter );
                appProvider.addCartProduct(productModel);
               
                  _showAlertDialog(context);

              }, 
              child: Text('ADD TO CART')),
      
              SizedBox(width:18),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 2, 35, 62)
                  ),
                  onPressed: (){
                  ProductModel productModel = widget.singleProduct.copyWith(counter: counter);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>Checkout(singleProduct: productModel,)));
                  }, child: Text('BUY',style:TextStyle(
                    color:Colors.white
                  ))),
              )
              
            ],),
            const SizedBox(height: 50,)
           
            
          ],),
        ),
      ),
    );
  }
}