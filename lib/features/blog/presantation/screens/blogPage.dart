import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_application/core/common/loader.dart';
import 'package:blog_application/core/theme/app_palette.dart';
import 'package:blog_application/core/utils/show_snackbar.dart';
import 'package:blog_application/features/blog/presantation/bloc/blog_bloc.dart';
import 'package:blog_application/features/blog/presantation/screens/addNewBlogPage.dart';
import 'package:blog_application/features/blog/presantation/widgets/blog_card.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog App"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: Icon(
              CupertinoIcons.add_circled,
            ),
          )
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnacbar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Loader();
          }
          if (state is BlogsDisplaySuccess) {
            return ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final blog = state.blogs[index];
                  return BlogCard(
                    blog: blog,
                    color: index % 3==0 ? AppPallete.gradient1 : 
                    index % 3==1 ? AppPallete.gradient2: AppPallete.gradient3,
                  );
                });
          }
          return Center();
        },
      ),
    );
  }
}
