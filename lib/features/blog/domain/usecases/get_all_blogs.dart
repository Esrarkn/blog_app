import 'package:fpdart/fpdart.dart';
import 'package:blog_application/core/error/failures.dart';
import 'package:blog_application/features/auth/domain/usecases/usecase.dart';
import 'package:blog_application/features/blog/domain/entities/blog.dart';
import 'package:blog_application/features/blog/domain/repository/blog_repository.dart';

class GetAllBlogs implements UseCase<List<Blog>,NoParams>{
  final BlogRepository blogRepository;
  GetAllBlogs(this.blogRepository);
  
  @override
  Future<Either<Failures, List<Blog>>> call(NoParams params) async {
    return await blogRepository.getAllBlogs();
  }

  
}