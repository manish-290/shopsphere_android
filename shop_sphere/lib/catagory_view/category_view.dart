import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_sphere/model/product_model/product_model.dart';

import '../firebase_helper/firestore_helper.dart';
import '../model/category_model.dart';
import '../product_details/product_details.dart';

class CategoryView extends StatefulWidget {
  final CategoryModel categoryModel;
  const CategoryView({super.key,required this.categoryModel});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {

List<ProductModel> bestProductsList = [];
bool isLoading = false;

void getCategoryList() async{
  setState(() {
    isLoading = true;
  });
  bestProductsList= await FirebaseFirestoreHelper.instance.getCategoryViewProducts(widget.categoryModel.id);
  bestProductsList.shuffle();
  setState(() {
    isLoading = false;
  });
}
@override
void initState(){
  super.initState();
  getCategoryList();
}

  @override
  Widget build(BuildContext context) {
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
        title:Text('Category',style:TextStyle(color:Colors.white))
      ),
      body:  isLoading ? Center(
          child: Container(
            height:100,
            width: 100,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        )
        
        //if false
        :  SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(widget.categoryModel.name,style:GoogleFonts.lato(
                    color:const Color.fromARGB(255, 3, 53, 94),
                    fontWeight: FontWeight.bold,
                    fontSize: 28
                  )),
                ),
              ),
              bestProductsList.isEmpty ?Center(
                            child: Text("Products list is empty."),
                          )
        
                         :SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                           child: GridView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap:true,
                            itemCount:bestProductsList.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              childAspectRatio: 0.9,
                              crossAxisCount: 2),
                             itemBuilder: (context,index){
                              ProductModel singleProduct = bestProductsList[index];
                              
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blue.withOpacity(0.3),
                                  ),
                                  
                                  
                                  // height: 70,
                                  // width:60,
                                  child: Column(
                                    children: [
                                    SizedBox(height:10),
                                    Image.network(singleProduct.image,scale:17.5),
                                    SizedBox(height:12.0),
                                    Text(singleProduct.name,
                                    style:GoogleFonts.lato(
                                      color:Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold
                                    )),
                                    SizedBox(height:7),
                                    Text("Price: ${singleProduct.price}",
                                    style:GoogleFonts.lato(
                                      color: Colors.black,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold
                                    )
                                    ),
                                    SizedBox(height:10),
                                    OutlinedButton(
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context)=>ProductDetails(singleProduct:singleProduct ,)));
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color:Colors.blue)
                                      ),
                                       child: Text('Buy',
                                       style:GoogleFonts.lato(
                                        
                                        color: Colors.blue[900],
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold
                                       )))
                                      
                                  ],),
                                ),
                                 
                              );
                             }),
                               
                         ),
                         const SizedBox(height: 60,),
            ],
            
          ),
        )
      
    );
  }
}