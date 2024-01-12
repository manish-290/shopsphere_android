import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SingleDashItem extends StatelessWidget {
  final String title,subtitle;
  final void Function()? onPressed;
  const SingleDashItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
          elevation: 5,
                        child: InkWell(
                          onTap: onPressed,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                               color:Colors.blue.withOpacity(0.5),
                            ),
                           child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text(title,
                            style:GoogleFonts.lato(
                              fontSize: 35,
                              color:Color.fromARGB(255, 5, 109, 195),
                              fontWeight: FontWeight.bold
                            )),
                             Text(subtitle,
                            style:GoogleFonts.lato(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ))
                           ],)
                          ),
                        ),
                      );
  }
}