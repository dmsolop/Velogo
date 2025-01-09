import 'package:flutter/material.dart';
import '../shared/base_widgets.dart';
import '../bloc/registration/registration_state.dart';

class StatusMessage extends StatelessWidget {
  final String? message;
  final bool isError;
  final RegistrationState? state;

  const StatusMessage({
    Key? key,
    this.message,
    this.isError = false,
    this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state != null) {
      // Логіка для стану
      if (state!.isSubmitting) {
        return const Center(child: CircularProgressIndicator());
      }

      final derivedMessage = state!.isError
          ? state!.errorMessage
          : state!.isSuccess
              ? state!.successMessage
              : null;

      if (derivedMessage == null || derivedMessage.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CustomText(
          text: derivedMessage,
          fontSize: 14,
          textAlign: TextAlign.center,
          color: state!.isError ? Colors.red : Colors.green,
        ),
      );
    }

    // Логіка для повідомлення
    if (message == null || message!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomText(
        text: message!,
        fontSize: 14,
        textAlign: TextAlign.center,
        color: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
