import 'package:fpdart/fpdart.dart';
import 'package:blog_application/core/error/failures.dart';
import 'package:blog_application/core/common/entities/user.dart';
import 'package:blog_application/features/auth/domain/repo/auth_repository.dart';
import 'package:blog_application/features/auth/domain/usecases/usecase.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;
  UserSignUp(this.authRepository);

  @override
  Future<Either<Failures, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
        name: params.name, email: params.email, password: params.password);
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
