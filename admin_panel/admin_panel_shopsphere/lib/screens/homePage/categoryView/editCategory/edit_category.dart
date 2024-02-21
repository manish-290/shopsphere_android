import 'dart:io';

import 'package:admin_panel_shopsphere/helpers/firebase_storage.dart';
import 'package:admin_panel_shopsphere/models/category_model.dart';
import 'package:admin_panel_shopsphere/provider/app_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditCategory extends StatefulWidget {

  final CategoryModel categoryModel;
  final int index;
   EditCategory({super.key,
  required this.categoryModel,
  required this.index,
  });

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
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
        title:Text("Category edit",style:GoogleFonts.lato(
          color:Colors.white,
          fontWeight: FontWeight.bold
        )),
        centerTitle:true,
        backgroundColor: const Color.fromARGB(255, 3, 51, 91),
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
                child:Image.file(image!),
              ),
            ),
            SizedBox(height: 15,),
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                hintText: widget.categoryModel.name
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
                }else if(image != null){
                  String? imageUrl =
                   await FirebaseStorageHelper.instance.uploadCategoryFiles(
                    widget.categoryModel.id,image!);
                   CategoryModel categoryModel= widget.categoryModel.copyWith(
                     name: name.text.isEmpty?null:name.text,
                     image: imageUrl,
                   );
                  appProvider.updateCategoryList(context,widget.index, categoryModel);
                  showSnackBar(context,"Updated Successfully");
                }else{
                   CategoryModel categoryModel= widget.categoryModel.copyWith(
                     name: name.text.isEmpty?null:name.text,
                   );
                  appProvider.updateCategoryList(context,widget.index, categoryModel);
                  showSnackBar(context,"Updated Successfully");
                }
              } , 
              child: Text("Update",
              style:GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white
              )))
        ],
      )
    );
  }
}