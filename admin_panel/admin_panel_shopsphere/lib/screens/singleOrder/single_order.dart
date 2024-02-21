import 'package:admin_panel_shopsphere/helpers/firestore_helper.dart';
import 'package:admin_panel_shopsphere/models/order_model.dart';
import 'package:admin_panel_shopsphere/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SingleOrderWidget extends StatefulWidget {
  final OrderModel orderModel;
  const SingleOrderWidget({super.key, required this.orderModel});

  @override
  State<SingleOrderWidget> createState() => _SingleOrderWidgetState();
}

class _SingleOrderWidgetState extends State<SingleOrderWidget> {
  @override
  Widget build(BuildContext context) {
  AppProvider appProvider = Provider.of<AppProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: ExpansionTile(
        childrenPadding: EdgeInsets.zero,
        collapsedShape: RoundedRectangleBorder(
            side: BorderSide(width: 3, color: Color.fromARGB(255, 3, 56, 99))),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(255, 2, 53, 95), width: 3)),
         

        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 120,
                width: 125,
                color: Color.fromARGB(255, 2, 35, 62).withOpacity(0.3),
                child: Image.network(widget.orderModel.products.isNotEmpty
                    ? widget.orderModel.products[0]!.image
                    : ""),
              ),
            ),
          //from here
        Expanded(
              flex: 3,
              child: Container(
                height: 245,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                widget.orderModel.products.isNotEmpty
                                    ? widget.orderModel.products[0]!.name
                                    : "",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 2, 35, 62),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19)),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                "Total price: \$${widget.orderModel.totalprice.toString()}",
                                style: GoogleFonts.lato(
                                    color: Color.fromARGB(255, 43, 133, 46),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            SizedBox(
                              height: 15,
                            ),
                            Text("Status: ${widget.orderModel.status.toString()}",
                                style: GoogleFonts.abel(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                widget.orderModel.products.isNotEmpty
                                    ? "Quantity: ${widget.orderModel.products[0]!.counter.toString()}"
                                    : 'N/A',
                                style: GoogleFonts.abel(
                                    color:
                                        const Color.fromARGB(255, 2, 67, 120),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                                    Column(children: [
                                     widget.orderModel.status=="Pending" && widget.orderModel.status!="Delivery"
                                     ? ElevatedButton(
                                        style:ElevatedButton.styleFrom(
                                          minimumSize: Size(100, 30),
                                          primary: const Color.fromARGB(255, 1, 45, 81)
                                        ),
                                        onPressed: () async{
                                         await FirebaseFirestoreHelper.instance.updateOrder(widget.orderModel, "Delivery");
                                            widget.orderModel.status="Delivery";
                                             appProvider.updatePendingOrder(widget.orderModel);
                                             showSnackBarFn(context,"Added to delivery Order");
                                           setState(() {
                                             
                                           });
                                        },
                                         child: Text("Send to delivery",style:TextStyle(color:Colors.white)))
                                         :SizedBox.fromSize(),
                                         SizedBox(height: 1,),
                                        widget.orderModel.status=="Pending"||widget.orderModel.status=="Delivery"
                                        ? ElevatedButton(
                                        style:ElevatedButton.styleFrom(
                                          minimumSize: Size(100, 30),
                                          primary:  Colors.red
                                        ),
                                        onPressed: () async{

                                          if(widget.orderModel.status=="Pending"){
                                              await FirebaseFirestoreHelper.instance.updateOrder(widget.orderModel, "Cancel");
                                          widget.orderModel.status="Cancel";
                                          appProvider.updateCancelPendingOrder(widget.orderModel);
                                          showSnackBarFn(context, "Order cancelled");
                                          }else{
                                             await FirebaseFirestoreHelper.instance.updateOrder(widget.orderModel, "Cancel");
                                          widget.orderModel.status="Cancel";
                                          appProvider.updateCancelDeliveryOrder(widget.orderModel);
                                          showSnackBarFn(context, "Order cancelled");
                                         
                                          }
                                          setState(() {
                                            
                                          });
                                        
                                        },
                                         child: Text("Cancel Order",style:TextStyle(color:Colors.white)))
                                         :SizedBox.fromSize(),

                                         widget.orderModel.status=="Delivery"?ElevatedButton(
                                        style:ElevatedButton.styleFrom(
                                          primary: const Color.fromARGB(255, 1, 45, 81)
                                        ),
                                        onPressed: () async{
                                         await FirebaseFirestoreHelper.instance.updateOrder(widget.orderModel, "Completed");
                                          widget.orderModel.status="Completed";
                                          appProvider.updateCompletedOrder(widget.orderModel);
                                          showSnackBarFn(context, "Order completed");
                                         
                                        },
                                         child: Text("Complete Order",style:TextStyle(color:Colors.white)))
                                         :SizedBox.fromSize(),

                                    ],)
                          ],
                        ),
                      ]),
                ),
              ),
            )
            //if not pending
            
          ],
        ),
      ),
    );
  }
}

void showSnackBarFn(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('$message')),
  );
  
}
