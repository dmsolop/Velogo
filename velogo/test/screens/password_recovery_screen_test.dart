// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
// import 'package:velogo/bloc/registration/registration_cubit.dart';
// import 'package:velogo/bloc/registration/registration_state.dart';
// import 'package:velogo/screens/password_recovery_screen.dart';
// import 'package:velogo/shared/base_widgets.dart';

// import '../mocks/mock_registration_cubit.mocks.dart';

// void main() {
//   late MockRegistrationCubit mockRegistrationCubit;

//   setUp(() {
//     mockRegistrationCubit = MockRegistrationCubit();
//   });

//   Widget createTestWidget(Widget child) {
//     return Provider<RegistrationCubit>(
//       create: (_) => mockRegistrationCubit,
//       child: MaterialApp(
//         home: child,
//       ),
//     );
//   }

//   group('PasswordRecoveryScreen Tests', () {
//     testWidgets('renders PasswordRecoveryScreen elements correctly',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockRegistrationCubit.state).thenReturn(const RegistrationState());

//       await tester.pumpWidget(createTestWidget(const PasswordRecoveryScreen()));

//       // Act
//       final emailFieldFinder = find.byType(TextFormField);
//       final sendButtonFinder = find.text('Send Recovery Link');
//       final returnToLoginFinder = find.text('Return to Login');
//       final needMoreHelpFinder = find.text('Need more help?');

//       // Assert
//       expect(emailFieldFinder, findsOneWidget);
//       expect(sendButtonFinder, findsOneWidget);
//       expect(returnToLoginFinder, findsOneWidget);
//       expect(needMoreHelpFinder, findsOneWidget);
//     });

//     testWidgets('calls updateEmail on email field input',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockRegistrationCubit.state).thenReturn(const RegistrationState());

//       await tester.pumpWidget(createTestWidget(const PasswordRecoveryScreen()));

//       // Act
//       final emailField = find.byType(TextFormField);
//       await tester.enterText(emailField, 'test@example.com');
//       await tester.pumpAndSettle();

//       // Assert
//       verify(mockRegistrationCubit.updateEmail('test@example.com')).called(1);
//     });

//     testWidgets('disables Send Recovery Link button if email is invalid',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockRegistrationCubit.state)
//           .thenReturn(const RegistrationState(isEmailValid: false));

//       await tester.pumpWidget(createTestWidget(const PasswordRecoveryScreen()));

//       // Act
//       final sendButton = find.text('Send Recovery Link');

//       // Assert
//       expect(tester.widget<CustomButton>(sendButton).onPressed, isNull);
//     });

//     testWidgets(
//         'calls sendRecoveryLink when Send Recovery Link button is pressed',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockRegistrationCubit.state)
//           .thenReturn(const RegistrationState(isEmailValid: true));

//       await tester.pumpWidget(createTestWidget(const PasswordRecoveryScreen()));

//       // Act
//       final sendButton = find.text('Send Recovery Link');
//       await tester.tap(sendButton);
//       await tester.pumpAndSettle();

//       // Assert
//       verify(mockRegistrationCubit.sendRecoveryLink()).called(1);
//     });

//     testWidgets('calls navigateToLoginScreen on Return to Login tap',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockRegistrationCubit.state).thenReturn(const RegistrationState());

//       await tester.pumpWidget(createTestWidget(const PasswordRecoveryScreen()));

//       // Act
//       final returnToLogin = find.text('Return to Login');
//       await tester.tap(returnToLogin);
//       await tester.pumpAndSettle();

//       // Assert
//       verify(mockRegistrationCubit.navigateToLoginScreen()).called(1);
//     });

//     testWidgets('shows help dialog on Need More Help? tap',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockRegistrationCubit.state).thenReturn(const RegistrationState());

//       await tester.pumpWidget(createTestWidget(const PasswordRecoveryScreen()));

//       // Act
//       final needMoreHelp = find.text('Need more help?');
//       await tester.tap(needMoreHelp);
//       await tester.pumpAndSettle();

//       // Assert
//       expect(find.byType(AlertDialog), findsOneWidget);
//       expect(find.text('Need More Help?'), findsOneWidget);
//       expect(
//           find.text('Please contact our support team at support@example.com.'),
//           findsOneWidget);
//     });

//     testWidgets('displays error message when isError is true',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockRegistrationCubit.state).thenReturn(const RegistrationState(
//         isError: true,
//         errorMessage: 'Failed to send recovery link.',
//       ));

//       await tester.pumpWidget(createTestWidget(const PasswordRecoveryScreen()));

//       // Act
//       final errorMessage = find.text('Failed to send recovery link.');

//       // Assert
//       expect(errorMessage, findsOneWidget);
//     });

//     testWidgets('displays success message when isSuccess is true',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockRegistrationCubit.state).thenReturn(const RegistrationState(
//         isSuccess: true,
//         successMessage: 'Recovery link sent successfully!',
//       ));

//       await tester.pumpWidget(createTestWidget(const PasswordRecoveryScreen()));

//       // Act
//       final successMessage = find.text('Recovery link sent successfully!');

//       // Assert
//       expect(successMessage, findsOneWidget);
//     });

//     testWidgets('shows loading indicator when isSubmitting is true',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockRegistrationCubit.state).thenReturn(const RegistrationState(
//         isSubmitting: true,
//       ));

//       await tester.pumpWidget(createTestWidget(const PasswordRecoveryScreen()));

//       // Act
//       final loadingIndicator = find.byType(CircularProgressIndicator);

//       // Assert
//       expect(loadingIndicator, findsOneWidget);
//     });
//   });
// }
