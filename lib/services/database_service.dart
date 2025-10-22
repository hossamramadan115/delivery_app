import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  Future<void> addUserDetails(
      Map<String, dynamic> userInfoMap, String id) async {
    try {
      await usersCollection.doc(id).set(userInfoMap);
    } catch (e) {
      throw "Error saving user data: $e";
    }
  }

  Future<DocumentSnapshot> getUserDetails(String id) async {
    try {
      return await usersCollection.doc(id).get();
    } catch (e) {
      throw "Error fetching user data: $e";
    }
  }

  Future<DocumentSnapshot?> getUserByEmail(String email) async {
    try {
      final snapshot =
          await usersCollection.where("email", isEqualTo: email).get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first;
      }
      return null;
    } catch (e) {
      throw "Error fetching user by email: $e";
    }
  }

  // ================== من الصورة ==================
  Future<void> addUserOrder(
      Map<String, dynamic> userInfoMap, String id, String orderid) async {
    try {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .collection("Order")
          .doc(orderid)
          .set(userInfoMap);
    } catch (e) {
      throw "Error saving user order: $e";
    }
  }

  Future<void> addAdminOrder(
      Map<String, dynamic> userInfoMap, String id) async {
    try {
      return await FirebaseFirestore.instance
          .collection("Order")
          .doc(id)
          .set(userInfoMap);
    } catch (e) {
      throw "Error saving admin order: $e";
    }
  }

  Future<Stream<QuerySnapshot>> getAdminOrders() async {
    return await FirebaseFirestore.instance
        .collection("Order")
        .where("Status", isEqualTo: "Accepted")
        .snapshots();
  }

  Future<void> updateOrderTracker(String orderId, int updateTracker) async {
    try {
      await FirebaseFirestore.instance
          .collection("Order")
          .doc(orderId)
          .update({"Tracker": updateTracker});
    } catch (e) {
      throw "Error updating order tracker: $e";
    }
  }

  Future<void> updateUserTracker(
      String id, int updateTracker, String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .collection("Order")
          .doc(orderId)
          .update({"Tracker": updateTracker});
    } catch (e) {
      throw "Error updating order tracker: $e";
    }
  }


  // ✅ تحديث حالة الطلب (Pending → Accepted / Rejected)
Future<void> updateOrderStatus(String orderId, String newStatus) async {
  try {
    await FirebaseFirestore.instance
        .collection("Order")
        .doc(orderId)
        .update({"Status": newStatus});
  } catch (e) {
    throw "Error updating order status: $e";
  }
}

// ✅ جلب الطلبات الـ Pending للأدمن
Stream<QuerySnapshot> getPendingOrders() {
  try {
    return FirebaseFirestore.instance
        .collection("Order")
        .where("Status", isEqualTo: "Pending")
        .snapshots();
  } catch (e) {
    throw "Error getting pending orders: $e";
  }
}


  Future<void> deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Order")
          .doc(orderId)
          .delete();
    } catch (e) {
      throw "Error deleting order: $e";
    }
  }


  Future<void> deleteUser(String id) async {
    try {
      await usersCollection.doc(id).delete();
    } catch (e) {
      throw "Error deleting user: $e";
    }
  }

}
