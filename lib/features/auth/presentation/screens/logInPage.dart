import 'package:blog_application/features/blog/presantation/screens/blogPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_application/core/common/loader.dart';
import 'package:blog_application/core/theme/app_palette.dart';
import 'package:blog_application/core/utils/show_snackbar.dart';
import 'package:blog_application/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_application/features/auth/presentation/screens/signUpPage.dart';
import 'package:blog_application/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_application/features/auth/presentation/widgets/auth_gradient_button.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnacbar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Loader();
            }
            return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign In.",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    AuthField(
                      controller: emailController,
                      hintText: "Email",
                      validator: (value) {},
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AuthField(
                      controller: passwordController,
                      hintText: "Password",
                      isObscureText: true,
                      validator: (value) {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AuthGradientButton(
                      buttonText: "Sign In",
                      onPressed: () {
                        listener: (context, state) {
  if (state is AuthFailure) {
    showSnacbar(context, state.message);
  } else if (state is AuthSuccess) {
    print("Kullanıcı başarıyla giriş yaptı! UID: ${state.user.id}");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BlogPage()), // Gidilecek sayfa
    );
  }
};

                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: RichText(
                          text: TextSpan(
                              text: "Don't have an account?",
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                            TextSpan(
                              text: "Sign Up",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppPallete.gradient2,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )
                          ])),
                    )
                  ],
                ));
          },
        ),
      ),
    );
  }
}
