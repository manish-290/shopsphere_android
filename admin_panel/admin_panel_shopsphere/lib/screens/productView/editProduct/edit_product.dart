import 'dart:io';

import 'package:admin_panel_shopsphere/helpers/firebase_storage.dart';
import 'package:admin_panel_shopsphere/models/category_model.dart';
import 'package:admin_panel_shopsphere/models/product_model/product_model.dart';
import 'package:admin_panel_shopsphere/provider/app_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {

  final ProductModel productModel;
  final int index;
   EditProduct({super.key,
  required this.productModel,
  required this.index,
  });

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
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



  void showSnackBar(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider= Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:Text("Product edit",style:TextStyle(color:Colors.white)),
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
          image==null? widget.productModel.image.isNotEmpty?  GestureDetector(
            onTap: takePicture,
            child: CircleAvatar(
              radius:55,
              child:Image.network(widget.productModel.image,
              fit: BoxFit.cover,)
              // backgroundImage: NetworkImage(widget.productModel.image),
            ),
          )
          : GestureDetector(
            onTap: takePicture,
            child: CircleAvatar(
              radius:55,
              child:Icon(Icons.camera_alt)
            ),
          )
      :GestureDetector(
              onTap:takePicture,
              child: CircleAvatar(
                radius:55,
               child:Image.file(image!,
               fit:BoxFit.cover)
                // child:Image.network(widget.productModel.image)
              ),
            ),
            SizedBox(height: 15,),
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                hintText: widget.productModel.name,
                enabledBorder: OutlineInputBorder(),
                hintStyle: TextStyle(color:Colors.grey[400]),
              ),
            ),
              SizedBox(height: 15,),
              TextFormField(
              controller: description,
              
              maxLines: 3,
              decoration: InputDecoration(
                hintStyle: TextStyle(color:Colors.grey[400]),
                enabledBorder: OutlineInputBorder(),
                hintText: widget.productModel.description
              ),
            ),
              SizedBox(height: 15,),
              TextFormField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(),
                hintStyle: TextStyle(color:Colors.grey[400]),
                hintText: "\$${widget.productModel.price.toString()}"
              ),
            ),
              SizedBox(height: 15,),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red
              ),
              onPressed:() async{
                if(image==null && name.text.isEmpty && description.text.isEmpty && price.text.isEmpty){
                  Navigator.of(context).pop();
                }else if(image != null){
                  String? imageUrl =
                   await FirebaseStorageHelper.instance.uploadCategoryFiles(
                    widget.productModel.id,image!);
                   ProductModel productModel= widget.productModel.copyWith(
                    description:description.text.isEmpty?null:description.text,
                    name:name.text.isEmpty?null:name.text,
                    price:price.text.isEmpty?null:price.text,
                    image:imageUrl
                   
                   );
                  appProvider.updateProductList(context,widget.index, productModel);
                  showSnackBar(context,"Updated Successfully");
                }else{
                   ProductModel productModel= widget.productModel.copyWith(
                     description:description.text.isEmpty?null:description.text,
                    name:name.text.isEmpty?null:name.text,
                    price:price.text.isEmpty?null:price.text,
                   );
                  appProvider.updateProductList(context,widget.index, productModel);
                  showSnackBar(context,"Updated Successfully");
                }
              } , 
              child: Text("Update",
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