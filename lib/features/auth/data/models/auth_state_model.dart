import '../../domain/entities/user_entity.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthStateModel {
  final AuthState state;
  final UserEntity? user;
  final String? errorMessage;

  const AuthStateModel({required this.state, this.user, this.errorMessage});

  AuthStateModel copyWith({
    AuthState? state,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthStateModel(
      state: state ?? this.state,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoading => state == AuthState.loading;
  bool get isAuthenticated => state == AuthState.authenticated;
  bool get isUnauthenticated => state == AuthState.unauthenticated;
  bool get hasError => state == AuthState.error;
  bool get isInitial => state == AuthState.initial;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthStateModel &&
        other.state == state &&
        other.user == user &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => state.hashCode ^ user.hashCode ^ errorMessage.hashCode;

  @override
  String toString() {
    return 'AuthStateModel(state: $state, user: $user, errorMessage: $errorMessage)';
  }
}
