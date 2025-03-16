import 'package:fpdart/fpdart.dart';
import 'package:blog_application/core/error/failures.dart';

abstract interface class UseCase<SuccesType, Params> {
  Future<Either<Failures, SuccesType>> call(Params params);
}


class NoParams{}