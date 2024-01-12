import 'package:admin_panel_shopsphere/provider/app_provider.dart';
import 'package:admin_panel_shopsphere/screens/homePage/categoryView/category_view.dart';
import 'package:admin_panel_shopsphere/screens/homePage/single_dashboard_item.dart';
import 'package:admin_panel_shopsphere/screens/homePage/userView/user_view.dart';
import 'package:admin_panel_shopsphere/screens/notificationScreen/notification_screen.dart';
import 'package:admin_panel_shopsphere/screens/orderList/order_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
            appBar: AppBar(
                centerTitle: true,
                leading: Icon(Icons.admin_panel_settings,color: Colors.white,),
                actions: [
                  IconButton(onPressed: () => _unfocus()

                  , icon: Icon(Icons.refresh,color:Colors.white))
                ],
                backgroundColor: const Color.fromARGB(255, 2, 49, 88),
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
                          CircleAvatar(radius: 30, child: Icon(Icons.person)),
                          SizedBox(
                            height: 14,
                          ),
                          Text("Manish Paudel",
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold, fontSize: 24)),
                          Text("manishpaudel270@gmail.com",
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(255, 2, 51, 91),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationScreen()));
                              },
                              child: Text("Send Notifications to Users",
                              style:TextStyle(
                                color:Colors.white
                              ))),
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
                                  title: "\$${appProvider.getTotalEarnings}",
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
