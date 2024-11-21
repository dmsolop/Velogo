
import 'package:flutter/material.dart';
import 'base_widgets_with_colors_fonts.dart';
import 'base_colors.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 24.0),
              child: CustomText(
                text: 'VELOGO',
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomText(
                text: 'Track your rides and explore new routes effortlessly.',
                fontSize: 14,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 327,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://assets.api.uizard.io/api/cdn/stream/4f2572ff-e7da-48c5-b076-a4dccb1d8584.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            CustomButton(
              label: 'Get started',
              onPressed: () {
                print('Get started pressed');
              },
              width: 327,
              height: 56,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                    text: 'Already part of the team?',
                    fontSize: 14,
                  ),
                  const SizedBox(width: 8),
                  ClickableText(
                    text: 'Sign in',
                    onTap: () {
                      print('Sign in pressed');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
