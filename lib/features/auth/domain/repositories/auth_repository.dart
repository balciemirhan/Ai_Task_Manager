import 'package:myapp/features/auth/domain/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password);
  Future<void> logout();
  Stream<UserModel?> authStateChanges();
}
