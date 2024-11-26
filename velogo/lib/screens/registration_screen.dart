import 'package:flutter/material.dart';
import '../shared/base_widgets.dart';
import '../shared/base_colors.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

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
                    text: 'Explore new routes every ride!',
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 24),

                // Поля для введення даних
                const CustomTextField(hintText: 'Email'),
                const SizedBox(height: 16),
                const CustomTextField(hintText: 'Password', isObscure: true),
                const SizedBox(height: 16),
                const CustomTextField(hintText: 'First Name'),
                const SizedBox(height: 16),
                const CustomTextField(hintText: 'Last Name'),

                const SizedBox(height: 24),

                // Секція вибору дати народження
                const CustomText(
                  text: 'Birthday',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 8),
                CustomButton(
                  label: 'DD.MM.YYYY',
                  onPressed: () {
                    print('Date picker opened');
                  },
                  width: 120,
                  height: 36,
                ),

                const SizedBox(height: 24),

                // Секція вибору статі
                const CustomText(
                  text: 'Gender',
                  fontSize: 16,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CustomCheckbox(
                      label: 'Male',
                      value: false,
                      onChanged: (val) {
                        print('Male selected: $val');
                      },
                    ),
                    const SizedBox(width: 16),
                    CustomCheckbox(
                      label: 'Female',
                      value: false,
                      onChanged: (val) {
                        print('Female selected: $val');
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Секція вибору країни
                SectionContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: 'Country',
                        fontSize: 12,
                      ),
                      ClickableText(
                        text: 'Ukraine',
                        onTap: () {
                          print('Country selection opened');
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Кнопка реєстрації
                Center(
                  child: CustomButton(
                    label: 'Join',
                    onPressed: () {
                      print('Join button pressed');
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
