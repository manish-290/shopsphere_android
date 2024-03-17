import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/Account_screen/account_screen.dart';
import 'package:shop_sphere/firebase_helper/firebase_auth.dart';
import 'package:shop_sphere/provider/app_provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isHidepassword = true;
  bool isHideConfirmpassword = true;
  bool passwordError = false;

  TextEditingController newpassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  void showErrorSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("The password doesn't match!",
      style:GoogleFonts.lato(
        fontWeight: FontWeight.bold
      )),
      backgroundColor: Colors.red,
    ));
  }
  void newPassSnackbar(BuildContext context,Error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:Text(Error ,
      style:GoogleFonts.lato(
        fontWeight: FontWeight.bold
      )),
      backgroundColor: Colors.black,
    ));
  }
   void showUpdatedSnackbar(BuildContext context,Success) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:Text(Success ,
      style:GoogleFonts.lato(
        fontWeight: FontWeight.bold
      )),
      backgroundColor: Color.fromARGB(255, 43, 169, 47),
    ));
    // Future.delayed(Duration(seconds: 2),(){
    //   Navigator.of(context,rootNavigator: true).pop();
    // });
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
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
            title: Text(
              "Change your password",
              style: GoogleFonts.lato(
                color:Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Gutter(),
              Gutter(),
              TextFormField(
                  controller: newpassword,
                  obscureText: isHidepassword,
                  decoration: InputDecoration(
                    hintText: "Enter the new password",
                    enabledBorder: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.security_rounded),
                    suffixIcon: MaterialButton(
                        child: isHidepassword
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isHidepassword = !isHidepassword;
                          });
                        }),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 4, 71, 125),
                            width: 3.0)),
                  )),
              Gutter(),
              TextFormField(
                  obscureText: isHideConfirmpassword,
                  controller: confirmpassword,
                  decoration: InputDecoration(
                    hintText: "Confirm the new password",
                    enabledBorder: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.security_sharp),
                    suffixIcon: MaterialButton(
                        child: isHideConfirmpassword
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isHideConfirmpassword = !isHideConfirmpassword;
                          });
                        }),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 4, 71, 125),
                            width: 3.0)),
                  )),
              Gutter(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () async {
                    if(newpassword.text.isEmpty){
                      newPassSnackbar(context,"Password is empty");
                    }
                   else if(confirmpassword.text.isEmpty){
                         newPassSnackbar(context,"Password is empty");

                    }
                    else if(confirmpassword.text == newpassword.text) {
                      await FirebaseAuthHelper.instance
                          .updatePassword(newpassword.text,context);
                          showUpdatedSnackbar(context,"Password Changed!");

                          Future.delayed(Duration(seconds: 4),(){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context)=>AccountScreen()));
                          });

                          
                    } else {
                      showErrorSnackbar(context);
                    }
                  },
                  child: Text("Update password",style:TextStyle(
                    color:Colors.white,
                    fontWeight: FontWeight.bold
                  )))
            ],
          ),
        ));
  }
}
