import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_application/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_application/core/common/loader.dart';
import 'package:blog_application/core/theme/app_palette.dart';
import 'package:blog_application/core/utils/pick_image.dart';
import 'package:blog_application/core/utils/show_snackbar.dart';
import 'package:blog_application/features/blog/presantation/bloc/blog_bloc.dart';
import 'package:blog_application/features/blog/presantation/screens/blogPage.dart';
import 'package:blog_application/features/blog/presantation/widgets/blogEditor.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> selectedTopics = [];
  final formKey = GlobalKey<FormState>();
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final userState = context.read<AppUserCubit>().state;

      if (userState is! AppUserLoggedIn || userState.user.id == null) {
        print("HATA: Kullanıcı giriş yapmamış veya ID bulunamadı!");
        return;
      }

      final posterId = userState.user.id;
      print(
          "🔹 Blog yükleniyor: posterId = $posterId, title = ${titleController.text.trim()}");
      print("🔹 İçerik: ${contentController.text.trim()}");
      print("🔹 Seçilen Konular: $selectedTopics");
      print("🔹 Resim: $image");

      context.read<BlogBloc>().add(
            BlogUpload(
                posterId: posterId,
                title: titleController.text.trim(),
                content: contentController.text.trim(),
                image: image!,
                topics: selectedTopics),
          );
    } else {
      print("⚠️ Blog yükleme kriterleri sağlanmadı!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              uploadBlog();
            },
            icon: Icon(
              Icons.done_rounded,
            ),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnacbar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
                context, BlogPage.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: DottedBorder(
                              color: AppPallete.borderColor,
                              dashPattern: [10, 4],
                              radius: Radius.circular(10),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Select Your Image",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          "Tecnology",
                          "Business",
                          "Programming",
                          "Entertainment",
                        ]
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectedTopics.contains(e)) {
                                      selectedTopics.remove(e);
                                    } else {
                                      selectedTopics.add(e);
                                    }
                                    setState(() {
                                      //print(selectedTopics);
                                    });
                                  },
                                  child: Chip(
                                    label: Text(e),
                                    color: selectedTopics.contains(e)
                                        ? MaterialStatePropertyAll(
                                            AppPallete.gradient1,
                                          )
                                        : null,
                                    side: selectedTopics.contains(e)
                                        ? null
                                        : BorderSide(
                                            color: AppPallete.borderColor),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BlogEditor(
                      controller: titleController,
                      hintText: "Blog Title",
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    BlogEditor(
                      controller: contentController,
                      hintText: "Blog Content",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
