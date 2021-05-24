import 'package:my_cust/constants.dart';
import 'package:my_cust/screens/product_page.dart';
import 'package:my_cust/services/firebase_services.dart';
import 'package:my_cust/widgets/custom_action_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_cust/widgets/custom_btn.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  FirebaseServices _firebaseServices = FirebaseServices();
  Razorpay razorpay;

  @override
  void initState() {
    super.initState();

    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }


  void openCheckout() {
    var options = {
      'key': 'rzp_test_1TFFh7whyqz6Br',
      'amount': '100',

      'description': 'Pay',
    };

    try {
      razorpay.open(options);
    } catch(e) {
      //debugPrint(e);

      print(e.toString());
    }

  }

  void _handlePaymentSuccess() {
    print("Payment Successful");
  }

  void _handlePaymentError() {
    print("Payment Error");
  }

  void _handleExternalWallet() {
    print("External Wallet");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Cart").get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              // Collection Data ready to display
              if (snapshot.connectionState == ConnectionState.done) {
                // Display the data inside a list view
                return ListView(
                  padding: EdgeInsets.only(
                    top: 108.0,
                    bottom: 12.0,
                  ),
                  children: snapshot.data.docs.map((document) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ProductPage(productId: document.id,),
                        ));
                      },
                      child: FutureBuilder(
                        future: _firebaseServices.productsRef.doc(document.id).get(),
                        builder: (context, productSnap) {
                          if(productSnap.hasError) {
                            return Container(
                              child: Center(
                                child: Text("${productSnap.error}"),
                              ),
                            );
                          }

                          if(productSnap.connectionState == ConnectionState.done) {
                            Map _productMap = productSnap.data.data();

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 24.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(8.0),
                                      child: Image.network(
                                        "${_productMap['images'][0]}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 16.0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${_productMap['name']}",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: Text(
                                            "\Rs.${_productMap['price']}",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Theme.of(context)
                                                    .accentColor,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                        ),
                                        Text(
                                          "Quantity - ${document.data()['size']}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                              /*
                              Container(
                                child: Column(
                                  children: [
                                    CustomBtn(
                                      text: "Pay",
                                    )
                                  ],
                                ),
                              ),*/
                                ],
                              ),
                            );

                          }


                          return Container();


                        },
                      ),
                    );
                  }).toList(),
                );

              }

              // Loading State

              /*
              return Row(
                children: [
                  CustomBtn(
                    text: "Pay",
                  ),
                ],
              );

               */

              return Scaffold(
                body: Center(

                  child: CircularProgressIndicator(),
                ),
              );

              /*return Scaffold(
                body: SingleChildScrollView(
                  child: SafeArea(
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CustomBtn(
                                text: "Edit Order",
                              ),
                            ],
                          ),
                        ],
                          ),
                      ),

                    ),
                  ),
                  */

                  /*
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Container(
                              width: 150.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              alignment: Alignment.center,
                              child: CustomBtn(
                                text: "Edit Order",
                              ),
                            ),
                          ),
                          Expanded(
                              child: GestureDetector(
                                child: Container(
                                  width: 100.0,
                                  height: 65.0,
                                  child: CustomBtn(
                                    text: "Pay",
                                  ),
                                ),
                              )),
                        ],
                    ),

                  ),*/

              //),
            },
          ),
          /*
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0, 0),
                  end: Alignment(0, 1),
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0),
                  ],
                )
            ),
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 42.0,
                    height: 42.0,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    child: CustomBtn(
                      text: "Edit Order",
                      onPressed: () {},
                    ),
                    /*Text(
                    "Edit Order",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    ),
                    */
                    ),
                  ),
              ],
            ),
          ),

          */


          /*
          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 70.0,
                    height: 42.0,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Edit Order",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          */

          Positioned(
              bottom: 30.0,
              left: 190.0,
              child: Container(
                width: 180.0,
                height: 80.0,
                //width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(8),
                child: CustomBtn(
                  text: "Pay",
                  onPressed: () {
                    openCheckout();
                  },
                ),
              ),
          ),

          Positioned(
            bottom: 30.0,

              child: Container(
                width: 230.0,
                height: 80.0,
                padding: EdgeInsets.all(8),
                child: CustomBtn(
                  text: "Edit Order",
                ),
              ),
          ),

          CustomActionBar(
            hasBackArrrow: true,
            title: "Confirm Order",
          )
        ],
      ),
    );
  }
}
