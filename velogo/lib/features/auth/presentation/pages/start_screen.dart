import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/base_widgets.dart';
import '../../../../shared/base_colors.dart';
import '../bloc/registration/registration_cubit.dart';
import '../bloc/registration/registration_state.dart';
import '../../../../shared/status_message.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registrationCubit = context.read<RegistrationCubit>();

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

            // Відображення повідомлень
            BlocBuilder<RegistrationCubit, RegistrationState>(
              builder: (context, state) {
                return StatusMessage(
                  message: state.isError
                      ? state.errorMessage
                      : state.isSuccess
                          ? state.successMessage
                          : null,
                  isError: state.isError,
                );
              },
            ),

            // Кнопка "Get started"
            CustomButton(
              label: 'Get started',
              onPressed: () {
                registrationCubit.navigateToRegistrationScreen();
              },
              width: 327,
              height: 56,
            ),

            // Перехід на "Sign in"
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
                      registrationCubit.navigateToLoginScreen();
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
