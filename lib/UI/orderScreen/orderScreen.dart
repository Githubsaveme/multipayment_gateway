import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OrderScreen extends StatefulWidget {
  final String typeofOrder;
  final String name;
  final String price;
  final String productStatus;

  const OrderScreen(
      {super.key,
      required this.typeofOrder,
      required this.price,
      required this.name,
      required this.productStatus});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    debugPrint("class: $runtimeType");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Order Screen"),
        ),
        body: Column(
          children: [
            widget.typeofOrder == "success"
                ? orderSuccess(size)
                : orderCancel(size),
          ],
        ));
  }

  Widget orderSuccess(size) {
    return Container(
      child: Column(
        children: [Lottie.asset('assets/lottie/lottie_success.json')],
      ),
    );
  }

  Widget orderCancel(size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Lottie.asset('assets/lottie/lottie_failed.json')),
        widget.productStatus.isNotEmpty
            ? Container(
                margin: EdgeInsets.zero,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.2)),
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02, vertical: size.width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Details",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: size.width * 0.035),
                    ),
                    widget.name.isNotEmpty
                        ? Row(
                            children: [
                              Text(
                                "Product Name :",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: size.width * 0.035),
                              ),
                              Expanded(
                                child: Text(
                                  widget.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: size.width * 0.035),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    widget.price.isNotEmpty
                        ? Row(
                            children: [
                              Text(
                                "Price :",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: size.width * 0.035),
                              ),
                              Text(
                                widget.price,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: size.width * 0.035),
                              ),
                            ],
                          )
                        : Container(),
                    Row(
                      children: [
                        Text(
                          "productStatus :",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: size.width * 0.035),
                        ),
                        Expanded(
                          child: Text(
                            widget.productStatus,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: size.width * 0.035),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Container()
      ],
    );
  }
}
