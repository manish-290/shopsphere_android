import 'dart:io';

import 'package:admin_panel_shopsphere/helpers/firebase_storage.dart';
import 'package:admin_panel_shopsphere/models/category_model.dart';
import 'package:admin_panel_shopsphere/provider/app_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../models/product_model/product_model.dart';

class AddProduct extends StatefulWidget {
  
  
   AddProduct({super.key, });

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File? image;
  void takePicture() async{
    XFile? value = await ImagePicker().pickImage(
      source:ImageSource.gallery,imageQuality:40);
    if(value!=null){
      setState(() {
        image= File(value.path);
      });
    }
  }
  TextEditingController name= TextEditingController();
  TextEditingController description= TextEditingController();
  TextEditingController price= TextEditingController();
    TextEditingController status= TextEditingController();


  void showSnackBar(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

CategoryModel? _selectedCategory;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider= Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:Text("Product Add",style:TextStyle(color:Colors.white)),
        centerTitle:true,
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
      ),
      body:ListView(
        padding:EdgeInsets.symmetric(horizontal: 20,vertical:10),
        children: [
          image==null?GestureDetector(
            onTap: takePicture,
            child: CircleAvatar(
              radius:55,
              child:Icon(Icons.camera_alt)
            ),
          )
            :GestureDetector(
              onTap: takePicture,
              child: CircleAvatar(
                radius:55,
                child:Image.file(image!)
              ),
            ),
            SizedBox(height: 15,),
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(),
                hintText: "Product Name"
              ),
            ),
              SizedBox(height: 15,),
               TextFormField(
                maxLines: 5,
              controller: description,
              decoration: InputDecoration(
                 enabledBorder: OutlineInputBorder(),
                hintText: "Description.."
              ),
            ),
              SizedBox(height: 15,),
               TextFormField(
              controller: price,
              decoration: InputDecoration(
                 enabledBorder: OutlineInputBorder(),
                hintText: "\$price"
              ),
            ),
              SizedBox(height: 15,),

              //dropdown button for category
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.blue.withOpacity(0.2)
                ),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                  ),
                      value: _selectedCategory,
                      hint: Text(
                 'Please select a catagory',
                  ),
                      isExpanded: true,
                      onChanged: (value) {
                   setState(() {
                      _selectedCategory = value;
                   });
                 },
                     
                      items: appProvider.getCategoriesList
                         .map((CategoryModel val) {
                  return DropdownMenuItem(
                     value: val,
                     child: Text(
                       val.name , 
                       style:GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        color:Colors.black
                       )                  
                           ),
                         );
                      }).toList(),
                   ),
              ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red
              ),
              onPressed:() async{
                if(image==null ||_selectedCategory==null ||name.text.isEmpty || description.text.isEmpty || price.text.isEmpty){
                  Navigator.of(context).pop();
                  showSnackBar(context," Fill out all the fields!");
                }else{
                //  String? imageUrl= await FirebaseStorageHelper.instance
                //  .uploadCategoryFiles(widget.productModel., image!);
                  appProvider.addProduct(
                   image!,
                    name.text, description.text, price.text, 
                    _selectedCategory!.id,status.text);
                 showSnackBar(context," Successfully Added");
                }
              } , 
              child: Text("Add",
              style:GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color:Colors.white,
                fontSize: 20
              )))
        ],
      )
    );
  }
}