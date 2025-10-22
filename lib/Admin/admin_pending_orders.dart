import 'package:delivery/Admin/pending_order_card.dart';
import 'package:delivery/constsnt.dart';
import 'package:delivery/services/database_service.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPendingOrdersPage extends StatelessWidget {
  const AdminPendingOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseMethods();

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kMostUse,
        title: Text('Pending Orders', style: AppStyless.styleWhiteBold22),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Order")
            .where("Status", isEqualTo: "Pending")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No pending orders",
                  style: TextStyle(color: Colors.white)),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final orderId = docs[index].id;

              return PendingOrderCard(
                data: data,
                orderId: orderId,
                onAccept: () async =>
                    await db.updateOrderStatus(orderId, "Accepted"),
                onReject: () async =>
                    await db.updateOrderStatus(orderId, "Rejected"),
              );
            },
          );
        },
      ),
    );
  }
}
