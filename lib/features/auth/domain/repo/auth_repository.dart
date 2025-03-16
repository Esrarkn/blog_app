import 'package:fpdart/fpdart.dart';
import 'package:blog_application/core/error/failures.dart';
import 'package:blog_application/core/common/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failures, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failures, User>> logInWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failures, User>> currentUser();
}
