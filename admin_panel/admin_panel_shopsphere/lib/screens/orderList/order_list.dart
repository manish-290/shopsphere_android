import 'package:admin_panel_shopsphere/provider/app_provider.dart';
import 'package:admin_panel_shopsphere/screens/singleOrder/single_order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/order_model.dart';

class OrderList extends StatelessWidget {
//  final List<OrderModel> orderModelList;
 final String title;
  const OrderList({super.key,
  required this.title,
  //  required this.orderModelList,
   });
   List<OrderModel> getOrderList(AppProvider appProvider){
    if(title=="Pending"){
      return appProvider.getPendingOrderList;
    }else if(title=="Completed"){
      return appProvider.getCompletedOrderList;
    }else if(title=="Cancel"){
      return appProvider.getCancelOrderList;
    }else if(title=="Delivery"){
      return appProvider.getDeliveryOrderList;
    }else{
      return [];
    }
   }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 2, 52, 92),
        title: Text('Order List',style:TextStyle(color:Colors.white)),
      ),
      body: getOrderList(appProvider).isEmpty
      ? Center(child: Text("${title} is empty"),)
      :ListView.builder(
        // itemCount: orderModelList.length,
        itemCount: getOrderList(appProvider).length,
        itemBuilder: (context,index){
          OrderModel orderModel = getOrderList(appProvider)[index];
          return SingleOrderWidget(orderModel: orderModel);
        })
    );
  }
}