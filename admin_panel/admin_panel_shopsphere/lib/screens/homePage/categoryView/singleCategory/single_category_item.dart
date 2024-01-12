import 'package:admin_panel_shopsphere/models/category_model.dart';
import 'package:admin_panel_shopsphere/provider/app_provider.dart';
import 'package:admin_panel_shopsphere/screens/homePage/categoryView/editCategory/edit_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleCategoryItem extends StatefulWidget {
  final CategoryModel categoryModel;
  final int index;
  const SingleCategoryItem(
      {super.key, required this.categoryModel, required this.index});

  @override
  State<SingleCategoryItem> createState() => _SingleCategoryItemState();
}

class _SingleCategoryItemState extends State<SingleCategoryItem> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Card(
        color: Colors.white,
        elevation: 15.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                child: Image.network(
                  widget.categoryModel.image,
                  scale: 5,
                ),
              ),
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
                              .deleteCategoryFromFirebase(widget.categoryModel);
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
                                  builder: (context) => EditCategory(
                                      categoryModel: widget.categoryModel,
                                      index: widget.index)));
                        },
                        child: Icon(Icons.edit,
                            color: const Color.fromARGB(255, 3, 28, 49)))
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
