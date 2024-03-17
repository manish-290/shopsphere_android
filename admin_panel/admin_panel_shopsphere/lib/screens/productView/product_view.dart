import 'package:admin_panel_shopsphere/provider/app_provider.dart';
import 'package:admin_panel_shopsphere/screens/productView/addProduct/add_product.dart';
import 'package:admin_panel_shopsphere/screens/productView/single_product_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/product_model/product_model.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider= Provider.of<AppProvider>(context);
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
        title: Text('Product View',style: GoogleFonts.poppins(
          color:Colors.white
        ),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context)=>AddProduct()));
            },
             icon: Icon(Icons.add_circle,color:Colors.white))
        ],
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: appProvider.getProductsList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.85,
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              ProductModel singleProduct = appProvider.getProductsList[index];
      
              return SingleProductView(singleProduct: singleProduct,index:index);
            }),
      ),
    );
  }
}
