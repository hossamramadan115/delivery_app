import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/constsnt.dart';
import 'package:delivery/models/order_model.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/order_toggle_button.dart';
import 'package:delivery/widgets/order_tracking_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool isCurrent = true;
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              color: kMostUse,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 3 / 4,
              color: kPrimaryColor,
            ),
          ),
          Column(
            children: [
              SizedBox(height: context.screenHeight * .04),
              Text("Orders",
                  style: AppStyless.styleBold28.copyWith(color: Colors.white)),
              SizedBox(height: context.screenHeight * .03),
              Container(
                height: context.screenHeight * .8,
                margin:
                    EdgeInsets.symmetric(horizontal: context.screenWidth * .04),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 249, 247, 247),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6),
                  ],
                ),
                child: Column(
                  children: [
                    /// 🔹 زرار التبديل
                    OrderToggleButton(
                      isCurrent: isCurrent,
                      onToggle: (bool newIsCurrent) {
                        setState(() {
                          isCurrent = newIsCurrent;
                        });
                      },
                    ),

                    /// 🔹 StreamBuilder
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Order")
                            // .orderBy("CreatedAt", descending: true)
                            .where("Email", isEqualTo: userEmail)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                isCurrent
                                    ? "No current orders."
                                    : "No previous orders.",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            );
                          }

                          final docs = snapshot.data!.docs;

                          final orders = docs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return OrderModel(
                              track: data["Track"] ?? "",
                              id: doc.id,
                              orderNumber: data["OrderId"] ?? "",
                              pickUpAddress: data["PickupAddress"] ?? "",
                              pickUpUserName: data["PickupUserName"] ?? "",
                              pickUpPhone: data["PickupPhone"] ?? "",
                              dropOffAddress: data["DropoffAddress"] ?? "",
                              dropOffUserName: data["DropoffUserName"] ?? "",
                              dropOffPhone: data["DropoffPhone"] ?? "",
                              price: (data["Price"] ?? 0).toDouble(),
                              tracker: data["Tracker"] ?? -1,
                              createdAt: data["CreatedAt"] != null
                                  ? (data["CreatedAt"] is Timestamp
                                      ? (data["CreatedAt"] as Timestamp)
                                          .toDate()
                                      : DateTime.tryParse(
                                          data["CreatedAt"].toString()))
                                  : null,
                              status: (data["Status"] ?? "Pending").toString(),
                            );
                          }).toList();

                          /// ✅ فلترة الأوردرات
                          final listToShow = isCurrent
                              ? orders.where((o) => o.tracker < 3).toList()
                              : orders.where((o) => o.tracker >= 3).toList();

                          if (listToShow.isEmpty) {
                            return Center(
                              child: Text(
                                isCurrent
                                    ? "No current orders."
                                    : "No previous orders.",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: listToShow.length,
                            itemBuilder: (context, index) {
                              final o = listToShow[index];
                              return OrderTrackingWidget(
                                order: o,
                                currentStep: o.tracker,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
