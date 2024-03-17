import 'dart:io';

import 'package:admin_panel_shopsphere/helpers/firebase_storage.dart';
import 'package:admin_panel_shopsphere/models/category_model.dart';
import 'package:admin_panel_shopsphere/provider/app_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddCategory extends StatefulWidget {
  
   AddCategory({super.key });

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
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

  void showSnackBar(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider= Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:Text("Category Add",style:TextStyle(color:Colors.white)),
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
          image==null?MaterialButton(
            child:CircleAvatar(
              radius:55,
              child:Icon(Icons.camera_alt)
            ) ,
            onPressed: (){
              takePicture();
            })
            :MaterialButton(
            child:CircleAvatar(
              radius:55,
              backgroundImage: FileImage(image!),
            ) ,
            onPressed: (){
              takePicture();
            }),
            SizedBox(height: 15,),
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                hintText: "Category Name"
              ),
            ),
              SizedBox(height: 15,),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red
              ),
              onPressed:() async{
                if(image==null && name.text.isEmpty){
                  Navigator.of(context).pop();
                }else if(image != null && name.text.isNotEmpty){
                 
                  appProvider.addCategory(image!, name.text);
                  showSnackBar(context," Successfully Added");
                }
              } , 
              child: Text("Add",
              style:GoogleFonts.lato(
                color:Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20
              )))
        ],
      )
    );
  }
}