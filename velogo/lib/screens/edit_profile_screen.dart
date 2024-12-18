import 'package:flutter/material.dart';
import '../shared/base_colors.dart';
import '../shared/base_fonts.dart';
import '../shared/base_widgets.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: BaseColors.headerDark,
        title: const Text(
          "Edit profile",
          style: BaseFonts.appBarTitle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: BaseColors.iconLight),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Аватар
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
            ),
            const SizedBox(height: 24),

            // Поле для введення імені
            const CustomTextFieldWithLabel(
              label: "Name",
              hintText: "Enter your name",
            ),
            const SizedBox(height: 16),

            // Поле для вибору статі
            CustomDropdown<String>(
              label: "Gender",
              hintText: "Select Gender",
              selectedValue: "Male",
              items: const ["Male", "Female", "Other"],
              itemLabelBuilder: (item) => item,
              onChanged: (value) {
                // TODO: Обробка вибору статі
                print("Gender selected: $value");
              },
            ),
            const SizedBox(height: 16),

            // Поле для віку
            const CustomTextFieldWithLabel(
              label: "Age",
              hintText: "Enter your age",
              initialValue: "138",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Перемикач Health Data Integration
            CustomSwitchTile(
              label: "Health Data Integration",
              value: true,
              onChanged: (value) {
                // TODO: Обробка інтеграції
                print("Health Data Integration: $value");
              },
            ),
            const SizedBox(height: 24),

            // Кнопки дій
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: "Save Changes",
                    onPressed: () {
                      // TODO: Зберегти зміни
                      print("Save Changes Pressed");
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedCustomButton(
                    label: "Cancel",
                    onPressed: () {
                      Navigator.pop(context);
                      print("Cancel Pressed");
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
