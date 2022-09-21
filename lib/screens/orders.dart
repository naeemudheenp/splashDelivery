import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = 'OrdersScreen';
  OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _orderTaken = false;
  bool _scanQR = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: ListView(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (_, index) => Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: .8,
                        //  spreadRadius: 0.1,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 16,
                      ),
                      child: Text("Name"),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Address"),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: Text("Phone Number"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //Scanning button only appears if Order is accepted
                          if (_orderTaken == true)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: _orderTaken
                                      ? Colors.blueGrey[400]
                                      : Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              onPressed: () {
                                setState(() {
                                  _orderTaken = _scanQR ? true : false;
                                  _scanQR = true;
                                  //  _orderTaken = !_orderTaken;
                                  /* _orderTaken
                                    ? Colors.blueAccent
                                    : Colors.green, */
                                });
                              },
                              child: const Text('Scan QR'),
                            ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: _orderTaken
                                    ? Colors.blueAccent
                                    : Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                            onPressed: () {
                              setState(() {
                                _orderTaken = !_orderTaken;
                                _scanQR = true;
                                //  _orderTaken = !_orderTaken;
                                /* _orderTaken
                                    ? Colors.blueAccent
                                    : Colors.green, */
                              });
                            },
                            child: Text(_orderTaken ? 'Delivered' : "Accept"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              itemCount: 1,
            )
          ],
        ),
      ),
    );
  }
}
