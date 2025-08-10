library mock_registration_cubit;

import 'package:mockito/annotations.dart';
import 'package:velogo/features/auth/presentation/bloc/registration/registration_cubit.dart';

@GenerateMocks(
  [RegistrationCubit],
  customMocks: [
    MockSpec<RegistrationCubit>(
      as: #MockRegistrationCubitWithStream,
      onMissingStub: OnMissingStub.returnDefault,
    ),
  ],
)
void main() {}
