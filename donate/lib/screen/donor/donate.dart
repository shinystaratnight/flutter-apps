import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class Donate extends StatefulWidget {
  String userId;
  String description;
  String eventTitle;
  String docId;
  int goal;
  Function updateTemp;
  int index;
  Donate(this.userId, this.description, this.eventTitle, this.docId, this.goal,this.updateTemp,this.index);

  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  final paymentController = TextEditingController();
  Map<String, dynamic> paymentIntentData;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Container(
              height: 150,
              width: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/DONAID.jpg',
                      ),
                      fit: BoxFit.fill)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  
                  Expanded(child: 
                  Text('${widget.eventTitle}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      )),),
                ],
              ),
            ),
            
            SizedBox(height: 40),
            widget.description != null
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Description: ',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(child: 
                        Text('${widget.description}',
                            style: TextStyle(
                              fontSize: 22,
                            )),),
                      ],
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 40),
            widget.goal != null
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Goal : \$',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('${widget.goal}',
                            style: TextStyle(
                              fontSize: 22,
                            ))
                      ],
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 50,
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (val) => val.isEmpty ? 'Enter Amount' : null,
                decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
                controller: paymentController,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.red[100])),
                onPressed: () async {
                  print('Button Pressed');
                  await makePayment();
                },
                child: Text('Donate',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 22,
                        fontWeight: FontWeight.bold))),
                        SizedBox(height: 30),
              Container(
              height: 100,
              width: 500,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/stripe1.png',
                      ),
                      )),
            ),      
          ],
        ),
        
      ),
    );
  }

  /*
  Future<void> makePayment() async {
   // final url = Uri.parse(
       // 'https://us-central1-donaid-3fd93.cloudfunctions.net/stripePayment');
    final url = Uri.parse('http://192.168.100.82:3000/payment');
    final queryParameters = {"amount": "${paymentController.text}"};
    final response = await http.get(
        Uri.http('192.168.100.82:3000', '/payment', queryParameters),
         headers: {'Content-Type': 'application/json'});
    // final response =
    // await http.get(url, headers: {'Content-Type': 'application/json'});
    // paymentIntentData = json.decode(response.body);
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData['paymentIntent'],
            applePay: true,
            googlePay: true,
            style: ThemeMode.dark,
            merchantCountryCode: 'US',
            merchantDisplayName: 'DONAID'));
    setState(() {
      displayPaymentSheet();
    });
  }
  */

  Future<void> makePayment() async {
    // final url = Uri.parse(
    //     'https://us-central1-donaid-3fd93.cloudfunctions.net/stripePayment');
    print('Amount is ${widget.eventTitle}');
    int amount = int.parse(paymentController.text) * 100;
    final queryParameters = {"amount": "${amount.toString()}"};
    print('Amoutn is $amount');
    final response = await http.get(
        Uri.https('donaidapp.herokuapp.com', '/payment', queryParameters),
        headers: {'Content-Type': 'application/json'});
    print(response);
    paymentIntentData = json.decode(response.body);
    print(paymentIntentData);
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData['paymentIntent'],
            applePay: true,
            googlePay: true,
            style: ThemeMode.dark,
            merchantCountryCode: 'US',
            merchantDisplayName: 'DONAID'));
    setState(() {
      displayPaymentSheet();
    });
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
              clientSecret: paymentIntentData['paymentIntent'],
              confirmPayment: true));
      setState(() {
        //paymentIntentData = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Payment Successful'),
      ));

      if (widget.goal != null) {
        int newGoal = widget.goal - int.parse(paymentController.text);

        print('New Goal is $newGoal');
        print('Doc id is ${widget.docId}');
        await FirebaseFirestore.instance
            .collection("Events")
            .doc(widget.docId)
            .update({"goal": newGoal}).then((value) => print('Successfull'));
            if(widget.index!=null)
            {
            setState(() {
              widget.goal = newGoal;
                        });
        widget.updateTemp(widget.index,newGoal);
            }
      }
      DateTime date = DateTime.now();
      await FirebaseFirestore.instance.collection('donations').add({
        "userId": widget.userId,
        "eventTitle": widget.eventTitle,
        "donation": paymentController.text,
        "donatedAt": date
      });
    } catch (e) {
      print(e);
    }
  }
}
