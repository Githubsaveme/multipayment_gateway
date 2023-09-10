import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:multipayment_gateway/Model/model.dart';
import 'package:multipayment_gateway/ToastMessage/toastMessage.dart';
import 'package:multipayment_gateway/UI/orderScreen/orderScreen.dart';
import 'package:payumoney_sdk/payumoney_sdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final payu = PayumoneySdk();
  final razorpay = Razorpay();
  final dio = Dio();

  ProductModel? productModelSelect;
  List<ProductModel> productModelList = [];

  @override
  void initState() {
    request();
    super.initState();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Container(
        height: size.width * 0.2,
        decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.05),
                topRight: Radius.circular(size.width * 0.05))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.red.withOpacity(0.03))),
              onPressed: () {
                startPaymentPayu(productModelSelect!);
              },
              icon: const Icon(Icons.payments),
              label: const Text("Payu"),
            ),
            ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.red.withOpacity(0.03))),
              onPressed: () {
                startPaymentWithRazorPay(productModelSelect!);
                debugPrint('razorPay');
              },
              icon: const Icon(Icons.payments),
              label: const Text("Razorpay"),
            ),

            ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStatePropertyAll(Colors.red.withOpacity(0.03))),
              onPressed: () {
                startPaymentWithRazorPay(productModelSelect!);
                debugPrint('Stripe');
              },
              icon: const Icon(Icons.payments),
              label: const Text("Stripe"),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Product Screen',
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: size.width * 0.04),
        ),
        centerTitle: true,
        backgroundColor: Colors.red.withOpacity(0.2),
        actions: [
          CircleAvatar(
              backgroundColor: Colors.red,
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  )))
        ],
      ),
      body: productModelList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.width * 0.02),
                  homeScreenWidget(size),
                  SizedBox(height: size.width * 0.02),
                ],
              ),
            ),
    );
  }

  Widget homeScreenWidget(size) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 4,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: productModelList.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              int pos =
                  productModelList.indexWhere((element) => element.isSelected);

              if (pos >= 0) {
                productModelList[pos].isSelected = false;
              }
              productModelList[index].isSelected = true;

              productModelSelect = productModelList[index];

              setState(() {});
            },
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.02,
                      vertical: size.width * 0.01),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.02,
                      vertical: size.width * 0.02),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                      color: productModelList[index].isSelected
                          ? Colors.red.withOpacity(0.2)
                          : Colors.red),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInImage.assetNetwork(
                          placeholder:
                              ('assets/images/ic_imagePlaceholder.png'),
                          image: productModelList[index].image!),
                      /* CachedNetworkImage(
                  imageUrl: productModelList[index].image!,
                  placeholder: (context, url) =>
                      Image.asset('assets/images/ic_imagePlaceholder.png'),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/ic_imagePlaceholder.png'),
                  */ /*progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),*/ /*
                ),*/
                      Text(
                        productModelList[index].title!,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: size.width * 0.03),
                      ),
                      Text(
                        productModelList[index].description!,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: size.width * 0.03,
                            color: Colors.black),
                      ),
                      Text(
                        productModelList[index].price!,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: size.width * 0.03,
                            color: Colors.black),
                      ),
                      RatingBar.builder(
                        initialRating:
                            double.parse(productModelList[index].rating!),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: size.width * 0.03,
                        glow: true,
                        itemPadding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.002),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          debugPrint(rating.toString());
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                    height: size.width * 0.3,
                    alignment: Alignment.topRight,
                    decoration: BoxDecoration(),
                    child: Stack(
                      children: [
                        Image.asset('assets/images/ic_discount.png',
                            height: size.width * 0.15),
                        Positioned(
                            left: size.width * .04,
                            top: size.width * .06,
                            child: Row(
                              children: [
                                Text(
                                  productModelList[index]
                                      .discountPercentage!
                                      .split(".")
                                      .first
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: size.width * 0.03,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "%",
                                  style: TextStyle(
                                      fontSize: size.width * 0.03,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ))
                      ],
                    )),
              ],
            ));
      },
    );
  }

  void startPaymentPayu(ProductModel productModelSelect) async {
    final data = await payu.buildPaymentParams(
        amount: productModelSelect.price!,
        transactionId: "C216164622455s7",
        phone: "7899395319",
        productInfo: productModelSelect.title!,
        firstName: "vishal kumar",
        email: "vishal@gmail.com",
        hash:
            "2973e780893f5b3ff593cf92891a3763f20a9fb55c84c734d4e317727b75ccbae45d9f0da97e28c4521c03c144335c082c8b6045a296dccb24d1f5bc5063afd9",
        isProduction: false,
        userCredentials: "010101101",
        merchantKey: "mWI8Vl",
        salt: "cMDID7EG",
        merchantName: "Nike Services Pvt Ltd.");

    debugPrint("response_payu:$data");
  }

  void startPaymentWithRazorPay(ProductModel productModelSelect) {
    var options = {
      'key': 'Key here',
      'amount': int.parse(productModelSelect.price!) * 100,
      'name': 'Umbrella Corp.',
      'currency': 'INR',
      'description': productModelSelect.title,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '7888508281', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.open(options);

    debugPrint("razorpay_response:$options");
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showMessage(response.message.toString());

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderScreen(
                  typeofOrder: 'fail',
                  price: productModelSelect != null
                      ? productModelSelect!.price!.toString()
                      : "",
                  name: productModelSelect != null
                      ? productModelSelect!.title!.toString()
                      : "",
                  productStatus: response.message.toString(),
                )));
    setState(() {});
    debugPrint(
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderScreen(
                  typeofOrder: 'success',
                  price: productModelSelect!.price!.toString(),
                  name: productModelSelect!.title!.toString(),
                  productStatus: response.paymentId.toString(),
                )));
    setState(() {});
    showMessage("Payment ID: ${response.paymentId}");
    debugPrint("Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    debugPrint("External Wallet Selected${response.walletName}");
    showMessage("${response.walletName}");
  }

  void request() async {
    Response responseDio;
    responseDio = await dio.get('https://dummyjson.com/products');
    debugPrint(responseDio.data.toString());
    debugPrint("productModelList-length:${productModelList.length}");

    var data = responseDio.data["products"] as List;
    productModelList = data.map((e) => ProductModel.fromJson(e)).toList();
    debugPrint("productModelList-length:${productModelList.length}");
    setState(() {});
  }
}
