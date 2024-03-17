// import 'dart:io';
//
// import 'package:admin_panel_shopsphere/screens/homePage/home_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gutter/flutter_gutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
//
// import '../models/userModel/user_model.dart';
// import '../provider/app_provider.dart';
//
//
// class EditProfile extends StatefulWidget {
//   const EditProfile({super.key});
//
//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }
//
// class _EditProfileState extends State<EditProfile> {
//   //file is defined in both html and io package so avoid conflict
//   File? image;
//   void takePicture() async {
//     XFile? value = await ImagePicker()
//         .pickImage(source: ImageSource.gallery, imageQuality: 40);
//     if (value != null) {
//       setState(() {
//         image = File(value.path);
//       });
//     }
//   }
//   TextEditingController textEditingController= TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);
//     appProvider.getUserInfo();
//     return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text("Edit Profile",
//               style:
//               TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//         ),
//         body: ListView(
//           padding: EdgeInsets.only(left: 80, right: 80),
//           children: [
//             Gutter(),
//             image==null?GestureDetector(
//                 onTap: takePicture,
//                 child:
//                 CircleAvatar(
//                     radius:43,
//                     child: Icon(Icons.camera_alt)
//                 )
//             )
//                 :GestureDetector(
//                 onTap: takePicture,
//                 child:
//                 CircleAvatar(
//                     radius:43,
//                     backgroundImage: FileImage(image!)
//                 )),
//             Gutter(),
//             Gutter(),
//             TextFormField(
//               controller: textEditingController,
//               validator: (value)=>value!.isEmpty?"Enter the name":null,
//               decoration: InputDecoration(
//                   hintText: "e.g. ${appProvider.getUserInformation.name}",
//                   enabledBorder: OutlineInputBorder(
//                       borderSide:
//                       BorderSide(color: Colors.grey[400]!, width: 1))),
//             ),
//             Gutter(),
//             Gutter(),
//             ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   primary: Color.fromARGB(255, 247, 8, 8),
//                 ),
//                 onPressed: () async {
//                   UserModel userModel = await appProvider.getUserInformation.copyWith(
//                       name: textEditingController.text
//                   );
//                   appProvider.updateUserInfo(
//                       context,
//                       userModel,
//                       image);
//
//                   Future.delayed(Duration(seconds: 3),(){
//                     Navigator.push(context, MaterialPageRoute(
//                         builder: (context)=>HomePageAdmin()));
//                   });
//
//                 },
//                 child: Text("Update",
//                     style: GoogleFonts.lato(
//                         color:Colors.white,
//                         fontWeight: FontWeight.bold, fontSize: 14)))
//           ],
//         ));
//   }
// }
