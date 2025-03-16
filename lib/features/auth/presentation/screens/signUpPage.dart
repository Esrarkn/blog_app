import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_application/core/common/loader.dart';
import 'package:blog_application/core/theme/app_palette.dart';
import 'package:blog_application/core/utils/show_snackbar.dart';
import 'package:blog_application/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_application/features/auth/presentation/screens/logInPage.dart';
import 'package:blog_application/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_application/features/auth/presentation/widgets/auth_gradient_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView( // SingleChildScrollView buraya alındı!
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: BlocConsumer<AuthBloc,AuthState>(
            listener: (context, state){
              if(state is AuthFailure){
return showSnacbar(context, state.message);
            }
            },
            builder: (context, state) {
              if(state is AuthLoading){
                return Loader();
              }
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40), // Ekranın üst kısmında boşluk bırakır
                  Text(
                    "Sign Up.",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  AuthField(
                    controller: nameController,
                    hintText: "Name", validator: (value) {  if (value == null || value.isEmpty) {
                  return "İsim boş olamaz!";
                } },
                  ),
                  SizedBox(height: 15),
                  AuthField(
              controller: emailController,
              hintText: "Email",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "E-posta adresi boş olamaz!";
                }
                String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                RegExp regex = RegExp(pattern);
                if (!regex.hasMatch(value)) {
                  return "Geçerli bir e-posta adresi giriniz!";
                }
                return null;
              },
            ),
            
                  SizedBox(height: 15),
                  AuthField(
              controller: passwordController,
              hintText: "Password",
              isObscureText: true,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return "Şifre en az 6 karakter olmalıdır!";
                }
                return null;
              },
            ),
            
                  SizedBox(height: 20),
                  AuthGradientButton(
                    buttonText: "Sign Up",
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              AuthSignUp(
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LogInPage()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: "Sign In",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40), // Alt kısımda boşluk bırakır
                ],
              ),
            );
            },
          ),
        ),
      ),
    );
  }
}
