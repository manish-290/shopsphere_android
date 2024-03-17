import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/Account_screen/edit_profile.dart';
import 'package:shop_sphere/Account_screen/order_screen.dart';
import 'package:shop_sphere/Account_screen/password_change.dart';
import 'package:shop_sphere/Account_screen/support_tabs/Aboutus.dart';
import 'package:shop_sphere/Account_screen/support_tabs/support.dart';
import 'package:shop_sphere/favourite-screen/favourite_screen.dart';
import 'package:shop_sphere/firebase_helper/firebase_auth.dart';
import 'package:shop_sphere/main.dart';
import 'package:shop_sphere/provider/app_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
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
          title: Text("User Profile",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: 
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Expanded(
                  
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                    appProvider.getUserInformation.image == null
                        ? const CircleAvatar(
                            radius: 43,
                            child: Icon(
                              Icons.person,
                              size: 80,
                            ),
                          )
                        : CircleAvatar(
                            radius: 43,
                            backgroundImage: NetworkImage(
                                appProvider.getUserInformation.image!),
                          ),
                    Text(appProvider.getUserInformation.name,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                   const Gutter(),
                    Text(
                      appProvider.getUserInformation.email,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                            
                    ElevatedButton(
                        style:  ElevatedButton.styleFrom(
                          primary: Colors.pink,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()));
                        },
                        child: const Text("EDIT",style:TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold
                        )))
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                      ListTile(
                        onTap: () {
                           Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderScreen()));
                        },
                        leading: Icon(Icons.shopping_bag),
                        title: Text("Yours orders"),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavouriteScreen()));
                        },
                        leading: Icon(Icons.favorite),
                        title: Text("Favorite Product"),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePassword()));
                        },
                        leading: Icon(Icons.change_circle_outlined),
                        title: Text("Change Password"),
                      ),
                      ListTile(
                        onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerSupport()));
                        },
                        leading: Icon(Icons.support),
                        title: Text("Support"),
                      ),
                      ListTile(
                        onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutUs()));
                        },
                        leading: Icon(Icons.info),
                        title: Text("About us"),
                      ),
                       
                      ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(
                                        "Are you sure want to logout?",
                                        style: GoogleFonts.lato(
                                            color: const Color.fromARGB(
                                                255, 4, 55, 98),
                                            fontWeight: FontWeight.bold)),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.green),
                                            onPressed: () {
                                              FirebaseAuthHelper.instance
                                                  .signout();
                                              Navigator.of(context).pop();
                                              setState(() {});
                              
                                              Navigator.push(context, MaterialPageRoute(
                                                builder: (context)=>WelcomePage()));
                                            },
                                            child: Text("Proceed",
                                                style: TextStyle(
                                                  color:Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.red),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Cancel",
                                                  style: TextStyle(
                                                    color:Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ),
                                      ],
                                    ),
                                  ));
                        },
                        leading: Icon(Icons.logout),
                        title: Text("Logout"),
                      ),
                      SizedBox(height: 15),
                      Text("Version: 1.1.2",
                          style: GoogleFonts.abel(
                            color: Colors.grey,
                          )),
                          SizedBox(height: 100,)
                        ],
                      ),
                    ))
              ],
            ),
          ),
        );
  }
}
