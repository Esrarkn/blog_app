import 'package:fpdart/fpdart.dart';
import 'package:blog_application/core/error/failures.dart';
import 'package:blog_application/core/common/entities/user.dart';
import 'package:blog_application/features/auth/domain/repo/auth_repository.dart';
import 'package:blog_application/features/auth/domain/usecases/usecase.dart';

class CurrentUser implements UseCase<User,NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failures, User>> call(NoParams params) async{
    return await authRepository.currentUser();
  }
}
