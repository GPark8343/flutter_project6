import 'package:flutter/material.dart';
import 'package:ifc_project1/widgets/friends/my_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyProfile(),
      ],
    );
  }
}
