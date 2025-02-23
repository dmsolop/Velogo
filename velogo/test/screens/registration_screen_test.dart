// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
// import 'package:velogo/bloc/registration/registration_cubit.dart';
// import 'package:velogo/bloc/registration/registration_state.dart';
// import 'package:velogo/screens/registration_screen.dart';

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

//   group('RegistrationScreen Tests', () {
//     testWidgets('renders RegistrationScreen elements correctly',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockRegistrationCubit.state).thenReturn(const RegistrationState());

//       await tester.pumpWidget(createTestWidget(const RegistrationScreen()));

//       // Act
//       final emailFieldFinder = find.byType(TextFormField).first;
//       final passwordFieldFinder = find.byType(TextFormField).last;
//       final joinButtonFinder = find.text('Join');

//       // Assert
//       expect(emailFieldFinder, findsOneWidget);
//       expect(passwordFieldFinder, findsOneWidget);
//       expect(joinButtonFinder, findsOneWidget);
//     });

//     testWidgets('calls updateEmail on email field input',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockRegistrationCubit.state).thenReturn(const RegistrationState());

//       await tester.pumpWidget(createTestWidget(const RegistrationScreen()));

//       // Act
//       final emailField = find.byType(TextFormField).first;
//       await tester.enterText(emailField, 'test@example.com');
//       await tester.pumpAndSettle();

//       // Assert
//       verify(mockRegistrationCubit.updateEmail('test@example.com')).called(1);
//     });

//     testWidgets('calls updatePassword on password field input',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockRegistrationCubit.state).thenReturn(const RegistrationState());

//       await tester.pumpWidget(createTestWidget(const RegistrationScreen()));

//       // Act
//       final passwordField = find.byType(TextFormField).last;
//       await tester.enterText(passwordField, 'password123');
//       await tester.pumpAndSettle();

//       // Assert
//       verify(mockRegistrationCubit.updatePassword('password123')).called(1);
//     });

//     testWidgets('calls submitRegistration on Join button press',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockRegistrationCubit.state).thenReturn(const RegistrationState(
//         isEmailValid: true,
//         isPasswordValid: true,
//         isUsernameValid: true,
//       ));

//       await tester.pumpWidget(createTestWidget(const RegistrationScreen()));

//       // Act
//       final joinButton = find.text('Join');
//       await tester.tap(joinButton);
//       await tester.pumpAndSettle();

//       // Assert
//       verify(mockRegistrationCubit.submitRegistration()).called(1);
//     });

//     testWidgets('displays error message when isError is true',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockRegistrationCubit.state).thenReturn(const RegistrationState(
//         isError: true,
//         errorMessage: 'Registration failed!',
//       ));

//       await tester.pumpWidget(createTestWidget(const RegistrationScreen()));

//       // Act
//       final errorMessage = find.text('Registration failed!');

//       // Assert
//       expect(errorMessage, findsOneWidget);
//     });

//     testWidgets('displays loading indicator when isSubmitting is true',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockRegistrationCubit.state).thenReturn(const RegistrationState(
//         isSubmitting: true,
//       ));

//       await tester.pumpWidget(createTestWidget(const RegistrationScreen()));

//       // Act
//       final loadingIndicator = find.byType(CircularProgressIndicator);

//       // Assert
//       expect(loadingIndicator, findsOneWidget);
//     });
//   });
// }
