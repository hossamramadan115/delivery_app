import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/Admin/orde_status.dart';
import 'package:delivery/constsnt.dart';
import 'package:delivery/services/database_service.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:flutter/material.dart';

class OrderAdmin extends StatefulWidget {
  const OrderAdmin({super.key});

  @override
  State<OrderAdmin> createState() => _OrderAdminState();
}

class _OrderAdminState extends State<OrderAdmin> {
  Stream? orderStream;

  getOnTheLoad() async {
    orderStream = await DatabaseMethods().getAdminOrders();
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kMostUse,
        body: Column(
          children: [
            SizedBox(height: context.screenHeight * 0.03),
            Center(
              child: Text(
                'Add package',
                style: AppStyless.styleWhiteBold22,
              ),
            ),
            SizedBox(height: context.screenHeight * .015),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  color: kPrimaryColor,
                  width: context.screenWidth,
                  child: orderStream == null
                      ? const Center(child: CircularProgressIndicator())
                      : StreamBuilder(
                          stream: orderStream,
                          builder: (context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            return ListView.builder(
                              padding:
                                  EdgeInsets.only(top: 24, left: 16, right: 16),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds = snapshot.data.docs[index];

                                return OrdeStatus(
                                  dropoffAddress: ds["DropoffAddress"],
                                  dropoffPhone: ds["DropoffPhone"],
                                  dropoffUserName: ds["DropoffUserName"],
                                  pickupAddress: ds["PickupAddress"],
                                  pickupPhone: ds["PickupPhone"],
                                  pickupUserName: ds["PickupUserName"],
                                  price: ds["Price"],
                                  tracker: ds["Tracker"],
                                  button1: () async {
                                    int updateTraker = ds["Tracker"];
                                    updateTraker = updateTraker + 1;

                                    await DatabaseMethods().updateOrderTracker(
                                      ds.id,
                                      updateTraker,
                                    );
                                    await DatabaseMethods().updateUserTracker(
                                        ds["UserId"],
                                        updateTraker,
                                        ds["OrderId"]);
                                  },
                                  button2: () async {
                                    int updateTraker = ds["Tracker"];
                                    updateTraker = updateTraker + 1;

                                    await DatabaseMethods().updateOrderTracker(
                                      ds.id, // orderId (زي ORD-ko7OS3cT)
                                      updateTraker, // القيمة الجديدة
                                    );
                                    await DatabaseMethods().updateUserTracker(
                                        ds["UserId"],
                                        updateTraker,
                                        ds["OrderId"]);
                                  },
                                  button3: () async {
                                    int updateTraker = ds["Tracker"];
                                    updateTraker = updateTraker + 1;

                                    await DatabaseMethods().updateOrderTracker(
                                      ds.id,
                                      updateTraker,
                                    );
                                    await DatabaseMethods().updateUserTracker(
                                        ds["UserId"],
                                        updateTraker,
                                        ds["OrderId"]);
                                  },
                                  button4: () async {
                                    int updateTraker = ds["Tracker"];
                                    updateTraker = updateTraker + 1;

                                    await DatabaseMethods().updateOrderTracker(
                                      ds.id,
                                      updateTraker,
                                    );
                                    await DatabaseMethods().updateUserTracker(
                                        ds["UserId"],
                                        updateTraker,
                                        ds["OrderId"]);
                                  },
                                  button5: () async {
                                    int updateTraker = ds["Tracker"];
                                    updateTraker = updateTraker + 1;

                                    await DatabaseMethods().updateOrderTracker(
                                      ds.id,
                                      updateTraker,
                                    );
                                    await DatabaseMethods().updateUserTracker(
                                        ds["UserId"],
                                        updateTraker,
                                        ds["OrderId"]);
                                  },
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
