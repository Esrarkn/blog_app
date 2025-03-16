import 'package:hive/hive.dart';
import 'package:blog_application/features/blog/data/models/blog_model.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl(this.box);

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];

    for (int i = 0; i < box.length; i++) {
      final blogData = box.get(i.toString());
      if (blogData != null) {
        blogs.add(BlogModel.fromJson(Map<String, dynamic>.from(blogData)));
      }
    }

    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) async {
    box.clear(); // Kutuyu temizlemeden önce await ekledik

    for (int i = 0; i < blogs.length; i++) {
      box.put(i.toString(), blogs[i].toJson());
    }
  }
}
