import 'package:flutter/material.dart';
import '../shared/base_widgets.dart';
import '../shared/base_colors.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.background,
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

            // Використання базового логотипа
            const CustomLogo(),

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
