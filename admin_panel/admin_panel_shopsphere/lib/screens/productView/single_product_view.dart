import 'package:admin_panel_shopsphere/models/category_model.dart';
import 'package:admin_panel_shopsphere/provider/app_provider.dart';
import 'package:admin_panel_shopsphere/screens/productView/editProduct/edit_product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/product_model/product_model.dart';

class SingleProductView extends StatefulWidget {
  final ProductModel singleProduct;
  final int index;
   SingleProductView({super.key,
   required this.index,
   required this.singleProduct});

  @override
  State<SingleProductView> createState() => _SingleProductViewState();
}

class _SingleProductViewState extends State<SingleProductView> {
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue.withOpacity(0.3),
                ),
                height: 70,
                width: 60,
                child: Stack(
                  children: [
                     Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Image.network(widget.singleProduct.image, scale: 12),
                      SizedBox(height: 12.0),
                      Text(widget.singleProduct.name,
                          style: GoogleFonts.lato(
                              color: const Color.fromARGB(255, 1, 43, 78),
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 7),
                      Text("Price: \$${widget.singleProduct.price}",
                          style: GoogleFonts.lato(
                              color: Colors.black,
                              fontSize: 8,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      
                    ],
                  ),
                   Positioned(
              right: 0.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await appProvider
                              .deleteProductFromFirebase(widget.singleProduct);
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Icon(Icons.delete, color: Colors.red)),
                    const SizedBox(width: 10),
                    GestureDetector(
                        onTap: () {
                          Navigator.push( 
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProduct(
                                      productModel: widget.singleProduct,
                                      index:widget.index)));
                        },
                        child: Icon(Icons.edit,
                            color: const Color.fromARGB(255, 3, 28, 49)))
                  ],
                ),
              ),
            )
                  ],
                ),
              );
  }
}