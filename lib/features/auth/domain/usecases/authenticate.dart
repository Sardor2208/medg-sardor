

import 'package:xmed/core/either/either.dart';
import 'package:xmed/core/failure/failure.dart';
import 'package:xmed/core/usecase/usecase.dart';
import 'package:xmed/features/auth/domain/entities/authentication_user.dart';
import 'package:xmed/features/auth/domain/repositories/authentication.dart';

class AuthenticationUseCase
    implements UseCase<AuthenticatedUserEntity, Params> {
  final AuthenticationUserRepository _repository;

  const AuthenticationUseCase(
      {required AuthenticationUserRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, AuthenticatedUserEntity>> call(Params params) async{
    if (params is GetStatusParams){
      return _repository.getUser();
    }else if(params is LoginParams){
      return _repository.login(params.email, params.password);
    }else if(params is SignUpParams){
      return _repository.signUp(params.email, params.password);
    }else{
      throw UnimplementedError();
    }
  }
}

abstract class Params {}

class GetStatusParams extends Params {}

class LoginParams extends Params{
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}

class SignUpParams extends Params{
  final String email;
  final String password;

  SignUpParams({required this.email, required this.password});
}
