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

class CustomTextFieldWithLabel extends StatelessWidget {
  final String label;
  final String initialValue;
  final bool isReadOnly;

  const CustomTextFieldWithLabel({
    Key? key,
    required this.label,
    required this.initialValue,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: isReadOnly,
      controller: TextEditingController(text: initialValue),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: BaseFonts.bodyTextLight,
        filled: true,
        fillColor: BaseColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
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
  final EdgeInsetsGeometry padding; // Педдінг зліва та справа

  const CustomSegmentedButton({
    Key? key,
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    this.padding =
        const EdgeInsets.symmetric(horizontal: 0), // Дефолтний педдінг
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding, // Застосування зовнішнього педдінгу
      child: SizedBox(
        width: double.infinity, // Ширина на весь доступний простір
        child: SegmentedButton<T>(
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
        side: const BorderSide(
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

class CompactOutlinedButtonRow extends StatelessWidget {
  final String label; // Текст лейбла
  final String buttonText; // Текст кнопки
  final VoidCallback onPressed; // Колбек при натисканні кнопки
  final Color? borderColor; // Колір обводки кнопки
  final Color? textColor; // Колір тексту кнопки
  final Color? backgroundColor; // Колір фону кнопки
  final double borderWidth; // Товщина обводки

  const CompactOutlinedButtonRow({
    Key? key,
    required this.label,
    required this.buttonText,
    required this.onPressed,
    this.borderColor,
    this.textColor,
    this.backgroundColor,
    this.borderWidth = 1.5, // Значення за замовчуванням
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Елементи по краях
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Лейбл
        Text(
          label,
          style:
              BaseFonts.bodyTextLight.copyWith(color: BaseColors.textPrimary),
        ),
        // OutlinedButton з можливістю налаштування
        SizedBox(
          height: 40, // Фіксована висота кнопки
          width: 120, // Фіксована ширина кнопки
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: borderColor ?? BaseColors.primary, // Колір обводки
                width: borderWidth, // Товщина обводки
              ),
              backgroundColor:
                  backgroundColor ?? Colors.transparent, // Колір фону
              foregroundColor: textColor ?? BaseColors.primary, // Колір тексту
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Закруглені кути
              ),
            ),
            child: Text(
              buttonText,
              style: BaseFonts.bodyTextBold,
            ),
          ),
        ),
      ],
    );
  }
}

class CompactElevatedButtonRow extends StatelessWidget {
  final String label; // Текст лейбла
  final String buttonText; // Текст кнопки
  final VoidCallback onPressed; // Колбек при натисканні кнопки
  final Color? borderColor; // Колір обводки кнопки
  final Color? backgroundColor; // Колір фону кнопки
  final Color? textColor; // Колір тексту кнопки
  final double borderWidth; // Товщина обводки

  const CompactElevatedButtonRow({
    Key? key,
    required this.label,
    required this.buttonText,
    required this.onPressed,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
    this.borderWidth = 1.5, // Значення за замовчуванням
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Елементи по краях
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Лейбл
        Text(
          label,
          style:
              BaseFonts.bodyTextLight.copyWith(color: BaseColors.textPrimary),
        ),
        // ElevatedButton з можливістю налаштування
        SizedBox(
          height: 40, // Фіксована висота кнопки
          width: 120, // Фіксована ширина кнопки
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  backgroundColor ?? BaseColors.primary, // Колір фону кнопки
              foregroundColor:
                  textColor ?? BaseColors.white, // Колір тексту кнопки
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Закруглені кути
                side: BorderSide(
                  color: borderColor ?? BaseColors.primary, // Колір обводки
                  width: borderWidth, // Товщина обводки
                ),
              ),
              elevation: 2, // Легка тінь для об'ємного ефекту
            ),
            child: Text(
              buttonText,
              style: BaseFonts.bodyTextBold,
            ),
          ),
        ),
      ],
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

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

  const CustomCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor = BaseColors.cardBackground,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

class CustomSectionTitle extends StatelessWidget {
  final String title;

  const CustomSectionTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: BaseFonts.headingMedium.copyWith(color: BaseColors.textPrimary),
      ),
    );
  }
}

class CustomSwitchTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitchTile({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        label,
        style: BaseFonts.bodyTextLight.copyWith(color: BaseColors.textPrimary),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: BaseColors.primary,
      activeTrackColor: BaseColors.headerDark,
      inactiveThumbColor: BaseColors.primary,
      inactiveTrackColor: BaseColors.headerDark,
    );
  }
}

class CustomToggleTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomToggleTile({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Лейбл
        Expanded(
          child: Text(
            label,
            style:
                BaseFonts.bodyTextLight.copyWith(color: BaseColors.textPrimary),
          ),
        ),
        // Кастомний Switch
        Transform.scale(
          scale: 1.2, // Збільшуємо розмір Switch (за потреби)
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: BaseColors.primary, // Колір активного thumb
            activeTrackColor: BaseColors.headerDark, // Колір активного треку
            inactiveThumbColor:
                BaseColors.primary, // Колір thumb у неактивному стані
            inactiveTrackColor: BaseColors.headerDark, // Фон треку
            trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
              (states) => states.contains(MaterialState.disabled)
                  ? BaseColors.headerDark // Колір у неактивному стані
                  : BaseColors.primary, // Колір обводки (кромки)
            ),
          ),
        ),
      ],
    );
  }
}

class CustomRadioGroup<T> extends StatelessWidget {
  final String title;
  final List<T> options;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final String Function(T) labelBuilder;

  const CustomRadioGroup({
    Key? key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.labelBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSectionTitle(title: title),
        ...options.map((option) {
          return RadioListTile<T>(
            title: Text(
              labelBuilder(option),
              style: BaseFonts.bodyTextLight
                  .copyWith(color: BaseColors.textPrimary),
            ),
            value: option,
            groupValue: selectedValue,
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
            activeColor: BaseColors.primary,
          );
        }).toList(),
      ],
    );
  }
}

class CustomDropdown<T> extends StatelessWidget {
  final String label; // Назва поля
  final String hintText; // Текст підказки
  final T selectedValue; // Поточне вибране значення
  final List<T> items; // Варіанти вибору
  final void Function(T?) onChanged; // Колбек для зміни
  final String Function(T) itemLabelBuilder; // Побудова тексту для елементів

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.hintText,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.itemLabelBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              BaseFonts.bodyTextLight.copyWith(color: BaseColors.textPrimary),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: selectedValue,
          decoration: InputDecoration(
            hintText: hintText, // Використовується підказка
            fillColor: BaseColors.inputBackground,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabelBuilder(item)), // Побудова тексту
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class CompactDropdown<T> extends StatelessWidget {
  final String label; // Назва поля
  final String hintText; // Текст підказки
  final T selectedValue; // Поточне вибране значення
  final List<T> items; // Варіанти вибору
  final void Function(T?) onChanged; // Колбек для зміни
  final String Function(T) itemLabelBuilder; // Побудова тексту для елементів

  const CompactDropdown({
    Key? key,
    required this.label,
    required this.hintText,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.itemLabelBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Лейбл
        Text(
          label,
          style:
              BaseFonts.bodyTextLight.copyWith(color: BaseColors.textPrimary),
        ),
        // const SizedBox(width: 12), // Проміжок між лейблом і дропдауном
        // Невеликий фіксований дропдаун
        SizedBox(
          width: 120, // Фіксована ширина дропдауну
          height: 40, // Фіксована висота дропдауну
          child: DropdownButtonFormField<T>(
            value: selectedValue,
            decoration: InputDecoration(
              hintText: hintText,
              fillColor: BaseColors.inputBackground,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 8), // Внутрішні відступи
            ),
            items: items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      itemLabelBuilder(item),
                      style: const TextStyle(fontSize: 14), // Зменшений шрифт
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            icon:
                const Icon(Icons.arrow_drop_down, size: 20), // Зменшена іконка
          ),
        ),
      ],
    );
  }
}

class CustomTextLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomTextLink({
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
        style: BaseFonts.bodyTextLight.copyWith(
          color: BaseColors.textPrimary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class CustomKeyValue extends StatelessWidget {
  final String keyText;
  final String valueText;

  const CustomKeyValue({
    Key? key,
    required this.keyText,
    required this.valueText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            keyText,
            style: BaseFonts.bodyTextLight
                .copyWith(color: BaseColors.textSecondary),
          ),
          Text(
            valueText,
            style:
                BaseFonts.bodyTextBold.copyWith(color: BaseColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
