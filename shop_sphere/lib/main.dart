import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/authentication_page/login.dart';
import 'package:shop_sphere/authentication_page/signUp.dart';
import 'package:shop_sphere/authentication_page/verifyEmail.dart';
import 'package:shop_sphere/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:shop_sphere/firebase_helper/firebase_auth.dart';
import 'package:shop_sphere/provider/app_provider.dart';
import 'package:shop_sphere/splash_screen/splash_screen.dart';

import 'Account_screen/support_tabs/support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Stripe with your publishable key
  Stripe.publishableKey =
      "pk_test_51O3hTHDjfAqHbtXhK5ZIaOY6Hm2vCBRu9cHbKuxmWlFtGE8pmclmYIDUZAergNBc3WGtTMSJkLIgTsZE8PcI0nzL00XeumMPgG";
  await Firebase.initializeApp(
      options:const FirebaseOptions(
          apiKey: 'AIzaSyDUZ-4RoWfM1QOoMujLGAzyDZQlm7k7rS4',
          appId: '1:828604194149:android:3adefcdecb85bfbfe4d58c',
          messagingSenderId: '828604194149',
          projectId: 'shopsphere-4ea75'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: Center(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: StreamBuilder(
                stream: FirebaseAuthHelper.instance.user,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const CustomBottomBar();
                  } else {
                    return const SplashScreen();
                  }
                })),
      ),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Colors.white,
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              shape:BoxShape.circle,
            
            ),
            padding: const EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/final.png',
                    scale:8,
                    // height: 150,
                    // width: 150,
                    fit: BoxFit.cover,
                  ),
                ),


                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),

                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const signUp()));
                    },
                    child:Padding(
                      padding: const EdgeInsets.only(left:210.0,top:70),
                      child: Container(
                        width:150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.purple[300],
                        ),
                        child: Center(
                          child: Text(
                            'SIGN-UP',
                            style: GoogleFonts.lato(
                                fontSize: 29,
                                fontWeight: FontWeight.bold,
                                color:   Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              
              ],
            ),
          ),
        ));
  }
}
