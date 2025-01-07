import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/base_widgets.dart';
import '../shared/base_colors.dart';
import '../shared/status_message.dart';
import '../services/message_service.dart';
import '../bloc/registration/registration_cubit.dart';
import '../bloc/registration/registration_state.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

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
                    const CustomLogo(),
                    const SizedBox(height: 24),
                    const Center(
                      child: CustomText(
                        text: 'Explore new routes every ride!',
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Поля для введення даних
                    CustomTextField(
                      hintText: 'Email',
                      onChanged: (value) =>
                          registrationCubit.updateEmail(value),
                      errorText:
                          !state.isEmailValid ? 'Invalid email address' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Password',
                      isObscure: true,
                      onChanged: (value) =>
                          registrationCubit.updatePassword(value),
                      errorText: !state.isPasswordValid
                          ? 'Password must be at least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'First Name',
                      onChanged: (value) =>
                          registrationCubit.updateUsername(value),
                      errorText: !state.isUsernameValid
                          ? 'Username cannot be empty'
                          : null,
                    ),
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
                          value: state.gender == 'Male',
                          onChanged: (val) {
                            if (val == true) {
                              registrationCubit.updateGender('Male');
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        CustomCheckbox(
                          label: 'Female',
                          value: state.gender == 'Female',
                          onChanged: (val) {
                            if (val == true) {
                              registrationCubit.updateGender('Female');
                            }
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

                    // Обробка станів
                    if (state.isSubmitting)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    if (state.isError)
                      const Center(
                        child: Text(
                          'Registration failed. Please try again.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    if (state.isSuccess)
                      const Center(
                        child: Text(
                          'Registration successful! Redirecting...',
                          style: TextStyle(color: Colors.green),
                        ),
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

                    // Кнопка реєстрації
                    if (!state.isSubmitting)
                      Center(
                        child: CustomButton(
                          label: 'Join',
                          onPressed: registrationCubit.isFormValid()
                              ? () {
                                  registrationCubit.submitRegistration();
                                  if (state.isError || state.isSuccess) {
                                    MessageService.showMessage(
                                      context,
                                      message: state.isError
                                          ? state.errorMessage
                                          : state.successMessage,
                                      isError: state.isError,
                                    );
                                  }
                                }
                              : null,
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



// import 'package:flutter/material.dart';
// import '../shared/base_widgets.dart';
// import '../shared/base_colors.dart';

// class RegistrationScreen extends StatelessWidget {
//   const RegistrationScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: BaseColors.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 24),

//                 // Використання базового логотипа
//                 const CustomLogo(),

//                 const SizedBox(height: 24),

//                 // Інформаційний текст
//                 const Center(
//                   child: CustomText(
//                     text: 'Explore new routes every ride!',
//                     fontSize: 16,
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Поля для введення даних
//                 const CustomTextField(hintText: 'Email'),
//                 const SizedBox(height: 16),
//                 const CustomTextField(hintText: 'Password', isObscure: true),
//                 const SizedBox(height: 16),
//                 const CustomTextField(hintText: 'First Name'),
//                 const SizedBox(height: 16),
//                 const CustomTextField(hintText: 'Last Name'),

//                 const SizedBox(height: 24),

//                 // Секція вибору дати народження
//                 const CustomText(
//                   text: 'Birthday',
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 const SizedBox(height: 8),
//                 CustomButton(
//                   label: 'DD.MM.YYYY',
//                   onPressed: () {
//                     print('Date picker opened');
//                   },
//                   width: 120,
//                   height: 36,
//                 ),

//                 const SizedBox(height: 24),

//                 // Секція вибору статі
//                 const CustomText(
//                   text: 'Gender',
//                   fontSize: 16,
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     CustomCheckbox(
//                       label: 'Male',
//                       value: false,
//                       onChanged: (val) {
//                         print('Male selected: $val');
//                       },
//                     ),
//                     const SizedBox(width: 16),
//                     CustomCheckbox(
//                       label: 'Female',
//                       value: false,
//                       onChanged: (val) {
//                         print('Female selected: $val');
//                       },
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 24),

//                 // Секція вибору країни
//                 SectionContainer(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const CustomText(
//                         text: 'Country',
//                         fontSize: 12,
//                       ),
//                       ClickableText(
//                         text: 'Ukraine',
//                         onTap: () {
//                           print('Country selection opened');
//                         },
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Кнопка реєстрації
//                 Center(
//                   child: CustomButton(
//                     label: 'Join',
//                     onPressed: () {
//                       print('Join button pressed');
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
