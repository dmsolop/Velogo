import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/base_widgets.dart';
import '../shared/base_colors.dart';
import '../shared/status_message.dart';
import '../services/message_service.dart';
import '../bloc/registration/registration_cubit.dart';
import '../bloc/registration/registration_state.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registrationCubit = context.read<RegistrationCubit>();

    return Scaffold(
      backgroundColor: BaseColors.background,
      body: SafeArea(
        child: BlocListener<RegistrationCubit, RegistrationState>(
            listener: (context, state) {
              if (state.isError || state.isSuccess) {
                MessageService.showMessage(
                  context,
                  message:
                      state.isError ? state.errorMessage : state.successMessage,
                  isError: state.isError,
                );
              }
            },
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
                          onChanged: registrationCubit.updateEmail,
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty && state.isEmailValid) {
                              registrationCubit.checkEmailAvailability(value);
                            }
                          },
                          errorText: !state.isEmailValid
                              ? 'Invalid email address'
                              : state.warningMessage.isNotEmpty
                                  ? state.warningMessage
                                  : null,
                        ),

                        const SizedBox(height: 16),

                        CustomPasswordTextField(
                          hintText: 'Password',
                          onChanged: registrationCubit.updatePassword,
                          errorText: !state.isPasswordValid
                              ? 'Password must be at least 6 characters'
                              : null,
                        ),

                        const SizedBox(height: 16),

                        CustomPasswordTextField(
                          hintText: 'Confirm password',
                          onChanged: registrationCubit.updateConfirmPassword,
                          errorText: !state.isPasswordsMatch
                              ? 'Passwords do not match'
                              : null,
                        ),

                        const SizedBox(height: 16),

                        CustomTextField(
                          hintText: 'First Name',
                          onChanged: registrationCubit.updateUsername,
                          errorText: !state.isUsernameValid
                              ? 'Username cannot be empty'
                              : null,
                        ),

                        const SizedBox(height: 16),

                        CustomTextField(
                          hintText: 'Last Name',
                          onChanged: registrationCubit.updateLastName,
                          errorText: !state.isUsernameValid
                              ? 'Last name cannot be empty'
                              : null,
                        ),
                        const SizedBox(height: 24),

                        // Секція вибору дати народження
                        const CustomText(
                          text: 'Birthday',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 8),

                        CustomButton(
                          label: state.birthday != null
                              ? '${state.birthday!.day}.${state.birthday!.month}.${state.birthday!.year}'
                              : 'DD.MM.YYYY',
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              registrationCubit.updateBirthday(pickedDate);
                            }
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                text: 'Country',
                                fontSize: 12,
                              ),
                              const SizedBox(height: 8),
                              CustomDropdown<String>(
                                label: 'Select Country',
                                hintText: 'Select Country',
                                selectedValue: state.country.isNotEmpty
                                    ? state.country
                                    : null,
                                items: const [
                                  'Ukraine',
                                  'USA',
                                  'Canada',
                                  'Germany',
                                  'France',
                                ], // Приклад списку країн
                                itemLabelBuilder: (item) => item,
                                onChanged: (value) {
                                  if (value != null) {
                                    registrationCubit.updateCountry(value);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Обробка стану загрузки
                        if (state.isSubmitting) ...[
                          SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Stack(
                                children: [
                                  const ModalBarrier(
                                    dismissible: false,
                                    color: Colors.black26,
                                  ),
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ],
                              ))
                        ],

                        const SizedBox(height: 16),
                        StatusMessage(state: state),
                        const SizedBox(height: 16),

                        // Кнопка реєстрації
                        if (!state.isSubmitting)
                          Center(
                            child: CustomButton(
                              label: 'Join',
                              onPressed: registrationCubit.isFormValid()
                                  ? () => registrationCubit.submitRegistration()
                                  : null,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            )),
      ),
    );
  }
}
