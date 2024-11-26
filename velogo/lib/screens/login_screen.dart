import 'package:flutter/material.dart';
import '../shared/base_widgets.dart';
import '../shared/base_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Використання базового логотипа
                const CustomLogo(),

                const SizedBox(height: 24),

                // Інформаційний текст
                const Center(
                  child: CustomText(
                    text: 'Reset password quickly',
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 16),

                // Заголовок
                const Center(
                  child: CustomText(
                    text: 'Welcome Back!',
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // Опис
                const Center(
                  child: CustomText(
                    text: 'Log in to continue exploring bike routes.',
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 24),

                // Поля Email і Password
                const CustomTextField(hintText: 'Email'),
                const SizedBox(height: 16),
                const CustomTextField(hintText: 'Password', isObscure: true),

                const SizedBox(height: 24),

                // Кнопка входу
                Center(
                  child: CustomButton(
                    label: 'Log In',
                    onPressed: () {
                      print('Log In button pressed');
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Альтернативний вхід
                const Center(
                  child: CustomText(
                    text: 'or log in with',
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 16),

                // Кнопки Google і Facebook
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      label: 'G',
                      onPressed: () {
                        print('Google login');
                      },
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 16),
                    CustomButton(
                      label: 'f',
                      onPressed: () {
                        print('Facebook login');
                      },
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Забули пароль
                ClickableText(
                  text: 'Forgot Password?',
                  onTap: () {
                    print('Forgot Password tapped');
                  },
                ),

                const SizedBox(height: 16),

                // Новий користувач
                const Center(
                  child: CustomText(
                    text: 'New to CycleNav?',
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 16),

                // Кнопка реєстрації
                Center(
                  child: CustomButton(
                    label: 'Register',
                    onPressed: () {
                      print('Register button pressed');
                    },
                    width: 295,
                    height: 56,
                  ),
                ),

                const SizedBox(height: 16),

                // Умови використання
                Center(
                  child: ClickableText(
                    text: 'Terms & Conditions',
                    onTap: () {
                      print('Terms & Conditions tapped');
                    },
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
