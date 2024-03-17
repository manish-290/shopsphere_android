import 'package:admin_panel_shopsphere/helpers/firestore_helper.dart';
import 'package:admin_panel_shopsphere/models/userModel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../provider/app_provider.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
 void showSnackBar(BuildContext context,String message){
  SnackBar(content: Text(message));
}

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider= Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('User View',style:TextStyle(color:Colors.white)),
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
      body:Consumer<AppProvider>(
        // child: appProvider.getUserList.length,
        builder: (context,value,child){
          return ListView.builder(
            padding: EdgeInsets.only(top:10),
            itemCount: appProvider.getUserList.length,
            itemBuilder: (context,index){
              UserModel userModel = value.getUserList[index];
              return SizedBox(
                height: 85,
                child: Card(
                  
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    userModel.image!=null?CircleAvatar(
                      radius:30,
                      backgroundImage: NetworkImage(
                        userModel.image!,
                        ))
                    :CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person)),
                    Padding(
                      padding: const EdgeInsets.only(top:8,left:18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userModel.name,
                          style:GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                          Text(userModel.email)
                        ],
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async{
                      await value.deleteUserFromFirebase(userModel);
                      showSnackBar(context,"Removed successfully");
                    }, 
                    icon: Icon(Icons.delete,color:const Color.fromARGB(255, 232, 28, 13)))
                  ]),
                ),
              );
            });
        })
    );
  }
}