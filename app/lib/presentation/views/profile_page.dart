import 'package:app/presentation/styles/colors/generic.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBlackColor, Colors.grey[900]!],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, size: 100, color: kWhiteColor),
              SizedBox(height: 20),
              Text(
                'Profile Page',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Coming Soon...',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
