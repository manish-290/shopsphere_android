import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/firebase_helper/firestore_helper.dart';
import 'package:shop_sphere/model/order_model.dart';
import 'package:shop_sphere/provider/app_provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Order",style:TextStyle(
              fontWeight: FontWeight.bold,
          color:Colors.white,)),
        centerTitle: true,
      ),
      //i change futurebuilder to streambuilder and all set
      body: StreamBuilder<List<OrderModel>>(
          stream: FirebaseFirestoreHelper.instance.getUserOrder(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              );
            } else if (snapshot.data!.isEmpty || snapshot.data == null) {
              return const Center(
                  child:  Text('No Orders Found',
                      style:  TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 24)));
            } else {
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      List<OrderModel> orders = snapshot.data!;
                      OrderModel orderModel = orders[index];
                      return Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: ExpansionTile(
                          childrenPadding: EdgeInsets.zero,
                          collapsedShape: const RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 3,
                                  color: Color.fromARGB(255, 3, 56, 99))),
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color.fromARGB(255, 2, 53, 95),
                                  width: 3)),
                          title: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  color: Color.fromARGB(255, 2, 35, 62)
                                      .withOpacity(0.3),
                                  child: Image.network(
                                      orderModel.products.isNotEmpty
                                          ? orderModel.products[0]!.image
                                          : ""),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 230,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  orderModel.products.isNotEmpty
                                                      ? orderModel
                                                          .products[0]!.name
                                                      : "",
                                                  style: const  TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 2, 35, 62),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 19)),
                                             const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  "Total price: \$${orderModel.totalprice.toString()}",
                                                  style: GoogleFonts.lato(
                                                      color: Color.fromARGB(
                                                          255, 43, 133, 46),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                  "Status: ${orderModel.status.toString()}",
                                                  style: GoogleFonts.abel(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                             const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  orderModel.products.isNotEmpty
                                                      ? "Quantity: ${orderModel.products[0]!.counter.toString()}"
                                                      : 'N/A',
                                                  style: GoogleFonts.abel(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 2, 67, 120),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                                      SizedBox(height: 10,),
                                                      Column(children: [
                                                       orderModel.status =="Pending"||
                                                       orderModel.status=="Delivery"? ElevatedButton(
                                                          style:ElevatedButton.styleFrom(
                                                            primary: Colors.red
                                                          ),
                                                          onPressed: () async{
                                                           await FirebaseFirestoreHelper.instance
                                                            .updateOrder(orderModel, "Cancel");
                                                            orderModel.status="Cancel";
                                                            setState(() {
                                                              
                                                            });
                                                          }, 
                                                          child: Text("Cancel Order",style: TextStyle(
                                                            color:Colors.white,
                                                          ),)):SizedBox.fromSize(),
                                                          
                                                          orderModel.status =="Delivery"?
                                                           ElevatedButton(
                                                              style:ElevatedButton.styleFrom(
                                                            primary: Colors.green
                                                          ),
                                                          onPressed: () async{
                                                            await  FirebaseFirestoreHelper.instance
                                                            .updateOrder(orderModel, "Completed");
                                                            orderModel.status="Completed";
                                                            setState(() {
                                                              
                                                            });
                                                          
                                                          }, 
                                                          child: const Text(" Order delivered",style:TextStyle(
                                                            color:Colors.white,
                                                            fontWeight: FontWeight.bold
                                                          ))):SizedBox.fromSize(),
                                                      ],)
                                            ],
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }
          }),
    );
  }
}
