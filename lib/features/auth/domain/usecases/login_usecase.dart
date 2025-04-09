import 'package:myapp/features/auth/domain/models/user_model.dart';
import 'package:myapp/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  Future<UserModel> execute(String email, String password) async {
    return await authRepository.login(email, password);
  }
}
