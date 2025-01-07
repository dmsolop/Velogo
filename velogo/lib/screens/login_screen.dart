import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/base_widgets.dart';
import '../shared/base_colors.dart';
import '../shared/status_message.dart';
import '../services/message_service.dart';
import '../bloc/registration/registration_cubit.dart';
import '../bloc/registration/registration_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registrationCubit = context.read<RegistrationCubit>();

    return Scaffold(
      backgroundColor: BaseColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocBuilder<RegistrationCubit, RegistrationState>(
              builder: (context, state) {
                return Column(
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
                    CustomTextField(
                      hintText: 'Email',
                      onChanged: registrationCubit.updateEmail,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Password',
                      isObscure: true,
                      onChanged: registrationCubit.updatePassword,
                    ),

                    const SizedBox(height: 16),

                    StatusMessage(
                      message: state.isError
                          ? state.errorMessage
                          : state.isSuccess
                              ? state.successMessage
                              : null,
                      isError: state.isError,
                    ),

                    const SizedBox(height: 16),

                    // Кнопка входу
                    if (state.isSubmitting)
                      const Center(child: CircularProgressIndicator())
                    else
                      Center(
                        child: CustomButton(
                          label: 'Log In',
                          onPressed: () {
                            registrationCubit.login();
                            if (state.isError || state.isSuccess) {
                              MessageService.showMessage(
                                context,
                                message: state.isError
                                    ? state.errorMessage
                                    : state.successMessage,
                                isError: state.isError,
                              );
                            }
                          },
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Забули пароль
                    ClickableText(
                      text: 'Forgot Password?',
                      onTap: () {
                        registrationCubit.navigateToPasswordRecoveryScreen();
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
                          registrationCubit.navigateToRegistrationScreen();
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
                          MessageService.showMessage(
                            context,
                            message: 'Terms & Conditions tapped',
                            isError: false,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
