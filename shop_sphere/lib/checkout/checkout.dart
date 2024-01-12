import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:shop_sphere/firebase_helper/firestore_helper.dart';
import 'package:shop_sphere/provider/app_provider.dart';
import 'package:shop_sphere/stripe_payment/stripe_payment.dart';

import '../model/product_model/product_model.dart';

class Checkout extends StatefulWidget {
  final ProductModel singleProduct;
  Checkout({super.key, required this.singleProduct});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String selectedValue = 'Cash on Delivery';
  bool isLoading = false;
  String groupValue = 'Cash on Delivery';

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text(message, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Checkout",
            style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(255, 5, 53, 93),
                        width: 3,
                      )),
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                            activeColor: Color.fromARGB(255, 124, 5, 243),
                            value: "Cash on Delivery",
                            title: Text('Cash on Delivery',
                                style: GoogleFonts.lato(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            groupValue: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value as String;
                              });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.money),
                      ),
                    ],
                  )),
              SizedBox(
                height: 36,
              ),
              Container(
                child:  Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                          activeColor: Color.fromARGB(255, 124, 5, 243),
                          value: "Pay Online",
                          title: GestureDetector(
                            onTap: () {
                              setState(() {
                                // isLoading=true;
                                selectedValue = "Pay Online";
                              });
                              // showPaymentOptions(context);
                            },
                            child: Text('Pay Online',
                                style: GoogleFonts.lato(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                          groupValue: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                            });
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.mobile_friendly),
                    )
                  ],
                ),
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromARGB(255, 5, 53, 93),
                      width: 3,
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 2, 52, 92),
                    shadowColor: Colors.blue,
                    elevation: 15,
                  ),
                  onPressed: () async {
                    if (selectedValue == "Cash on Delivery") {
                      appProvider.addBuyProducts(widget.singleProduct);
                      bool value = await FirebaseFirestoreHelper.instance
                          .uploadOrderedproducts(appProvider.getBuyProductsList,
                              context, "Cash on Delivery");

                      showSnackBar(context, "Order placed successfully");
                      appProvider.clearBuyProducts();

                      if (value) {
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomBottomBar()));
                        });
                      }
                    } else {
                      
                      try{
                      appProvider.addBuyProducts(widget.singleProduct);
                       int value= double.parse(appProvider.totalPriceBuyProductsList().toString()).round().toInt();
                          String totalprice =( value * 100).toString();
                          // print(totalprice);
                  bool isPaymentSuccessful=   await StripeHelper.instance
                          .makePayment(totalprice.toString(),context);
                          print("this is paid online");
                      
                       if(isPaymentSuccessful){
                          await FirebaseFirestoreHelper.instance
                            .uploadOrderedproducts(
                                appProvider.getBuyProductsList,
                                context,
                                "Pay Online");

                       appProvider.clearBuyProducts();
                       }

                        
                      
                      }catch(e){
                        print("error :${e}");
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Proceed",
                      style: GoogleFonts.lato(
                        color:Colors.white,
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ))
            ],
          ),
        ));
  }
}
