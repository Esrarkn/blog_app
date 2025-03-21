import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:blog_application/core/error/failures.dart';
import 'package:blog_application/features/auth/domain/usecases/usecase.dart';
import 'package:blog_application/features/blog/domain/entities/blog.dart';
import 'package:blog_application/features/blog/domain/repository/blog_repository.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;
  UploadBlog(this.blogRepository);
  
  @override
  Future<Either<Failures, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}
