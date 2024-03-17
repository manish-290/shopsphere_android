import 'dart:io';

import 'package:admin_panel_shopsphere/Account%20Screen/Aboutus.dart';
import 'package:admin_panel_shopsphere/Account%20Screen/edit_account.dart';
import 'package:admin_panel_shopsphere/authentication%20page/admin-signup.dart';
import 'package:admin_panel_shopsphere/provider/app_provider.dart';
import 'package:admin_panel_shopsphere/screens/homePage/categoryView/category_view.dart';
import 'package:admin_panel_shopsphere/screens/homePage/single_dashboard_item.dart';
import 'package:admin_panel_shopsphere/screens/homePage/userView/user_view.dart';
import 'package:admin_panel_shopsphere/screens/notificationScreen/notification_screen.dart';
import 'package:admin_panel_shopsphere/screens/orderList/order_list.dart';
import 'package:admin_panel_shopsphere/splash-screen/splash-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../authentication page/admin-login.dart';
import '../../helpers/firebase-auth.dart';
import '../productView/product_view.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  bool isLoading = false;
  FocusNode searchFocusNode = FocusNode();

  void getData() async {
    setState(() {
      isLoading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.callBackFunction();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }
  void _unfocus() {
    if (FocusManager.instance.primaryFocus != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
  // File? image;
  // void takePicture() async {
  //   XFile? value = await ImagePicker()
  //       .pickImage(source: ImageSource.gallery, imageQuality: 40);
  //   if (value != null) {
  //     setState(() {
  //       image = File(value.path);
  //     });
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    PaintingBinding.instance.imageCache.clear();

    return GestureDetector(
      onTap: () {
       
             if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }
        if (FocusManager.instance.primaryFocus != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
      },
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
          drawer:   Drawer(
            elevation: 10,
            child: ListView(children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(

                        image: AssetImage("assets/images/app-icon.jpg"),
                    fit: BoxFit.cover)
                  ),
                  child: Center(child: Text("Admin Info",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24
                  ),))),

              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUs()));
                },
                title:  Text("About",style:GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                )),
              )


            ],),
          ),
            appBar: AppBar(
                centerTitle: true,
                // leading: Icon(Icons.admin_panel_settings,color: Colors.white,),
                actions: [
                  IconButton(onPressed: (){
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
                                        builder: (context)=>SplashScreen()));
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
                  }

                  , icon: Icon(Icons.logout,color:Colors.white))
                ],
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
                title: Text('Admin Dashboard',
                    style: GoogleFonts.lato(
                      color:Colors.white,
                        fontSize: 20, fontWeight: FontWeight.bold))),
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      // scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                              radius: 40, child: Icon(Icons.person)),

                          SizedBox(
                            height: 14,
                          ),
                          //appProvider.getAdminInformation.name=false? "admin":appProvider.getAdminInformation.name,
                          Text(  "Admin",
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold, fontSize: 24)),
                          //appProvider.getAdminInformation.email=false? "admin@gmail.com":appProvider.getAdminInformation.email,
                          Text("Admin@gmail.com",
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          // ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //       primary: const Color.fromARGB(255, 2, 51, 91),
                          //     ),
                          //     onPressed: () {
                          //       Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) =>
                          //                   NotificationScreen()));
                          //     },
                          //     child: Text("Send Notifications to Users",
                          //     style:TextStyle(
                          //       color:Colors.white
                          //     ))),
                          GridView.count(
                            padding: EdgeInsets.only(top: 15),
                            primary: false,
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: [
                              SingleDashItem(
                                title: appProvider.getUserList.length.toString(),
                                subtitle: "Users",
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserView()));
                                },
                              ),
                              SingleDashItem(
                                title: appProvider.getCategoriesList.length
                                    .toString(),
                                subtitle: "Categories",
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CategoryView()));
                                },
                              ),
                              SingleDashItem(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductView()));
                                  },
                                  title: appProvider.getProductsList.length
                                      .toString(),
                                  subtitle: "Products"),
                              SingleDashItem(
                                  onPressed: () {},
                                  title: "\$ ${appProvider.getTotalEarnings}",
                                  //Rs.${(appProvider.getTotalEarnings)*130}
                                  subtitle: "Earning"),
                              SingleDashItem(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OrderList(title: "Pending")));
                                  },
                                  title: appProvider.getPendingOrderList.length
                                      .toInt()
                                      .toString(),
                                  subtitle: "Pending Order"),
                              SingleDashItem(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OrderList(title: "Completed")));
                                  },
                                  title: appProvider.getCompletedOrderList.length
                                      .toInt()
                                      .toString(),
                                  subtitle: "Completed Order"),
                              SingleDashItem(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OrderList(title: "Cancel")));
                                  },
                                  title: appProvider.getCancelOrderList.length
                                      .toInt()
                                      .toString(),
                                  subtitle: "Canceled Order"),
                              SingleDashItem(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OrderList(title: "Delivery")));
                                  },
                                  title: appProvider.getDeliveryOrderList.length
                                      .toInt()
                                      .toString(),
                                  subtitle: "Delivery Order"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
      ),
    );
  }
}
