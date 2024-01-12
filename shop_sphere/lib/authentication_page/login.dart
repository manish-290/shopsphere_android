import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_sphere/authentication_page/signUp.dart';
import 'package:shop_sphere/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:shop_sphere/firebase_helper/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';
  String error = '';

  bool isloading = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  FirebaseAuthHelper _auth = FirebaseAuthHelper();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void getErrorOut(Error){
    setState(() {
      showDialog(
        barrierColor: Colors.transparent,
        context: context, 
        builder: (context)=>AlertDialog(
          icon: Icon(Icons.error,color: const Color.fromARGB(255, 244, 21, 5),),
          backgroundColor: Color.fromARGB(111, 110, 164, 206),
          title:Text('Failed',style:TextStyle(
            fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 248, 20, 3))),
          content: Text(Error,style:TextStyle(color:const Color.fromARGB(255, 254, 20, 3))),
        ));
    });
    Future.delayed(Duration(seconds: 2),(){
           Navigator.of(context,rootNavigator: true).pop();
    });
  }
  void getSuccess(Error){
    setState(() {
      showDialog(
        barrierColor: Colors.transparent,
        context: context, builder: (context)=>AlertDialog(
        backgroundColor: Color.fromARGB(111, 110, 164, 206),
        elevation: 10,
        title:Text("Success",style: GoogleFonts.lato(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 5, 238, 13)
        ),),
        icon: Icon(Icons.check_circle,color:const Color.fromARGB(255, 1, 245, 9)),
      ));
     
    });
    Future.delayed(Duration(seconds: 2),(){
           Navigator.of(context,rootNavigator: true).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 137, 137, 131),
        appBar: AppBar(
          leading: Icon(Icons.login,color: Colors.white,),
          title: Text('Login to ShopSphere',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40),
              Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset('assets/images/shopsphere.png',
                          width: 150))),
              SizedBox(
                height: 50,
              ),
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70.0),
                        child: Container(
                          decoration:BoxDecoration(
                            color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) => value!.isEmpty
                                ? "Please provide your email"
                                : null,
                            controller: emailController,
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                                label: Text('Email',style:TextStyle(
                                  color:Colors.grey
                                )),
                                labelStyle: GoogleFonts.lato(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.alternate_email,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70.0),
                        child: Container(
                          decoration:BoxDecoration(
                            color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (value) => (value!.length < 6)
                                ? "Enter the correct password"
                                : null,
                            controller: passwordController,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            decoration: InputDecoration(
                              border:InputBorder.none,
                                label: Text('Password',style:TextStyle(
                                  color:Colors.grey
                                )),
                                labelStyle: GoogleFonts.lato(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: GestureDetector(
                  onTap: () async {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        isloading = true;                    
                      });
                                        

                      try {
                        dynamic result = await _auth.login(email, password);
                        if (result == null) {
                          setState(() {
                            error = 'Try again!';
                            getErrorOut(error);
                          });

                          isloading = false;
                        } else {
                          setState(() async{
                            error = '';
                            getSuccess(error);
                          await Future.delayed(Duration(seconds: 2));
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomBottomBar()));
                          });

                          // Navigator.of(context).pop();
                        }
                      } catch (e) {
                        print('my error is :$e');
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 4, 50, 88),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('Login',
                            style: GoogleFonts.lato(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Text(
              //   error,
              //   style: TextStyle(
              //       color:  const Color.fromARGB(255, 246, 8, 8), fontSize: 18),
              // ),
             
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Do not have an Account?',
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 12,
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => signUp()));
                    },
                    child: Text(
                      "SignUp",
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
