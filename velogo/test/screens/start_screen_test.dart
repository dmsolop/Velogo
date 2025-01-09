import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:velogo/bloc/registration/registration_cubit.dart';
import 'package:velogo/screens/start_screen.dart';

import '../mocks/mock_registration_cubit.mocks.dart';

void main() {
  late MockRegistrationCubit mockRegistrationCubit;

  setUp(() {
    mockRegistrationCubit = MockRegistrationCubit();
  });

  Widget createTestWidget(Widget child) {
    return Provider<RegistrationCubit>(
      create: (_) => mockRegistrationCubit,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('StartScreen Tests', () {
    testWidgets('renders StartScreen elements correctly',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(const StartScreen()));

      // Act
      final titleFinder = find.text('VELOGO');
      final subtitleFinder =
          find.text('Track your rides and explore new routes effortlessly.');
      final getStartedButtonFinder = find.text('Get started');
      final signInFinder = find.text('Sign in');

      // Assert
      expect(titleFinder, findsOneWidget);
      expect(subtitleFinder, findsOneWidget);
      expect(getStartedButtonFinder, findsOneWidget);
      expect(signInFinder, findsOneWidget);
    });

    testWidgets(
        'calls navigateToRegistrationScreen on "Get started" button tap',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(const StartScreen()));

      // Act
      final getStartedButton = find.text('Get started');
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle();

      // Assert
      verify(mockRegistrationCubit.navigateToRegistrationScreen()).called(1);
    });

    testWidgets('calls navigateToLoginScreen on "Sign in" text tap',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(const StartScreen()));

      // Act
      final signInText = find.text('Sign in');
      await tester.tap(signInText);
      await tester.pumpAndSettle();

      // Assert
      verify(mockRegistrationCubit.navigateToLoginScreen()).called(1);
    });
  });
}
