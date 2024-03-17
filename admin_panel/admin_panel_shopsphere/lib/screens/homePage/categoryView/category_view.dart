import 'package:admin_panel_shopsphere/helpers/firestore_helper.dart';
import 'package:admin_panel_shopsphere/models/category_model.dart';
import 'package:admin_panel_shopsphere/models/userModel/user_model.dart';
import 'package:admin_panel_shopsphere/screens/homePage/categoryView/addCategory/add_category.dart';
import 'package:admin_panel_shopsphere/screens/homePage/categoryView/singleCategory/single_category_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../provider/app_provider.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  void showSnackBar(BuildContext context, String message) {
    SnackBar(content: Text(message));
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>AddCategory()));
              },
               icon: Icon(Icons.add_circle,color:Colors.white))
          ],
          title: Text('Category View',style:TextStyle(color:Colors.white)),
          centerTitle: true,
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
        body: Consumer<AppProvider>(builder: (context, value, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Text("Categories",
                    style: GoogleFonts.lato(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 7, 65, 113))),
                SizedBox(height: 20),
                GridView.builder(
                  physics:ScrollPhysics() ,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    padding: EdgeInsets.only(top: 10),
                    itemCount: appProvider.getCategoriesList.length,
                    itemBuilder: (context, index) {
                      CategoryModel categoryModel =
                          value.getCategoriesList[index];
                      return SingleCategoryItem(categoryModel: categoryModel,index: index,);

                    }),
              ],
            ),
          );
        }));
  }
}
