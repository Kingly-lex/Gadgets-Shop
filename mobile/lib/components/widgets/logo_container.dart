import 'package:flutter/material.dart';

class LogoContainer extends StatelessWidget {
  final String imagepath;
  const LogoContainer({super.key, required this.imagepath});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          side: const BorderSide(color: Colors.white),
          foregroundColor: Colors.blue.shade100,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Image.asset(
          imagepath,
          height: 40,
        ),
      ),
    );
  }
}
