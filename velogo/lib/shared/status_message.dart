import 'package:flutter/material.dart';
import '../shared/base_widgets.dart';

class StatusMessage extends StatelessWidget {
  final String? message;
  final bool isError;

  const StatusMessage({
    Key? key,
    this.message,
    this.isError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) {
      return const SizedBox
          .shrink(); // Повертає пустий віджет, якщо повідомлення відсутнє
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
