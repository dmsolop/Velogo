import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/base_widgets.dart';
import '../shared/base_colors.dart';
import '../shared/status_message.dart';
import '../bloc/registration/registration_cubit.dart';
import '../bloc/registration/registration_state.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

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
                    CustomTextField(
                      hintText: 'Email Address',
                      onChanged: registrationCubit.updateEmail,
                      errorText:
                          !state.isEmailValid ? 'Invalid email format' : null,
                    ),
                    const SizedBox(height: 24),

                    // Відображення повідомлень
                    StatusMessage(
                      state: state,
                    ),
                    const SizedBox(height: 24),

                    // Кнопка відправлення
                    if (state.isSubmitting)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                            label: 'Send Recovery Link',
                            onPressed: state.isEmailValid
                                ? () => registrationCubit.sendRecoveryLink()
                                : null),
                      ),

                    const SizedBox(height: 32),

                    // Клікабельні тексти
                    Column(
                      children: [
                        ClickableText(
                          text: 'Return to Login',
                          onTap: () {
                            registrationCubit.navigateToLoginScreen();
                          },
                        ),
                        const SizedBox(height: 16),
                        ClickableText(
                          text: 'Need more help?',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Need More Help?'),
                                  content: const Text(
                                    'Please contact our support team at support@example.com.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => registrationCubit
                                          .showHelpDialog(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
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




// import 'package:flutter/material.dart';
// import '../shared/base_widgets.dart'; // Файл з оновленим логотипом
// import '../shared/base_colors.dart';

// class PasswordRecoveryScreen extends StatelessWidget {
//   const PasswordRecoveryScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: BaseColors.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 24),

//                 // Використання базового логотипа
//                 const CustomLogo(),

//                 const SizedBox(height: 32),

//                 // Заголовок
//                 const CustomText(
//                   text: 'Password Recovery',
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),

//                 const SizedBox(height: 16),

//                 // Опис
//                 const CustomText(
//                   text:
//                       'Provide your email to receive a link for resetting your password.',
//                   fontSize: 14,
//                   textAlign: TextAlign.center,
//                 ),

//                 const SizedBox(height: 32),

//                 // Поле введення електронної пошти
//                 const CustomTextField(hintText: 'Email Address'),

//                 const SizedBox(height: 24),

//                 // Кнопка відправлення
//                 SizedBox(
//                   width: double
//                       .infinity, // Ширина кнопки дорівнює ширині текстового поля
//                   child: CustomButton(
//                     label: 'Send Recovery Link',
//                     onPressed: () {
//                       print('Recovery link sent');
//                     },
//                   ),
//                 ),

//                 const SizedBox(height: 32),

//                 // Повідомлення
//                 const CustomText(
//                   text:
//                       'A recovery link has been sent to your email. Please check your inbox.',
//                   fontSize: 14,
//                   textAlign: TextAlign.center,
//                 ),

//                 const SizedBox(height: 32),

//                 // Клікабельні тексти
//                 Column(
//                   children: [
//                     ClickableText(
//                       text: 'Return to Login',
//                       onTap: () {
//                         print('Return to Login pressed');
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     ClickableText(
//                       text: 'Need more help?',
//                       onTap: () {
//                         print('Need more help tapped');
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
