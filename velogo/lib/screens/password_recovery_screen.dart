import 'package:flutter/material.dart';
import '../shared/base_widgets.dart'; // Файл з оновленим логотипом
import '../shared/base_colors.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                // Використання базового логотипа
                const CustomLogo(),

                const SizedBox(height: 32),

                // Заголовок
                const CustomText(
                  text: 'Password Recovery',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),

                const SizedBox(height: 16),

                // Опис
                const CustomText(
                  text:
                      'Provide your email to receive a link for resetting your password.',
                  fontSize: 14,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Поле введення електронної пошти
                const CustomTextField(hintText: 'Email Address'),

                const SizedBox(height: 24),

                // Кнопка відправлення
                SizedBox(
                  width: double
                      .infinity, // Ширина кнопки дорівнює ширині текстового поля
                  child: CustomButton(
                    label: 'Send Recovery Link',
                    onPressed: () {
                      print('Recovery link sent');
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Повідомлення
                const CustomText(
                  text:
                      'A recovery link has been sent to your email. Please check your inbox.',
                  fontSize: 14,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Клікабельні тексти
                Column(
                  children: [
                    ClickableText(
                      text: 'Return to Login',
                      onTap: () {
                        print('Return to Login pressed');
                      },
                    ),
                    const SizedBox(height: 16),
                    ClickableText(
                      text: 'Need more help?',
                      onTap: () {
                        print('Need more help tapped');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
