import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/authentication_page/login.dart';
import 'package:shop_sphere/authentication_page/signUp.dart';
import 'package:shop_sphere/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:shop_sphere/firebase_helper/firebase_auth.dart';
import 'package:shop_sphere/provider/app_provider.dart';
import 'package:shop_sphere/splash_screen/splash_screen.dart';

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
 
 late final AnimationController _controller = AnimationController(
  vsync: this,
  duration: const Duration(seconds: 10))..repeat();
  
   @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Color.fromARGB(255, 101, 201, 191),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              shape:BoxShape.circle,
            
            ),
            padding: const EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context,Widget? child){
                      return RotationTransition(
                        
                        turns: _controller,
                         child: ClipOval(
                      child: Image.asset(
                        'assets/images/shopsphere.png',
                        height: 150,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ),);
                     
                    },
                    
                  ),
                ),
               const SizedBox(
                  height: 75,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ShaderMask(
                      shaderCallback: (Rect bounds){
                        return const LinearGradient(
                          colors: [Colors.black,Colors.white],
                          begin: Alignment.topLeft,
                          end:Alignment.bottomRight,
                          tileMode: TileMode.mirror).createShader(bounds);
                      },
                      child:  Text(
                        'WELCOME TO THE SHOPSPHERE. EXPERIENCE THE SHOPPING WITH EASE.',
                        style: GoogleFonts.lato(
                          color:Colors.white,
                            fontSize: 20,
                            letterSpacing: 2.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ClipOval(
                  child: Image.asset("assets/images/welcomeHome.png",
                  height:170,
                  width:250),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const signUp()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color:  Colors.black,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            'SHOP NOW!',
                            style: GoogleFonts.lato(
                                fontSize: 24,
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
