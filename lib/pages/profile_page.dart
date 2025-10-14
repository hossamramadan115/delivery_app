import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/constsnt.dart';
import 'package:delivery/helper/show_custom_dialog.dart';
import 'package:delivery/services/auth_service.dart';
import 'package:delivery/services/database_service.dart';
import 'package:delivery/services/image_upload_service.dart';
import 'package:delivery/services/shared_preferences_helper.dart';
import 'package:delivery/utils/app_router.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/assets.dart';
import 'package:delivery/widgets/custom_list_tile.dart';
import 'package:delivery/widgets/custom_whats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? image, name, email, id;
  File? selectedImage;
  bool isLoading = false;
  bool isLoadingData = true; // ✅ عشان نعرف هل البيانات لسه بتتحمل

  @override
  void initState() {
    super.initState();
    getTheSharedPref();
  }

  Future<void> getTheSharedPref() async {
    image = await SharedPreferencesHelper().getUserImage();
    name = await SharedPreferencesHelper().getUserName();
    email = await SharedPreferencesHelper().getUserEmail();
    id = await SharedPreferencesHelper().getUserId();
    setState(() {
      isLoadingData = false; // ✅ البيانات خلص تحميلها
    });
  }

  Future<void> pickImage() async {
    final XFile? picked =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
      await uploadProfileImage();
    }
  }

  Future<void> uploadProfileImage() async {
    if (selectedImage == null || id == null) return;

    setState(() => isLoading = true);

    try {
      final imageUrl =
          await ImageUploadService().uploadImageToImgbb(selectedImage!);

      if (imageUrl == null) throw "Image upload failed";

      // 🔵 تحديث الصورة في Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update({"image": imageUrl});

      // 🔵 تحديث SharedPreferences
      await SharedPreferencesHelper().saveUserImage(imageUrl);

      setState(() {
        image = imageUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Profile image updated")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // ✅ لو البيانات لسه بتتحمل، اعرض Loading فقط
    if (isLoadingData) {
      return const Scaffold(
        backgroundColor: kPrimaryColor,
        body: Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.18,
                    backgroundImage: image != null && image!.isNotEmpty
                        ? NetworkImage(image!)
                        : const AssetImage(Assets.kProfileImage)
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.blue,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2)
                            : const Icon(Icons.camera_alt,
                                color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.025),
              Text(
                'Hello ${name ?? "User"}',
                style: AppStyless.styleBold28.copyWith(
                  fontSize: screenWidth * 0.06,
                ),
              ),
              Text(
                email ?? "no email",
                style: AppStyless.styleBold28.copyWith(
                  fontSize: screenWidth * 0.04,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              CustomListTile(
                icon: Icons.logout,
                title: 'Sign Out',
                onTap: () {
                  showCustomDialog(
                    context: context,
                    title: "Sign Out",
                    content: "Are you sure you want to sign out?",
                    confirmText: "Sign Out",
                    onConfirm: () async {
                      await AuthService().signOut();
                      await SharedPreferencesHelper().clearAll();
                      if (!mounted) return;
                      GoRouter.of(context).go(AppRouter.kOnBoarding);
                    },
                  );
                },
              ),
              CustomListTile(
                icon: Icons.delete,
                title: 'Delete Account',
                onTap: () {
                  showCustomDialog(
                    context: context,
                    title: "Delete Account",
                    content:
                        "Are you sure you want to delete your account? This action cannot be undone.",
                    confirmText: "Delete",
                    onConfirm: () async {
                      try {
                        final currentUser = FirebaseAuth.instance.currentUser;
                        if (currentUser == null) {
                          throw "No user is logged in";
                        }
                        final doc = await DatabaseMethods()
                            .getUserByEmail(currentUser.email!);
                        if (doc != null) {
                          final userId = doc["id"];
                          await AuthService().deleteAccount(userId);
                          await SharedPreferencesHelper().clearAll();
                          if (!mounted) return;
                          GoRouter.of(context).go(AppRouter.kOnBoarding);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("❌ $e")),
                        );
                      }
                    },
                  );
                },
              ),
              CustomWhats(),
            ],
          ),
        ),
      ),
    );
  }
}
