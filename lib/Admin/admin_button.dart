import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:delivery/utils/app_router.dart';

class AdminButton extends StatelessWidget {
  const AdminButton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(AppRouter.kAdminLogin);
      },
      child: Container(
        width: width * 0.18,
        height: width * 0.18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            // ظل خفيف أسفل الزجاج
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.30),
                    Colors.white.withOpacity(0.10),
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // لمعة زجاج خفيفة
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: width * 0.06,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    LucideIcons.shieldCheck,
                    color: Colors.white.withOpacity(0.9),
                    size: width * 0.06,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
