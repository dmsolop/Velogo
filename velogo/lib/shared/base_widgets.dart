import 'package:flutter/material.dart';
import 'base_colors.dart';
import 'base_fonts.dart';

class CustomLogo extends StatelessWidget {
  final double? size;

  const CustomLogo({Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = size ?? MediaQuery.of(context).size.width * 0.7;
    final double height =
        size != null ? size! * 0.6 : MediaQuery.of(context).size.width * 0.4;

    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: NetworkImage(
              'https://assets.api.uizard.io/api/cdn/stream/4f2572ff-e7da-48c5-b076-a4dccb1d8584.png',
            ),
            fit: BoxFit.cover,
          ),
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
        hintStyle: BaseFonts.body.copyWith(color: BaseColors.textSecondary),
        filled: true,
        fillColor: BaseColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class CustomSegmentedButton<T> extends StatelessWidget {
  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final ValueChanged<Set<T>> onSelectionChanged;

  const CustomSegmentedButton({
    Key? key,
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: segments,
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BaseColors.primary; // Фон активної кнопки
          }
          return BaseColors.cardBackground; // Фон неактивної кнопки
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BaseColors.white; // Колір тексту активної кнопки
          }
          return BaseColors.textSecondary; // Колір тексту неактивної кнопки
        }),
        textStyle: WidgetStateProperty.all(
          BaseFonts.bodyTextBold, // Стиль тексту
        ),
        overlayColor: WidgetStateProperty.all(
          BaseColors.iconSelected.withOpacity(0.1), // Колір натискання
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
        backgroundColor: BaseColors.primary,
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Text(
        label,
        style: BaseFonts.body.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class OutlinedCustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const OutlinedCustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.width = 295,
    this.height = 56,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
            color: BaseColors.grey), // Використовуємо вже існуючий колір
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Text(
        label,
        style: BaseFonts.body, // Використовуємо вже існуючий стиль шрифту
      ),
    );
  }
}

class AdaptiveButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double padding; // Відступи

  const AdaptiveButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.padding = 16.0, // Відступи за замовчуванням
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Використовуємо TextPainter для вимірювання розміру тексту
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: BaseFonts.body.copyWith(
          color: BaseColors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Обчислюємо ширину тексту і додаємо відступи
    final double buttonWidth = textPainter.width + (padding * 2);

    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: BaseColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Зкруглені кути
          ),
          padding: EdgeInsets.zero, // Без зайвих відступів
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center, // Текст центрований горизонтально
            style: BaseFonts.body.copyWith(
              color: BaseColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ProportionalButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double aspectRatio;
  final double minHeight;

  const ProportionalButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.aspectRatio = 3,
    this.minHeight = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
              backgroundColor: BaseColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(
                  color: BaseColors.white,
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

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? color;
  final String? heroTag;

  const CustomFloatingButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.color,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      backgroundColor: color ?? BaseColors.headerDark,
      child: Icon(icon, color: BaseColors.white),
      elevation: 6, // Тінь для ефекту "плавання"
    );
  }
}

class CustomRoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;

  const CustomRoundedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? BaseColors.headerDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Закруглені кути
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 4, // Тінь
      ),
      child: Text(
        text,
        style: const TextStyle(color: BaseColors.white),
      ),
    );
  }
}

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
    this.color = BaseColors.textPrimary,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: BaseFonts.body.copyWith(
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
          checkColor: BaseColors.white,
          activeColor: BaseColors.primary,
        ),
        Text(
          label,
          style: BaseFonts.body,
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
        style: BaseFonts.body.copyWith(
          color: BaseColors.textPrimary,
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
