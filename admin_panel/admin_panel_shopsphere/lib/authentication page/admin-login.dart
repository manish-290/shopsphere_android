import 'package:admin_panel_shopsphere/authentication%20page/admin-signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


import '../helpers/firebase-auth.dart';
import '../screens/homePage/home_page.dart';

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
  bool isHidePassword = true;

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
            color:  Colors.white
        ),),
        icon: Icon(Icons.check_circle,color:Colors.green[800]),
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Icon(Icons.login,color: Colors.white,),
          title: Text('Admin Login',
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
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
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40),
              Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset('assets/images/app-icon.jpg',
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
                              border:OutlineInputBorder(
                                  borderSide: BorderSide(width: 2,style:BorderStyle.solid,color:Colors.black)
                              ),
                              label: Text('Email'),
                              labelStyle: TextStyle(color: Color.fromARGB(206, 3, 70, 124)),
                              hintText: 'Email@...',

                              hintStyle: TextStyle(color: Colors.grey),

                              prefixIcon: Icon(
                                Icons.alternate_email,
                                color: Colors.black,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) => (value!.length < 6)
                              ? "Enter the correct password"
                              : null,
                          controller: passwordController,
                          obscureText: isHidePassword,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          decoration: InputDecoration(
                              border:OutlineInputBorder(
                                  borderSide: BorderSide(width: 2,color:Colors.black)
                              ),
                              label: Text('Password'),
                              labelStyle: TextStyle(color: Color.fromARGB(206, 3, 70, 124)),
                              hintText: 'p@ssword',
                              hintStyle: TextStyle(color: Colors.grey),
                              suffixIcon: MaterialButton(
                                  child: isHidePassword
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      isHidePassword = !isHidePassword;
                                    });
                                  }),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black,
                              )),
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
                                    builder: (context) => HomePageAdmin()));
                          });

                          // Navigator.of(context).pop();
                        }
                      } catch (e) {
                        print('my error is :$e');
                      }
                    }
                  },
                  child: Container(
                    width:150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 115, 3, 85),
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


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Enter Admin Credentials?',
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 14,
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => signUp()));
                    },
                    child: Text(
                      "SignUp",
                      style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
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
