import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:velogo/bloc/registration/registration_cubit.dart';
import 'package:velogo/bloc/registration/registration_state.dart';
import 'package:velogo/screens/login_screen.dart';

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

  group('LoginScreen Tests', () {
    testWidgets('renders LoginScreen elements correctly',
        (WidgetTester tester) async {
      // Arrange
      when(mockRegistrationCubit.state).thenReturn(const RegistrationState());

      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      // Act
      final emailFieldFinder = find.byType(TextFormField).first;
      final passwordFieldFinder = find.byType(TextFormField).last;
      final loginButtonFinder = find.text('Log In');
      final registerButtonFinder = find.text('Register');
      final forgotPasswordFinder = find.text('Forgot Password?');

      // Assert
      expect(emailFieldFinder, findsOneWidget);
      expect(passwordFieldFinder, findsOneWidget);
      expect(loginButtonFinder, findsOneWidget);
      expect(registerButtonFinder, findsOneWidget);
      expect(forgotPasswordFinder, findsOneWidget);
    });

    testWidgets('calls updateEmail on email field input',
        (WidgetTester tester) async {
      // Arrange
      when(mockRegistrationCubit.state).thenReturn(const RegistrationState());

      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      // Act
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();

      // Assert
      verify(mockRegistrationCubit.updateEmail('test@example.com')).called(1);
    });

    testWidgets('calls updatePassword on password field input',
        (WidgetTester tester) async {
      // Arrange
      when(mockRegistrationCubit.state).thenReturn(const RegistrationState());

      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      // Act
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      // Assert
      verify(mockRegistrationCubit.updatePassword('password123')).called(1);
    });

    testWidgets('calls login on Log In button press',
        (WidgetTester tester) async {
      // Arrange
      when(mockRegistrationCubit.state).thenReturn(const RegistrationState(
        isEmailValid: true,
        isPasswordValid: true,
      ));

      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      // Act
      final loginButton = find.text('Log In');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert
      verify(mockRegistrationCubit.login()).called(1);
    });

    testWidgets('calls navigateToPasswordRecoveryScreen on Forgot Password tap',
        (WidgetTester tester) async {
      // Arrange
      when(mockRegistrationCubit.state).thenReturn(const RegistrationState());

      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      // Act
      final forgotPassword = find.text('Forgot Password?');
      await tester.tap(forgotPassword);
      await tester.pumpAndSettle();

      // Assert
      verify(mockRegistrationCubit.navigateToPasswordRecoveryScreen())
          .called(1);
    });

    testWidgets('calls navigateToRegistrationScreen on Register button press',
        (WidgetTester tester) async {
      // Arrange
      when(mockRegistrationCubit.state).thenReturn(const RegistrationState());

      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      // Act
      final registerButton = find.text('Register');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Assert
      verify(mockRegistrationCubit.navigateToRegistrationScreen()).called(1);
    });

    testWidgets('displays error message when isError is true',
        (WidgetTester tester) async {
      // Arrange
      when(mockRegistrationCubit.state).thenReturn(const RegistrationState(
        isError: true,
        errorMessage: 'Login failed!',
      ));

      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      // Act
      final errorMessage = find.text('Login failed!');

      // Assert
      expect(errorMessage, findsOneWidget);
    });

    testWidgets('displays loading indicator when isSubmitting is true',
        (WidgetTester tester) async {
      // Arrange
      when(mockRegistrationCubit.state).thenReturn(const RegistrationState(
        isSubmitting: true,
      ));

      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      // Act
      final loadingIndicator = find.byType(CircularProgressIndicator);

      // Assert
      expect(loadingIndicator, findsOneWidget);
    });
  });
}
