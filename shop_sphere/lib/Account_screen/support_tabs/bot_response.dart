final Map<String, String> responses = {
  "name": "I am AI chatbot. I was built by Manish",
  "create account":
      "To create an account,You have to go to signup and follow steps ",
  "payment": "We accept Mastercard,Visa and other Stripe payment methods",
  "delivery time": "Delivery takes upto 6 days in maximum.",
  "Errors": "There may be errors and bugs that needs to be fixed",
  "thank": "You are most welcome",
  "questions": "Yeah sure, ask me the questions related to Shopsphere",
  "contact":
      "For any queries or issues you can contact us at support@shopsphere.com",
  "address": "Our address is: Basamadi-3, Hetauda, Nepal",
  "opening hours": "Opening hours from Monday to Friday from 10 AM to 5 PM",
  "hello": "Hi there! Whats up?"
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
  } else if (userquery.contains("delivery time")) {
    return responses["delivery time"];
  } else if (userquery.contains("name")) {
    return responses["name"];
  } else if (userquery.contains("thank")) {
    return responses["thank"];
  } else if (userquery.contains("Errors")) {
    return responses["Errors"];
  } else {
    return "I am sorry, I could not understand the question";
  }
}
