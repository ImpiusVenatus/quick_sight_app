import 'package:flutter/material.dart';
import 'package:quicksight/views/camera/camera_view.dart';
import 'package:quicksight/views/colorblindness_screen/colorblindness_screen.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003049),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "PICK ONE OF THE TWO OPTIONS:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ColorBlindnessScreen(),
                      ),
                    );
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.visibility, // Eye icon
                        color: Colors.white,
                        size: 80,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "COLOR-BLINDNESS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CameraView(),
                      ),
                    );
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.videocam, // Video icon
                        color: Colors.white,
                        size: 80,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "QUICK-SIGHT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "(PRESSING THE LOWER VOLUME BUTTON PICKS QUICKSIGHT)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
