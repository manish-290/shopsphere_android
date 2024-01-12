import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../custom_bottom_bar/custom_bottom_bar.dart';

class StripeHelper {
  static StripeHelper instance = StripeHelper();
  Map<String, dynamic>? paymentIntent;
  Future<bool> makePayment(String amount,BuildContext context) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      var gpay = PaymentSheetGooglePay(
          merchantCountryCode: "US", currencyCode: 'USD', testEnv: true);

      //initialize the payment sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.light,
                  merchantDisplayName: "Manish_Paudel",
                  googlePay: gpay));
        //  .then((value){});

      //display the payment sheet
      displayPaymentSheet(context);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

void showSnackBar( BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:Text(message,
      style:GoogleFonts.lato(
        fontWeight: FontWeight.bold
      )),
      backgroundColor: Colors.green,
    ));
    
  }
//display payment sheet
  displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet(
         options: const PaymentSheetPresentOptions(timeout: 1200000)
      ).then((value) {
        showSnackBar(context, "Ordered placed successfully");
          Future.delayed(Duration(seconds: 2), () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomBottomBar()));
                          });

        print("Payment Successful");
      });
    } catch (e) {
      print(e.toString());
    }
  }

 Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {"amount": amount, "currency": currency};
      http.Response response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          "Authorization":
              "Bearer sk_test_51O3hTHDjfAqHbtXhe69t0t8IcQbBJMlfh46TMzMM1JUZLOWw5qaMUKPPKW1Op9bC7loCKPFzMNO7MQgew9AHFpT9006fXc3Owg",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: body,
      );
      if(response.statusCode==200){
              return json.decode(response.body);
      }else{
        throw Exception('Failed to load payment');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
