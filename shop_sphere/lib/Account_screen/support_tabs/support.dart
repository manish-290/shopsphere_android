
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_sphere/Account_screen/account_screen.dart';
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
        answer: 'To create an account, you have to go "Signup" Page, verify emails and login.'),
    FAQItem(
        question: 'What payment methods do you accept?',
        answer: 'We accept Stripe payment methods for now.'),
    FAQItem(
        question: 'How can I contact the security team?',
        answer: 'For any queries or issues you can contact us at support@shopsphere.com'),
    FAQItem(
        question: 'What are the listed product\'s catagories in such Application?',
        answer: 'We have different catagories including Iphone Series, Androids, Laptops, Pendrives, Processors and many more.'),
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
      duration: const Duration( milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
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
UserModel user =  UserModel(id: 'null', image: null, password: 'password', name: 'Customer', email: 'email');
  Future<void> _simulateBotResponse(String userMessage) async {
    setState(() {
      _isBotResponding = true;
      _messages.add("${user.name}: $userMessage");
      _messageController.clear();
    });

    // Simulate a delay of 3 seconds for the bot to respond
    await Future.delayed(const Duration(seconds: 3));

    String? chatbotResponse =  processUserQuery(userMessage);

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
        leading:  IconButton(
          icon:  const Icon(Icons.close),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountScreen()));
          },
        ),
        actions: [
          GestureDetector(
            onTap: _toggleChat,
            child: const CircleAvatar(
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
              borderRadius: const BorderRadius.only(
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
                         ClipRRect(
                           borderRadius: BorderRadius.circular(50),
                             child: Image.asset("assets/images/gemini.jfif",scale: 8,)),
                        SizedBox(width: 10,),
                        Text(
                          "Virtual Assistant ",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white
                              //Color.fromARGB(255, 234, 212, 7),
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
                                icon: Icon(Icons.send, color: Colors.white),
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

