
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_sphere/Account_screen/support_tabs/FAQs.dart';
import 'package:shop_sphere/Account_screen/support_tabs/bot_response.dart';
import 'package:shop_sphere/model/userModel/user_model.dart';

class CustomerSupport extends StatefulWidget {
  const CustomerSupport({Key? key}) : super(key: key);

  @override
  _CustomerSupportState createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport>
    with SingleTickerProviderStateMixin {
  final List<FAQItem> faqItems = [
    FAQItem(
        question: 'How do I create an account?',
        answer: 'To create an account, You have to go "Signup" Page and follow the steps'),
    FAQItem(
        question: 'What payment methods do you accept?',
        answer: 'We accept Visa, mastercard and more'),
    FAQItem(
        question: 'How long does it take to deliver the services?',
        answer: 'It takes maximum up to 6 days, but not more than that.'),
  ];

  TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isBotResponding = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _toggleChat() {
    setState(() {
      _isBotResponding = false; // Reset the bot response indicator
      _animationController.isDismissed
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  Future<void> _simulateBotResponse(String userMessage) async {
    setState(() {
      _isBotResponding = true;
      _messages.add("User: $userMessage");
      _messageController.clear();
    });

    // Simulate a delay of 3 seconds for the bot to respond
    await Future.delayed(Duration(seconds: 3));

    String? chatbotResponse = await processUserQuery(userMessage);

    setState(() {
      _messages.add("Chatbot: $chatbotResponse");
      _isBotResponding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Customer Support",
          style: GoogleFonts.lato(
            color:Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          GestureDetector(
            onTap: _toggleChat,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: Icon(
                FontAwesomeIcons.comment,
                color: const Color.fromARGB(255, 2, 92, 247),
              ),
            ),
          )
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          bool isChatClicked = _animationController.isCompleted;
          return isChatClicked
              ? _buildChatScreen()
              : _buildFAQScreen();
        },
      ),
    );
  }

  Widget _buildChatScreen() {
    return GestureDetector(
      onTap: _toggleChat,
      child: Container(
        color: Colors.transparent,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 60,
                  color: const Color.fromARGB(255, 4, 60, 105),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Image.asset("assets/images/happyCustomer.png",scale:8.0),
                        SizedBox(width: 10,),
                        Text(
                          "Customer Service",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 234, 212, 7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ListView.builder(
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                _messages[index],
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        if (_isBotResponding)
                          Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        Container(
                          margin: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Type your queries...",
                                    hintStyle: TextStyle(color: Colors.grey[900]),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 3, 51, 90),
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromARGB(255, 2, 58, 103), width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _simulateBotResponse(
                                      _messageController.text);
                                  FocusScope.of(context).unfocus();
                                },
                                icon: Icon(Icons.send, color: Color.fromARGB(255, 185, 234, 6)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQScreen() {
    return ListView.builder(
      itemCount: faqItems.length,
      itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text(
            faqItems[index].question,
            style: GoogleFonts.lato(
              color: Colors.black,
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                faqItems[index].answer,
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}


// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shop_sphere/Account_screen/support_tabs/FAQs.dart';
// import 'package:shop_sphere/Account_screen/support_tabs/bot_response.dart';

// class CustomerSupport extends StatefulWidget {
//   const CustomerSupport({Key? key}) : super(key: key);

//   @override
//   _CustomerSupportState createState() => _CustomerSupportState();
// }

// class _CustomerSupportState extends State<CustomerSupport>
//     with SingleTickerProviderStateMixin {
//   final List<FAQItem> faqItems = [
//     FAQItem(
//         question: 'How do I create an account?',
//         answer:
//             'To create an account, You have to go "Signup" Page and follow the steps'),
//     FAQItem(
//         question: 'What payment methods do you accept?',
//         answer: 'We accept Visa, mastercard and more'),
//     FAQItem(
//         question: 'How long does it take to deliver the services?',
//         answer: 'It takes maximum up to 6 days, but not more than that.'),
//   ];

//   TextEditingController _messageController = TextEditingController();
//   final List<String> _messages = [];

//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;
//   bool _isBotResponding = false;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: Offset(-1.0, 0.0),
//       end: Offset(0.0, 0.0),
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//   }

//   void _toggleChat() {
//     setState(() {
//       _isBotResponding = false; // Reset the bot response indicator
//       _animationController.isDismissed
//           ? _animationController.forward()
//           : _animationController.reverse();
//     });
//   }

//   Future<void> _simulateBotResponse(String userMessage) async {
//     setState(() {
//       _isBotResponding = true;
//       _messages.add("User: $userMessage");
//       _messageController.clear();
//     });

//     // Simulate a delay of 3 seconds for the bot to respond
//     await Future.delayed(Duration(seconds: 3));

//     String? chatbotResponse = await processUserQuery(userMessage);

//     setState(() {
//       _messages.add("Chatbot: $chatbotResponse");
//       _isBotResponding = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         centerTitle: true,
//         title: Text(
//           "Customer Support",
//           style: GoogleFonts.lato(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.close),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         actions: [
//           GestureDetector(
//             onTap: _toggleChat,
//             child: CircleAvatar(
//               backgroundColor: Colors.white,
//               radius: 20,
//               child: Icon(
//                 FontAwesomeIcons.comment,
//                 color: const Color.fromARGB(255, 2, 92, 247),
//               ),
//             ),
//           )
//         ],
//       ),
//       body: AnimatedBuilder(
//         animation: _animationController,
//         builder: (context, child) {
//           bool isChatClicked = _animationController.isCompleted;
//           return isChatClicked
//               ? _buildChatScreen()
//               : _buildFAQScreen();
//         },
//       ),
//     );
//   }

//   Widget _buildChatScreen() {
//     return AlertDialog(
//       backgroundColor: Colors.blue.withOpacity(0.4),
//       title: Center(
//         child: Column(
//           children: [
//          Image.asset("assets/images/happyCustomer.png",scale: 9,),
//             SizedBox(height: 5,),
//             Text(
//               " Customer service",
//               textAlign: TextAlign.center,
//               style: GoogleFonts.lato(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//                 color: Color.fromARGB(255, 207, 193, 61),
//               ),
//             ),
//           ],
//         ),
//       ),
//       content: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(16)),
//         ),
//         height: 300,
//         width: 600,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(
//                     _messages[index],
//                     style: GoogleFonts.lato(
//                       color: Colors.white,
//                     ),
//                   ),
//                 );
//               },
//             ),
//             if (_isBotResponding)
//               Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               )
//           ],
//         ),
//       ),
//       actions: [
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _messageController,
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   hintText: "Type your queries...",
//                   hintStyle: TextStyle(color: Colors.grey),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(
//                       color: Color.fromARGB(255, 3, 51, 90),
//                       width: 2,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey, width: 2),
//                   ),
//                 ),
//               ),
//             ),
//             IconButton(
//               onPressed: () {
//                 _simulateBotResponse(_messageController.text);
//                 FocusScope.of(context).unfocus();
//               },
//               icon: Icon(Icons.send, color: Colors.blue),
//             ),
//             SizedBox(height: 200,)
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildFAQScreen() {
//     return ListView.builder(
//       itemCount: faqItems.length,
//       itemBuilder: (context, index) {
//         return ExpansionTile(
//           title: Text(
//             faqItems[index].question,
//             style: GoogleFonts.lato(
//               color: Colors.black,
//             ),
//           ),
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Text(
//                 faqItems[index].answer,
//                 style: GoogleFonts.lato(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
// }






// // import 'package:flutter/material.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:shop_sphere/Account_screen/support_tabs/FAQs.dart';
// // import 'package:shop_sphere/Account_screen/support_tabs/bot_response.dart';

// // class CustomerSupport extends StatefulWidget {
// //   const CustomerSupport({super.key});

// //   @override
// //   State<CustomerSupport> createState() => _CustomerSupportState();
// // }

// // class _CustomerSupportState extends State<CustomerSupport> {
// //   final List<FAQItem> faqItems = [
// //     FAQItem(
// //         question: 'How do I create an account?',
// //         answer:
// //             'To create an account, You have to go "Signup" Page and follow the steps'),
// //     FAQItem(
// //         question: 'What payment methods do you accept?',
// //         answer: 'We accept Visa, mastercard and more'),
// //     FAQItem(
// //         question: 'How long does it take to deliver the services?',
// //         answer: 'It takes maximum upto 6 days, but not more than that.'),
// //   ];
// // //list for messages
// //   TextEditingController _messageController = TextEditingController();
// //   final List<String> _messages = [];


// // void sendMessage(String message){
// //   String? chatbotResponse = processUserQuery(message);
// //   setState(() {
// //     _messages.add("User:  $message");
// //     _messages.add("Chatbot:  $chatbotResponse");
// //     _messageController.clear();
// //   });
// // }

// //   bool isChatClicked = false;
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         backgroundColor: Colors.grey,
// //         appBar: AppBar(
// //           backgroundColor: Colors.black,
// //           centerTitle: true,
// //           title: Text("Customer Support",
// //               style: GoogleFonts.lato(
// //                 fontWeight: FontWeight.bold,
// //               )),
// //           actions: [
// //             GestureDetector(
// //               onTap: () {
// //                 setState(() {
// //                   isChatClicked = !isChatClicked;
// //                   print(isChatClicked);
// //                 });
// //               },
// //               child: CircleAvatar(
// //                 backgroundColor: Colors.white,
// //                 radius: 20,
// //                 child: Icon(FontAwesomeIcons.comment,
// //                     color: const Color.fromARGB(255, 2, 92, 247)),
// //               ),
// //             )
// //           ],
// //         ),
// //         body: isChatClicked ? 
// //      SingleChildScrollView(
// //       scrollDirection: Axis.vertical,
// //        child: AlertDialog(
// //         backgroundColor: Colors.blue.withOpacity(0.4),
// //         title:Center(
// //           child: Text("Welcome to the customer service",
// //           textAlign: TextAlign.center,
// //           style:GoogleFonts.lato(
// //             fontWeight: FontWeight.bold,
// //             fontSize: 20,
// //             color:Colors.white
// //           )),
// //         ),
// //         content: Container(
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.all(Radius.circular(16))
// //           ),
// //           height: 300,
// //           width:600,
// //           child:ListView.builder(
// //             itemCount:_messages.length ,
// //             itemBuilder: (context,index){
// //               return ListTile(
// //                 title: Text(_messages[index],
// //                 style:GoogleFonts.lato(
// //                   color:Colors.white
// //                 )),
// //               );
// //           })
// //         ),
// //        actions: [
// //         Row(children: [
// //            Expanded(
// //              child: TextField(
// //                    controller: _messageController,
// //                    style:TextStyle(color:Colors.white),
// //                    decoration: InputDecoration(
// //                      hintText: "Type your queries...",
// //                      hintStyle: TextStyle(color:Colors.grey),
                     
// //                      focusedBorder: OutlineInputBorder(
// //                        borderRadius: BorderRadius.circular(12),
// //                       borderSide: BorderSide(color: Color.fromARGB(255, 3, 51, 90),width: 2)
// //                      ),
                     
// //                      enabledBorder: OutlineInputBorder(
// //               borderSide: BorderSide(color: Colors.grey,width: 2)
// //                      )
// //                    ),
// //                     ),
// //            ),
// //          IconButton(
// //         onPressed: (){
// //           sendMessage(_messageController.text);
// //            FocusScope.of(context).unfocus();
// //         }, 
// //         icon: Icon(Icons.send,color:Colors.blue)),
// //         ],),
// //          Center(
// //         child: ElevatedButton(
// //           style:ElevatedButton.styleFrom(
// //             primary: Colors.red
// //           ),
// //           onPressed:(){
// //             Navigator.of(context).pop();
// //           } , 
// //           child:Text("Close") ,),
          
// //          ),
// //          SizedBox(height:12)
         
// //        ],
       
// //        ),
// //      )
     
// //        :ListView.builder(
// //             itemCount: faqItems.length,
// //             itemBuilder: (context, index) {
// //               return ExpansionTile(
// //                 title: Text(faqItems[index].question,
// //                     style: GoogleFonts.lato(
// //                       color: Colors.black,
// //                     )),
// //                 children: <Widget>[
// //                   Padding(
// //                     padding: const EdgeInsets.all(15.0),
// //                     child: Text(faqItems[index].answer,
// //                         style: GoogleFonts.lato(
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.bold)),
// //                   )
// //                 ],
// //               );
// //             }));
// //   }
// // }
