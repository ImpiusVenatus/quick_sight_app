import 'package:flutter/material.dart';
import 'package:quicksight/views/deuteranopia/deuteranopiacamera_screen.dart';
import 'package:quicksight/views/protanopia/protanopiacamera_screen.dart';
import 'package:quicksight/views/tritanopia/tritanopiacamera_screen.dart';

class ColorBlindnessScreen extends StatelessWidget {
  const ColorBlindnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002D5B),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.remove_red_eye,
                size: 60,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              const Text(
                "COLOR-BLINDNESS",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "PICK YOUR DIAGNOSED TYPE:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOption(
                    context,
                    label: "PROTANOPIA",
                    imagePath: "assets/protanopia.png",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProtanopiaView(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildOption(
                    context,
                    label: "DEUTERANOPIA",
                    imagePath: "assets/deuteranopia.png",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeuteranopiaView(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildOption(
                    context,
                    label: "TRITANOPIA",
                    imagePath: "assets/tritanopia.png",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TritanopiaView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context,
      {required String label,
      required String imagePath,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
