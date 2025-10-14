import 'package:delivery/constsnt.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/track_your_shipment_section.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:delivery/services/shared_preferences_helper.dart'; // ✅ علشان نخزّن العنوان

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentAddress = "Getting location...";
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    loadSavedOrFetchLocation();
  }

  /// ✅ أولاً: نحاول نجيب العنوان المخزَّن، لو مش موجود نجيب اللوكيشن الحقيقي
  Future<void> loadSavedOrFetchLocation() async {
    final prefs = SharedPreferencesHelper();
    final savedAddress = await prefs.getSavedLocation();

    if (savedAddress != null && savedAddress.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        currentAddress = savedAddress;
      });
    } else {
      getLocation(); // مفيش عنوان محفوظ → نجيب اللوكيشن الجديد
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];
      final address =
          '${place.street}, ${place.locality}, ${place.administrativeArea}';

      if (!mounted) return;
      setState(() {
        currentAddress = address;
      });

      // ✅ نحفظ العنوان في SharedPreferences
      await SharedPreferencesHelper().saveLocation(address);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        currentAddress = "Error fetching address.";
      });
    }
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      setState(() {
        currentAddress = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        setState(() {
          currentAddress = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      setState(() {
        currentAddress = "Location permissions are permanently denied.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (!mounted) return;
    setState(() {
      currentPosition = position;
    });

    _getAddressFromLatLng(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: context.screenHeight * 0.04, right: 16, left: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.locationDot, color: kMostUse),
                  const SizedBox(width: 10),
                  Text('Current location', style: AppStyless.styleBold18),
                ],
              ),
              Text(
                currentAddress.length > 60
                    ? '${currentAddress.substring(0, 60)}...'
                    : currentAddress,
                style: AppStyless.styleBold28.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.screenHeight * .015),
              TrackYourShipmentSection(),
              SizedBox(height: context.screenHeight * .08),
            ],
          ),
        ),
      ),
    );
  }
}
