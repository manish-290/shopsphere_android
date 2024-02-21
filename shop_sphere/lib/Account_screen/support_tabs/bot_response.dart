final Map<dynamic, String> responses = {
  "name": "I am support chatbot. I was built by ShopSphere-team ",
  "create account": "To create an account,You have to go to signup, verify your emails, and login.",
  "payment": "We accept  Stripe payment methods for now.",
  "Errors": "There may be errors and bugs that needs to be fixed. So, please be patient.",
  "thank": "You are most welcome",
  "questions": "Yeah sure, ask me the questions related to Shopsphere Application",
  "contact": "For any queries or issues you can contact us at support@shopsphere.com",
  "address": "Our official address is: Hetauda, Nepal",
  "opening hours": "Opening hours from Monday to Friday from 10 AM to 5 PM",
  "hello": "Hi there! How can I assist you?",
  "catagories":"We have different catagories including Iphone Series, Androids, Laptops, Pendrives, Processors and many more.",
  "recommendation":"We are in the process to integrate the product recommendations based on user browsing history, interactions and Conversion rate.",

};

//function to prcess user query
String? processUserQuery(String userquery) {
  //nlp processing
  if (userquery.contains("create account")) {
    return responses["create account"];
  } else if (userquery.contains("opening hours")) {
    return responses["opening hours"];
  } else if (userquery.contains("address")) {
    return responses["address"];
  } else if (userquery.contains("hello")) {
    return responses["hello"];
  } else if (userquery.contains("questions")) {
    return responses["questions"];
  } else if (userquery.contains("contact")) {
    return responses["contact"];
  } else if (userquery.contains("payment")) {
    return responses["payment"];
  } else if (userquery.contains("recommendation")) {
    return responses["recommendation"];
  } else if (userquery.contains("catagories")) {
    return responses["catagories"];
  } else if (userquery.contains("delivery time")) {
    return responses["delivery time"];
  } else if (userquery.contains("name")) {
    return responses["name"];
  } else if (userquery.contains("thank")) {
    return responses["thank"];
  } else if (userquery.contains("Errors")) {
    return responses["Errors"];
  } else {
    return "I am sorry, I only have the limited information regarding the application. How can I assist you apart from that context? ";
  }
}
