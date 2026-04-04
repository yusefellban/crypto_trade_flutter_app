import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/preference_service.dart';
import '../../../core/services/database_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final DatabaseService _databaseService;
  final PreferenceService _preferenceService;

  AuthCubit(this._databaseService, this._preferenceService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _databaseService.loginUser(email, password);
      if (user != null) {
        await _preferenceService.setLoggedIn(true);
        emit(Authenticated(user));
      } else {
        emit(const AuthError("Invalid email or password"));
      }
    } catch (e) {
      emit(AuthError("Login failed: ${e.toString()}"));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      await _databaseService.registerUser(name, email, password);
      emit(Unauthenticated()); // Registration successful, go to login
    } catch (e) {
      emit(AuthError("Registration failed: ${e.toString()}"));
    }
  }

  Future<void> logout() async {
    await _preferenceService.setLoggedIn(false);
    emit(Unauthenticated());
  }

  void resetState() {
    emit(AuthInitial());
  }
}
