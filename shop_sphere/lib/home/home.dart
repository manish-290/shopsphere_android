

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/catagory_view/category_view.dart';
import 'package:shop_sphere/firebase_helper/firestore_helper.dart';
import 'package:shop_sphere/main.dart';
import 'package:shop_sphere/model/category_model.dart';
import 'package:shop_sphere/product_details/product_details.dart';
import 'package:shop_sphere/provider/app_provider.dart';
import '../model/product_model/product_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    FocusNode searchFocusNode = FocusNode();
  List<CategoryModel> categoriesList = [];
  List<ProductModel> bestProductsList = [];
  bool isLoading = false;
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfo();
    getCategoryList();
    FirebaseFirestoreHelper.instance.updateTokenFromFirebase(appProvider.getUserId);

    // getBestProductsList();
    super.initState();
  }

  void getCategoryList() async {
    setState(() {
      isLoading = true;
    });
    categoriesList = await FirebaseFirestoreHelper.instance.getCategories();
    bestProductsList = await FirebaseFirestoreHelper.instance.getBestProducts();
    bestProductsList.shuffle();

    setState(() {
      isLoading = false;
    });
  }

  TextEditingController search = TextEditingController();
  List<ProductModel> searchList =[];

  void searchProduct( String value){
    searchList = bestProductsList.where((element) => 
    element.name.toLowerCase().contains(value.toLowerCase())).toList();
    setState(() {
    });
    
  }

  @override
  Widget build(BuildContext context) {
    PaintingBinding.instance.imageCache.clear();

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 11, 62, 103),
            title: const Text(' ShopSphere Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white)),
            leading: const Icon(Icons.shopify_sharp,color:Colors.white),
        
          ),
          body: isLoading
              ? Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                             
                              enableSuggestions: false,
                            controller: search,
                            onChanged: (value){
                              searchProduct(value);
                            },
                              decoration: InputDecoration(
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  icon: Icon(Icons.search),
                                  hintText: 'Search products',
                                  hintStyle: const TextStyle(color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide:
                                          BorderSide(color: Colors.blue)))),
                        ),
                      const  SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                'Catagories',
                                style: GoogleFonts.lato(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            categoriesList.isEmpty
                                ? Center(
                                    child: Text("Categories list is empty"),
                                  )
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: categoriesList
                                          .map(
                                            (e) => Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CategoryView(
                                                                categoryModel:
                                                                    e,
                                                              )));
                                                },
                                                child: Card(
                                                    color: Colors.white,
                                                    elevation: 15.0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: SizedBox(
                                                      width: 100,
                                                      height: 100,
                                                      child: Image.network(
                                                          e.image),
                                                    )),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                            SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text('Best Products',
                                  style: GoogleFonts.lato(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            search.text.isNotEmpty && searchList.isEmpty?Center(
                              child:Text("Product not found")
                            ):searchList.isNotEmpty?
                            Padding(
                              padding: const EdgeInsets.only(bottom:30.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: GridView.builder(
                                  physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: (searchList.isNotEmpty)
                                    ?searchList.length:bestProductsList.length,
                                    gridDelegate:
                                      const  SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisSpacing: 20,
                                            crossAxisSpacing: 20,
                                            childAspectRatio: 1.0,
                                            crossAxisCount: 2),
                                    itemBuilder: (context, index) {
                                      ProductModel singleProduct =
                                          searchList[index];
                                                          
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color:
                                              Colors.blue.withOpacity(0.3),
                                        ),
                                        height: 70,
                                        width: 60,
                                        child: Column(
                                          children: [
                                            SizedBox(height: 10),
                                            Image.network(
                                                singleProduct.image,
                                                scale: 17.5),
                                            SizedBox(height: 12.0),
                                            Text(singleProduct.name,
                                                style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(height: 7),
                                            Text(
                                                "Price: ${singleProduct.price}",
                                                style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontSize: 8,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(height: 10),
                                            OutlinedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetails(
                                                                singleProduct:
                                                                    singleProduct,
                                                              )));
                                                },
                                                style: OutlinedButton
                                                    .styleFrom(
                                                        side:const BorderSide(
                                                            color: Colors
                                                                .blue)),
                                                child: Text('Buy',
                                                    style:
                                                        GoogleFonts.lato(
                                                            color:
                                                                Colors.blue[
                                                                    900],
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)))
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            )
                            //rest of the code
                            :bestProductsList.isEmpty
                                ? const Center(
                                    child: Text("Products list is empty."),
                                  )
                                : SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: GridView.builder(
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: bestProductsList.length,
                                        gridDelegate:
                                           const SliverGridDelegateWithFixedCrossAxisCount(
                                                mainAxisSpacing: 20,
                                                crossAxisSpacing: 20,
                                                childAspectRatio: 0.85,
                                                crossAxisCount: 2),
                                        itemBuilder: (context, index) {
                                          ProductModel singleProduct =
                                              bestProductsList[index];

                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color:
                                                  Colors.blue.withOpacity(0.3),
                                            ),
                                            height: 70,
                                            width: 60,
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Image.network(
                                                    singleProduct.image,
                                                    scale: 17.5),
                                                SizedBox(height: 12.0),
                                                Text(singleProduct.name,
                                                    style: GoogleFonts.lato(
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(height: 7),
                                                Text(
                                                    "Price: ${singleProduct.price}",
                                                    style: GoogleFonts.lato(
                                                        color: Colors.black,
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(height: 10),
                                                OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProductDetails(
                                                                    singleProduct:
                                                                        singleProduct,
                                                                  )));
                                                    },
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .blue)),
                                                    child: Text('Buy',
                                                        style:
                                                            GoogleFonts.lato(
                                                                color:
                                                                    Colors.blue[
                                                                        900],
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)))
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                               const SizedBox(height: 60,),

                          ],
                        )
                      ],
                    ),
                  ),
                )),
    );
  }
}
