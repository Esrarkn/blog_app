import 'package:flutter/material.dart';
import 'package:blog_application/core/theme/app_palette.dart';
import 'package:blog_application/core/utils/calculate_reading.dart';
import 'package:blog_application/core/utils/format_date.dart';
import 'package:blog_application/features/blog/domain/entities/blog.dart';

class BlogViewPage extends StatelessWidget {
  static route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogViewPage(blog: blog));
  final Blog blog;
  const BlogViewPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "By ${blog.posterName}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${formatDateBydMMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min",
                  style: TextStyle(
                      color: AppPallete.greyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(blog.imageUrl),
                ),
                SizedBox(height: 20,),
                Text(blog.content,style: TextStyle(
                  fontSize: 16,
                  height: 2
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
