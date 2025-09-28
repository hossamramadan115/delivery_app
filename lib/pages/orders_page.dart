import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/constsnt.dart';
import 'package:delivery/models/order.dart';
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
                              id: doc.id,
                              orderNumber: data["OrderId"] ?? "",
                              pickUpAddress: data["PickupAddress"] ?? "",
                              pickUpUserName: data["PickupUserName"] ?? "",
                              pickUpPhone: data["PickupPhone"] ?? "",
                              dropOffAddress: data["DropoffAddress"] ?? "",
                              dropOffUserName: data["DropoffUserName"] ?? "",
                              dropOffPhone: data["DropoffPhone"] ?? "",
                              price: (data["Price"] ?? 0).toDouble(),
                              currentStep: data["CurrentStep"] ?? 0,
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
                              ? orders
                                  .where((o) =>
                                      o.status.toLowerCase() == "pending" ||
                                      o.status.toLowerCase() == "paid")
                                  .toList()
                              : orders
                                  .where((o) =>
                                      o.status.toLowerCase() == "completed")
                                  .toList();

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
                            itemCount: listToShow.length,
                            itemBuilder: (context, index) {
                              final o = listToShow[index];
                              return OrderTrackingWidget(
                                order: o,
                                currentStep: o.currentStep ?? 0,
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

// import 'package:delivery/constsnt.dart';
// import 'package:delivery/models/order.dart';
// import 'package:delivery/services/order_repository.dart';
// import 'package:delivery/utils/app_styless.dart';
// import 'package:delivery/utils/media_query_values.dart';
// import 'package:delivery/widgets/current_order_card.dart';
// import 'package:delivery/widgets/order_tracking_widget.dart';
// import 'package:delivery/widgets/order_toggle_button.dart';
// import 'package:flutter/material.dart';

// class OrdersPage extends StatefulWidget {
//   const OrdersPage({super.key});

//   @override
//   State<OrdersPage> createState() => _OrdersPageState();
// }

// class _OrdersPageState extends State<OrdersPage> {
//   bool isCurrent = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Align(
//             alignment: Alignment.topCenter,
//             child: Container(
//               height: MediaQuery.of(context).size.height / 4,
//               color: kMostUse,
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: MediaQuery.of(context).size.height * 3 / 4,
//               color: kPrimaryColor,
//             ),
//           ),
//           Column(
//             children: [
//               SizedBox(height: context.screenHeight * .04),
//               Text(
//                 "Orders",
//                 style: AppStyless.styleBold28.copyWith(color: Colors.white),
//               ),
//               SizedBox(height: context.screenHeight * .03),
//               Container(
//                 height: context.screenHeight * .8,
//                 margin:
//                     EdgeInsets.symmetric(horizontal: context.screenWidth * .04),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 249, 247, 247),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 6,
//                     ),
//                   ],
//                 ),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // 🔹 زرار التبديل
//                       OrderToggleButton(
//                         isCurrent: isCurrent,
//                         onToggle: (bool newIsCurrent) {
//                           setState(() {
//                             isCurrent = newIsCurrent;
//                           });
//                         },
//                       ),

//                       ValueListenableBuilder<List<Order>>(
//                         valueListenable: OrderRepository.instance.orders,
//                         builder: (context, orders, _) {
//                           final currentOrders = orders
//                               .where((o) => o.status != 'completed')
//                               .toList();
//                           final previousOrders = orders
//                               .where((o) => o.status == 'completed')
//                               .toList();

//                           final listToShow =
//                               isCurrent ? currentOrders : previousOrders;

//                           if (listToShow.isEmpty) {
//                             return Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Text(
//                                 isCurrent
//                                     ? "No current orders."
//                                     : "No previous orders to show.",
//                                 style: const TextStyle(
//                                     fontSize: 16, color: Colors.grey),
//                               ),
//                             );
//                           }

//                           // 👇 عرض كل Order ومعاه Tracking خاص بيه
//                           return Column(
//                             children: [
//                               for (var o in listToShow) ...[
//                                 CurrentOrderCard(order: o),
//                                 OrderTrackingWidget(
//                                   currentStep: o.currentStep??0,
//                                 ),
//                                 const SizedBox(height: 16),
//                               ]
//                             ],
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
// import 'package:delivery/constsnt.dart';
// import 'package:delivery/models/order.dart';
// import 'package:delivery/utils/app_styless.dart';
// import 'package:delivery/utils/media_query_values.dart';
// import 'package:delivery/widgets/current_order_card.dart';
// import 'package:delivery/widgets/order_item_card.dart';
// import 'package:delivery/widgets/order_tracking_widget.dart';
// import 'package:delivery/widgets/order_toggle_button.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class OrdersPage extends StatefulWidget {
//   const OrdersPage({super.key});

//   @override
//   State<OrdersPage> createState() => _OrdersPageState();
// }

// class _OrdersPageState extends State<OrdersPage> {
//   bool isCurrent = true;

//   final String? userEmail = FirebaseAuth.instance.currentUser?.email;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Align(
//             alignment: Alignment.topCenter,
//             child: Container(
//               height: MediaQuery.of(context).size.height / 4,
//               color: kMostUse,
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: MediaQuery.of(context).size.height * 3 / 4,
//               color: kPrimaryColor,
//             ),
//           ),
//           Column(
//             children: [
//               SizedBox(height: context.screenHeight * .04),
//               Text(
//                 "Orders",
//                 style: AppStyless.styleBold28.copyWith(color: Colors.white),
//               ),
//               SizedBox(height: context.screenHeight * .03),
//               Container(
//                 height: context.screenHeight * .8,
//                 margin:
//                     EdgeInsets.symmetric(horizontal: context.screenWidth * .04),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 249, 247, 247),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 6,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     /// 🔹 زرار التبديل
//                     OrderToggleButton(
//                       isCurrent: isCurrent,
//                       onToggle: (bool newIsCurrent) {
//                         setState(() {
//                           isCurrent = newIsCurrent;
//                         });
//                       },
//                     ),

//                     /// 🔹 StreamBuilder للـ Firebase
//                     Expanded(
//                       child: StreamBuilder<QuerySnapshot>(
//                         stream: FirebaseFirestore.instance
//                             .collection("Order") // ✅ اتأكد إنها Orders
//                             .where("Email",
//                                 isEqualTo: userEmail) // ✅ اتأكد من الـ case
//                             .snapshots(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Center(
//                                 child: CircularProgressIndicator());
//                           }

//                           if (!snapshot.hasData ||
//                               snapshot.data!.docs.isEmpty) {
//                             return Center(
//                               child: Text(
//                                 isCurrent
//                                     ? "No current orders."
//                                     : "No previous orders.",
//                                 style: const TextStyle(
//                                     fontSize: 16, color: Colors.grey),
//                               ),
//                             );
//                           }

//                           final docs = snapshot.data!.docs;

//                           final orders = docs.map((doc) {
//                             final data = doc.data() as Map<String, dynamic>;
//                             return OrderModel(
//                               id: doc.id,
//                               orderNumber: data["OrderId"] ?? "",
//                               pickUpAddress: data["PickupAddress"] ?? "",
//                               pickUpUserName: data["PickupUserName"] ?? "",
//                               pickUpPhone: data["PickupPhone"] ?? "",
//                               dropOffAddress: data["DropoffAddress"] ?? "",
//                               dropOffUserName: data["DropoffUserName"] ?? "",
//                               dropOffPhone: data["DropoffPhone"] ?? "",
//                               price: (data["Price"] ?? 0).toDouble(),
//                               currentStep: data["CurrentStep"] ?? 0,
//                               createdAt: data["CreatedAt"] != null
//                                   ? (data["CreatedAt"] is Timestamp
//                                       ? (data["CreatedAt"] as Timestamp)
//                                           .toDate()
//                                       : DateTime.tryParse(
//                                           data["CreatedAt"].toString()))
//                                   : null, // ✅ تعديل
//                               status: (data["Status"] ?? "Pending").toString(),
//                             );
//                           }).toList();

//                           /// ✅ فلترة الأوردرات حسب الحالة
//                           final listToShow = isCurrent
//                               ? orders
//                                   .where((o) =>
//                                       o.status.toLowerCase() == "pending" ||
//                                       o.status.toLowerCase() == "paid")
//                                   .toList()
//                               : orders
//                                   .where(
//                                     (o) =>
//                                         o.status.toLowerCase() == "completed",
//                                   )
//                                   .toList();

//                           if (listToShow.isEmpty) {
//                             return Center(
//                               child: Text(
//                                 isCurrent
//                                     ? "No current orders."
//                                     : "No previous orders.",
//                                 style: const TextStyle(
//                                     fontSize: 16, color: Colors.grey),
//                               ),
//                             );
//                           }

//                           return ListView.builder(
//                             itemCount: listToShow.length,
//                             itemBuilder: (context, index) {
//                               final o = listToShow[index];
//                               return OrderItemCard(order: o);
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
