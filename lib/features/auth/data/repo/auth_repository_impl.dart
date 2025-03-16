import 'package:fpdart/fpdart.dart';
import 'package:blog_application/core/error/exceptions.dart';
import 'package:blog_application/core/error/failures.dart';
import 'package:blog_application/core/network/connection_checker.dart';
import 'package:blog_application/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_application/core/common/entities/user.dart';
import 'package:blog_application/features/auth/data/models/userModel.dart';
import 'package:blog_application/features/auth/domain/repo/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failures, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failures("User not logged in!"));
        }
        return right(UserModel(
            id: session.user.id, name: "", email: session.user.email ?? ""));
      }
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failures("User not logged in!"));
      }
      return right(user);
    } on ServerExceptions catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, User>> logInWithEmailPassword(
      {required String email, required String password}) async {
    return _getUser(
      () async => await remoteDataSource.logInWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failures, User>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
          name: name, email: email, password: password),
    );
  }

  Future<Either<Failures, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failures("No Internet Connection!"));
      }
      final user = await fn();
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failures(e.message));
    } on ServerExceptions catch (e) {
      return left(Failures(e.message));
    }
  }
}
