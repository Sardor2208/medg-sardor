import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmed/core/usecase/usecase.dart';
import 'package:xmed/features/auth/data/data_source/remote.dart';
import 'package:xmed/features/auth/data/repositories/authentication.dart';
import 'package:xmed/features/auth/domain/usecases/authenticate.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entities/authentication_user.dart';
import '../../domain/usecases/logout.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
      : super(const AuthState(
            authenticatedUser: AuthenticatedUserEntity(email: ""),
            status: AuthenticationStatus.unknown)) {
    on<AuthenticationGetStatusEvent>((event, emit) async {
      final usecase = AuthenticationUseCase(
          repository: AuthenticationUserRepositoryImpl(
              dataSource: AuthenticationRemoteDataSource()));
      final either = await usecase.call(GetStatusParams());

      either.either((failure) {
        emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
      }, (user) {
        emit(state.copyWith(
            status: AuthenticationStatus.authenticated,
            authenticatedUserEntity: user));
      });
    });
    on<AuthenticationLogoutRequestedEvent>((event, emit) async {
      final usecase = LogoutUseCase(
        repository: AuthenticationUserRepositoryImpl(
          dataSource: AuthenticationRemoteDataSource(),
        ),
      );

      final either = await usecase.call(NoParams());

      either.either(
        (failure) {},
        (user) {
          emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
        },
      );
    });

    on<AuthenticationLoginRequestedEvent>((event, emit) async {
      final usecase = AuthenticationUseCase(
          repository: AuthenticationUserRepositoryImpl(
              dataSource: AuthenticationRemoteDataSource()));

      final either = await usecase.call(LoginParams(
        email: event.email,
        password: event.password,
      ));

      either.either(
        (failure) {
          emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
          event.onFailure((failure as ServerFailure).message);
        },
        (user) {
          emit(state.copyWith(
            status: AuthenticationStatus.authenticated,
            authenticatedUserEntity: user,
          ));
          event.onSuccess();
        },
      );
    });

    on<AuthenticationSignUpEvent>((event, emit) async {
      final usecase = AuthenticationUseCase(
          repository: AuthenticationUserRepositoryImpl(
              dataSource: AuthenticationRemoteDataSource()));

      final either = await usecase.call(SignUpParams(
        email: event.email,
        password: event.password,
      ));

      either.either(
        (failure) {
          emit(state.copyWith(status: AuthenticationStatus.authenticated));
          event.onFailure((failure as ServerFailure).message);
        },
        (user) {
          emit(state.copyWith(
            status: AuthenticationStatus.unauthenticated,
            authenticatedUserEntity: user,
          ));
          event.onSuccess();
        },
      );
    });
  }
}
