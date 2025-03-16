
import 'package:blog_application/core/error/exceptions.dart';
import 'package:blog_application/features/auth/data/models/userModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw ServerExceptions("User is Null!");
      }
      print("Kullanıcı başarıyla kaydedildi: ${response.user}");
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth
          .signUp(password: password, email: email, data: {
        "name": name,
      });
      if (response.user == null) {
        throw ServerExceptions("User is Null!");
      }
      print("Kullanıcı başarıyla kaydedildi: ${response.user}");
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient.from("profiles").select().eq(
              "id",
              currentUserSession!.user.id,
            );
            return UserModel.fromJson(userData.first).copyWith(
              email: currentUserSession!.user.email,
            );
      }
      return null;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
