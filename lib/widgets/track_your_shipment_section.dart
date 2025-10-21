import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/constsnt.dart';
import 'package:delivery/models/order_model.dart';
import 'package:delivery/services/shared_preferences_helper.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/assets.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/custom_text_form_field.dart';
import 'package:delivery/widgets/order_tracking_widget.dart';
import 'package:delivery/widgets/all_custom_delivers_section.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrackYourShipmentSection extends StatefulWidget {
  const TrackYourShipmentSection({super.key});

  @override
  State<TrackYourShipmentSection> createState() =>
      _TrackYourShipmentSectionState();
}

class _TrackYourShipmentSectionState extends State<TrackYourShipmentSection> {
  final searchController = TextEditingController();
  String? id;

  bool searching = false; // 🔍 لو المستخدم بيبحث حاليًا
  bool hasResult = false; // ✅ لو فيه نتيجة ناجحة

  String? matchAddress;
  String? matchPickup;
  String? matchStatus;
  double? matchPrice;
  String? matchTrackerId;
  int? matchTrackerStep;

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  Future<void> getthesharedpref() async {
    id = await SharedPreferencesHelper().getUserId();
    setState(() {});
  }

  Future<void> ontheload() async {
    await getthesharedpref();
  }

  // ======== البحث عن Tracker داخل Firestore ========
  Future<Map<String, dynamic>?> getMatchedTrackerId(
      String userTrackerId) async {
    try {
      if (id == null) await getthesharedpref();
      if (id == null) return null;

      var querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .collection("Order")
          .where("Track", isEqualTo: userTrackerId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No matching trackerId found.");
        return null;
      }

      var data = querySnapshot.docs.first.data();
      return {
        "dropOffAddress": data["DropoffAddress"],
        "pickUpAddress": data["PickupAddress"],
        "status": data["Status"],
        "price": data["Price"],
        "track": data["Track"].toString(),
        "tracker": data["Tracker"], // 👈 currentStep اللي عايزينه
      };
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<void> _onSearchPressed() async {
    FocusScope.of(context).unfocus(); // 👈 دا اللي بيخفي الكيبورد
    String query = searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a tracker number")),
      );
      return;
    }
    if (!query.startsWith("TRK-")) {
      query = "TRK-$query";
    }

    setState(() {
      searching = true;
      hasResult = false;
    });

    final result = await getMatchedTrackerId(query);

    if (result == null) {
      setState(() {
        searching = false;
        hasResult = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No shipment found.")),
      );
      return;
    }

    setState(() {
      matchAddress = result["dropOffAddress"];
      matchPickup = result["pickUpAddress"];
      matchStatus = result["status"];
      matchTrackerStep = int.tryParse(result["tracker"]?.toString() ?? '0');
      matchPrice = (result["price"] is num)
          ? (result["price"] as num).toDouble()
          : double.tryParse(result["price"].toString()) ?? 0.0;
      matchTrackerId = result["track"];
      hasResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          // ===== قسم البحث =====
          Container(
            height: screenHeight / 2.2,
            decoration: BoxDecoration(
              color: kMostUse,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * .02),
                Text('Track your shipment', style: AppStyless.styleWhiteBold22),
                Text('Please enter your shipment number',
                    style: AppStyless.styleWhiteBold15),
                SizedBox(height: screenHeight * .03),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenHeight * .026),
                  child: CustomTextFormField(
                    controller: searchController,
                    backgroundColor: Colors.white,
                    icon: Icons.track_changes,
                    iconColor: Colors.red,
                    hintText: 'Enter track number',
                    suffixIcon: IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.search,
                        color: Colors.grey,
                        size: 18,
                      ),
                      onPressed: _onSearchPressed,
                    ),
                  ),
                ),
                const Spacer(),
                Image.asset(
                  Assets.kOnHome,
                  height: screenHeight * .25,
                ),
              ],
            ),
          ),

          // ===== لو فيه نتيجة بحث -> اعرض OrderTrackingWidget =====
          if (hasResult && searching)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
              child: OrderTrackingWidget(
                currentStep: matchTrackerStep ?? -1, // تقدر تربطه بالـ status
                order: OrderModel(
                  id: '',
                  track: matchTrackerId ?? "N/A",
                  dropOffAddress: matchAddress ?? "No address",
                  pickUpAddress: matchPickup ?? "Unknown",
                  status: matchStatus ?? "Pending",
                  price: matchPrice ?? 0.0,
                  pickUpUserName: '',
                  pickUpPhone: '',
                  dropOffUserName: '',
                  dropOffPhone: '',
                ),
              ),
            )
          // ===== لو مفيش بحث أو نتيجة -> اعرض AllCustomDeliversSection =====
          else
            Column(
              children: [
                SizedBox(height: context.screenHeight * .03),
                const AllCustomDeliversSection(),
              ],
            ),
        ],
      ),
    );
  }
}










// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:delivery/constsnt.dart';
// import 'package:delivery/services/shared_preferences_helper.dart';
// import 'package:delivery/utils/app_styless.dart';
// import 'package:delivery/utils/assets.dart';
// import 'package:delivery/widgets/custom_text_form_field.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

// class TrackYourShipmentSection extends StatefulWidget {
//   const TrackYourShipmentSection({super.key});

//   @override
//   State<TrackYourShipmentSection> createState() =>
//       _TrackYourShipmentSectionState();
// }

// class _TrackYourShipmentSectionState extends State<TrackYourShipmentSection> {
//   final searchController = TextEditingController();
//   String? id;
//   bool search=false;
//   String ?matchAddress;
//   int?matchTrackerId;
//   String currentAddress="Fetching location...";
//   Position?currentPosition;

//   @override
//   void initState() {
//     super.initState();
//     //  getLocation();
//     ontheload();
//   }

// // Future<void> getLocation() async {
// //   // دالة للحصول على الموقع الحالي (تقدر تضيف كود geolocator هنا)
// // }

//   // دالة لجلب العنوان من الإحداثيات
//   Future<void> _getAddressFromLatLng(Position position) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       Placemark place = placemarks[0];
//       setState(() {
//         currentAddress =
//             "${place.street}, ${place.locality}, ${place.administrativeArea}";
//         // يمكنك تعديل التنسيق حسب ما تفضل
//       });
//     } catch (e) {
//       setState(() {
//         currentAddress = "Error fetching address.";
//       });
//     }


//    getthesharedpref() async {
//     id = await SharedPreferencesHelper().getUserId();
//     setState(() {});
//   }

//   Future<void> ontheload() async {
//     await getthesharedpref();
//   }

//   Future<Map<String, dynamic>?> getMatchedTrackerId(
//       String userTrackerId) async {
//     try {
//       // 🔍 Query Firestore where the tracker ID matches the user input
//       var querySnapshot = await FirebaseFirestore.instance
//           .collection("users")
//           .doc(id) // 👈 استبدلها بـ ID المستخدم أو المسار الصحيح
//           .collection("Order")
//           .where("Track", isEqualTo: userTrackerId)
//           .get();

//       if (querySnapshot.docs.isEmpty) {
//         print("No matching trackerId found.");
//         return null; // لا يوجد أي tracker مطابق
//       }

//       // ✅ إذا وُجدت نتائج
//       for (var doc in querySnapshot.docs) {
//         var data = doc.data();

//         // 🔍 التحقق من الحقول التي تحتوي على tracker
//         for (var field in ["Track"]) {
//           if (data.containsKey(field) && data[field] == userTrackerId) {
//             // ✅ وجدنا تطابق
//             var matchedAddress = data["DropoffAddress"] ?? "No address found";
//             var matchedTrackerId = data["Tracker"];

//             print("Matched Address: $matchedAddress");
//             print("Matched Tracker ID: $matchedTrackerId");

//             // ترجع عنوان وتسلسل التتبع معاً
//             return {
//               "address": matchedAddress,
//               "tracker": matchedTrackerId,
//             };
//           }
//         }
//       }

//       print("No field matched the tracker ID.");
//       return null; // لا يوجد تطابق
//     } catch (e) {
//       print("Error: $e");
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Container(
//       width: screenWidth,
//       height: screenHeight / 2.2,
//       decoration: BoxDecoration(
//         color: kMostUse,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: screenHeight * .02),
//           Text(
//             'Track your shipment',
//             style: AppStyless.styleWhiteBold22,
//           ),
//           Text(
//             'Please enter your shipment number',
//             style: AppStyless.styleWhiteBold15,
//           ),
//           SizedBox(height: screenHeight * .03),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: screenHeight * .026),
//             child: CustomTextFormField(
//               controller: searchController,
//               backgroundColor: Colors.white,
//               icon: Icons.track_changes,
//               iconColor: Colors.red,
//               hintText: 'Enter track number',
//               suffixIcon: GestureDetector(
//                 onTap: ()async {
//                   await getmafi
//                 },
//                 child: Icon(
//                   FontAwesomeIcons.search,
//                   color: Colors.grey,
//                   size: 18,
//                 ),
//               ),
//             ),
//           ),
//           Spacer(),
//           Image.asset(
//             Assets.kOnHome,
//             height: screenHeight * .25,
//           )
//         ],
//       ),
//     );
//   }
// }
