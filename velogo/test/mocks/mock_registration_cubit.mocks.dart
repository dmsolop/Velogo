// Mocks generated by Mockito 5.4.4 from annotations
// in velogo/test/mocks/mock_registration_cubit.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:flutter/material.dart' as _i5;
import 'package:flutter_bloc/flutter_bloc.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;
import 'package:velogo/bloc/registration/registration_cubit.dart' as _i3;
import 'package:velogo/bloc/registration/registration_state.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeRegistrationState_0 extends _i1.SmartFake
    implements _i2.RegistrationState {
  _FakeRegistrationState_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [RegistrationCubit].
///
/// See the documentation for Mockito's code generation for more information.
class MockRegistrationCubit extends _i1.Mock implements _i3.RegistrationCubit {
  MockRegistrationCubit() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.RegistrationState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _FakeRegistrationState_0(
          this,
          Invocation.getter(#state),
        ),
      ) as _i2.RegistrationState);

  @override
  _i4.Stream<_i2.RegistrationState> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i4.Stream<_i2.RegistrationState>.empty(),
      ) as _i4.Stream<_i2.RegistrationState>);

  @override
  bool get isClosed => (super.noSuchMethod(
        Invocation.getter(#isClosed),
        returnValue: false,
      ) as bool);

  @override
  void navigateToRegistrationScreen() => super.noSuchMethod(
        Invocation.method(
          #navigateToRegistrationScreen,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void navigateToLoginScreen() => super.noSuchMethod(
        Invocation.method(
          #navigateToLoginScreen,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void navigateToPasswordRecoveryScreen() => super.noSuchMethod(
        Invocation.method(
          #navigateToPasswordRecoveryScreen,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<void> saveUserData() => (super.noSuchMethod(
        Invocation.method(
          #saveUserData,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> submitRegistration() => (super.noSuchMethod(
        Invocation.method(
          #submitRegistration,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> login() => (super.noSuchMethod(
        Invocation.method(
          #login,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> sendRecoveryLink() => (super.noSuchMethod(
        Invocation.method(
          #sendRecoveryLink,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> checkEmailAvailability(String? email) => (super.noSuchMethod(
        Invocation.method(
          #checkEmailAvailability,
          [email],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  void showHelpDialog(_i5.BuildContext? context) => super.noSuchMethod(
        Invocation.method(
          #showHelpDialog,
          [context],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateUsername(String? username) => super.noSuchMethod(
        Invocation.method(
          #updateUsername,
          [username],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateEmail(String? email) => super.noSuchMethod(
        Invocation.method(
          #updateEmail,
          [email],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updatePassword(String? password) => super.noSuchMethod(
        Invocation.method(
          #updatePassword,
          [password],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateConfirmPassword(String? confirmPassword) => super.noSuchMethod(
        Invocation.method(
          #updateConfirmPassword,
          [confirmPassword],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateGender(String? gender) => super.noSuchMethod(
        Invocation.method(
          #updateGender,
          [gender],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateLastName(String? lastName) => super.noSuchMethod(
        Invocation.method(
          #updateLastName,
          [lastName],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateBirthday(DateTime? birthday) => super.noSuchMethod(
        Invocation.method(
          #updateBirthday,
          [birthday],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateCountry(String? country) => super.noSuchMethod(
        Invocation.method(
          #updateCountry,
          [country],
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool isFormValid() => (super.noSuchMethod(
        Invocation.method(
          #isFormValid,
          [],
        ),
        returnValue: false,
      ) as bool);

  @override
  void onChange(_i6.Change<_i2.RegistrationState>? change) =>
      super.noSuchMethod(
        Invocation.method(
          #onChange,
          [change],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void emit(_i2.RegistrationState? state) => super.noSuchMethod(
        Invocation.method(
          #emit,
          [state],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void addError(
    Object? error, [
    StackTrace? stackTrace,
  ]) =>
      super.noSuchMethod(
        Invocation.method(
          #addError,
          [
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onError(
    Object? error,
    StackTrace? stackTrace,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #onError,
          [
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [RegistrationCubit].
///
/// See the documentation for Mockito's code generation for more information.
class MockRegistrationCubitWithStream extends _i1.Mock
    implements _i3.RegistrationCubit {
  @override
  _i2.RegistrationState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _FakeRegistrationState_0(
          this,
          Invocation.getter(#state),
        ),
        returnValueForMissingStub: _FakeRegistrationState_0(
          this,
          Invocation.getter(#state),
        ),
      ) as _i2.RegistrationState);

  @override
  _i4.Stream<_i2.RegistrationState> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i4.Stream<_i2.RegistrationState>.empty(),
        returnValueForMissingStub: _i4.Stream<_i2.RegistrationState>.empty(),
      ) as _i4.Stream<_i2.RegistrationState>);

  @override
  bool get isClosed => (super.noSuchMethod(
        Invocation.getter(#isClosed),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  void navigateToRegistrationScreen() => super.noSuchMethod(
        Invocation.method(
          #navigateToRegistrationScreen,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void navigateToLoginScreen() => super.noSuchMethod(
        Invocation.method(
          #navigateToLoginScreen,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void navigateToPasswordRecoveryScreen() => super.noSuchMethod(
        Invocation.method(
          #navigateToPasswordRecoveryScreen,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<void> saveUserData() => (super.noSuchMethod(
        Invocation.method(
          #saveUserData,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> submitRegistration() => (super.noSuchMethod(
        Invocation.method(
          #submitRegistration,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> login() => (super.noSuchMethod(
        Invocation.method(
          #login,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> sendRecoveryLink() => (super.noSuchMethod(
        Invocation.method(
          #sendRecoveryLink,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> checkEmailAvailability(String? email) => (super.noSuchMethod(
        Invocation.method(
          #checkEmailAvailability,
          [email],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  void showHelpDialog(_i5.BuildContext? context) => super.noSuchMethod(
        Invocation.method(
          #showHelpDialog,
          [context],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateUsername(String? username) => super.noSuchMethod(
        Invocation.method(
          #updateUsername,
          [username],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateEmail(String? email) => super.noSuchMethod(
        Invocation.method(
          #updateEmail,
          [email],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updatePassword(String? password) => super.noSuchMethod(
        Invocation.method(
          #updatePassword,
          [password],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateConfirmPassword(String? confirmPassword) => super.noSuchMethod(
        Invocation.method(
          #updateConfirmPassword,
          [confirmPassword],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateGender(String? gender) => super.noSuchMethod(
        Invocation.method(
          #updateGender,
          [gender],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateLastName(String? lastName) => super.noSuchMethod(
        Invocation.method(
          #updateLastName,
          [lastName],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateBirthday(DateTime? birthday) => super.noSuchMethod(
        Invocation.method(
          #updateBirthday,
          [birthday],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateCountry(String? country) => super.noSuchMethod(
        Invocation.method(
          #updateCountry,
          [country],
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool isFormValid() => (super.noSuchMethod(
        Invocation.method(
          #isFormValid,
          [],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  void onChange(_i6.Change<_i2.RegistrationState>? change) =>
      super.noSuchMethod(
        Invocation.method(
          #onChange,
          [change],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void emit(_i2.RegistrationState? state) => super.noSuchMethod(
        Invocation.method(
          #emit,
          [state],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void addError(
    Object? error, [
    StackTrace? stackTrace,
  ]) =>
      super.noSuchMethod(
        Invocation.method(
          #addError,
          [
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onError(
    Object? error,
    StackTrace? stackTrace,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #onError,
          [
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
