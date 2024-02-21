import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/cart_screen/cartItemCheckout/cart_item_checkout.dart';
import 'package:shop_sphere/cart_screen/single_cart_item.dart';
import 'package:shop_sphere/provider/app_provider.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void showSnackBar(BuildContext context, String message) {
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.white,
          content: Text(message,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ))));
    });
  }

  double counter = 1;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: true);
    // appProvider.getUserInfo();
    return Scaffold(
        bottomNavigationBar: SizedBox(
          height: 150,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total",
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("\$${appProvider.totalPrice().toString()}",
                        style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 5, 62, 108))),
                  ],
                ),
              const  SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    appProvider.clearBuyProducts();
                    appProvider.addBuyProductsCartList();

                    if (appProvider.getCartProductList.isEmpty) {
                      showSnackBar(context, "Cart is empty");
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => cartItemCheckout()));
                    }
                    appProvider.clearCartList();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(255, 1, 64, 115),
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Checkout",
                            style: GoogleFonts.lato(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              const  SizedBox(height:20),
              ],
            ),
          ),
        ),
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 2, 35, 62),
            centerTitle: true,
            title: Text('My Cart',
                style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
        body: appProvider.getCartProductList.isEmpty
            ? const Center(child: Text("The Cart is Empty",style:TextStyle(
                fontWeight: FontWeight.bold

            )))
            : ListView.builder(
                itemCount: appProvider.getCartProductList.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  return SingleCartItem(
                    singleProduct: appProvider.getCartProductList[index],
                  );
                }));
  }
}
