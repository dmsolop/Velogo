import 'package:flutter/material.dart';
import 'base_colors.dart';
import 'base_fonts.dart';

class CustomLogo extends StatelessWidget {
  final double? size; // Розмір логотипа (якщо null, пропорційний)

  const CustomLogo({Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = size ?? MediaQuery.of(context).size.width * 0.7;
    final double height =
        size != null ? size! * 0.6 : MediaQuery.of(context).size.width * 0.4;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // Скруглені кути
        image: const DecorationImage(
          image: NetworkImage(
            'https://assets.api.uizard.io/api/cdn/stream/4f2572ff-e7da-48c5-b076-a4dccb1d8584.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isObscure;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.isObscure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppFonts.body.copyWith(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.width = 295,
    this.height = 56,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Text(
        label,
        style: AppFonts.body.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// class ProportionalButton extends StatelessWidget {
//   final String label;
//   final VoidCallback onPressed;

//   const ProportionalButton({
//     Key? key,
//     required this.label,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         // Розрахунок ширини на основі довжини тексту
//         final double calculatedWidth = (label.length * 10)
//             .toDouble()
//             .clamp(80, constraints.maxWidth * 0.3);

//         return SizedBox(
//           width: calculatedWidth,
//           height: 50, // Фіксована висота кнопки
//           child: ElevatedButton(
//             onPressed: onPressed,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(6),
//               ),
//             ),
//             child: FittedBox(
//               fit:
//                   BoxFit.scaleDown, // Текст масштабуватиметься всередині кнопки
//               child: Text(
//                 label,
//                 style: const TextStyle(
//                   color: AppColors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14, // Уніфікований розмір тексту
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class ProportionalButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double aspectRatio; // Співвідношення ширини до висоти
  final double minHeight; // Мінімальна висота для кнопки

  const ProportionalButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.aspectRatio = 3, // Співвідношення ширини до висоти за замовчуванням
    this.minHeight = 40, // Мінімальна висота за замовчуванням
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Мінімальна ширина для кнопки
        final double width = constraints.maxWidth > 0
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width / 4;
        final double height =
            (width / aspectRatio).clamp(minHeight, double.infinity);

        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// class ProportionalButton extends StatelessWidget {
//   final String label;
//   final VoidCallback onPressed;
//   final double aspectRatio; // Співвідношення ширини до висоти

//   const ProportionalButton({
//     Key? key,
//     required this.label,
//     required this.onPressed,
//     this.aspectRatio = 3, // Стандартне співвідношення 3:1
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: aspectRatio,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(6),
//           ),
//         ),
//         child: FittedBox(
//           fit: BoxFit.scaleDown, // Масштабування тексту
//           child: Text(
//             label,
//             style: const TextStyle(
//               color: AppColors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign;

  const CustomText({
    Key? key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color = AppColors.textPrimary,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppFonts.body.copyWith(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CustomCheckbox({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          checkColor: AppColors.white,
          activeColor: AppColors.primary,
        ),
        Text(
          label,
          style: AppFonts.body,
        ),
      ],
    );
  }
}

class ClickableText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ClickableText({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: AppFonts.body.copyWith(
          color: AppColors.textPrimary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class SectionContainer extends StatelessWidget {
  final Widget child;

  const SectionContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: child,
    );
  }
}
