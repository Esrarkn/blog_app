import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:blog_application/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_application/core/common/entities/user.dart';
import 'package:blog_application/features/auth/domain/usecases/current_user.dart';
import 'package:blog_application/features/auth/domain/usecases/usecase.dart';
import 'package:blog_application/features/auth/domain/usecases/user_login.dart';
import 'package:blog_application/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {

    on<AuthEvent>((_,emit)=>emit(AuthLoading(),),);
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    
  }
  void _isUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(
      NoParams(),
    );
    res.fold(
      (l) => emit(
        AuthFailure(l.message),
      ),
      (r) {
        print(r.email);
        _emitAuthSuccess(r, emit);
      },
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    try {
      final res = await _userSignUp(UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ));

      res.fold(
        (failure) {
          print("❌ Kullanıcı kaydı başarısız: ${failure.message}");
          emit(AuthFailure(failure.message));
        },
        (user) {
          print("✅ Kullanıcı başarıyla kaydedildi! UID: $user");
          _emitAuthSuccess(user, emit);
        },
      );
    } catch (e) {
      print("⚠ Beklenmeyen bir hata oluştu: $e");
      emit(AuthFailure("Beklenmeyen bir hata oluştu: $e"));
    }
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    try {
      final res = await _userLogin(UserLoginParams(
        email: event.email,
        password: event.password,
      ));
      res.fold(
        (failure) {
          print("❌ Kullanıcı Girişi başarısız: ${failure.message}");
          emit(AuthFailure(failure.message));
        },
        (user) {
          print("✅ Kullanıcı başarıyla giriş yaptı! UID: $user");
          _emitAuthSuccess(user, emit);
        },
      );
    } catch (e) {
      print("⚠ Beklenmeyen bir hata oluştu: $e");
      emit(AuthFailure("Beklenmeyen bir hata oluştu: $e"));
    }
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit){
    _appUserCubit.upDateUser(user);
    emit(AuthSuccess(user));
  }
}
