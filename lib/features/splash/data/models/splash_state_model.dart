// Splash State Model
enum SplashState {
  initial,
  checkingConnection,
  checkingAuth,
  initializingApp,
  ready,
  error,
}

class SplashStateModel {
  final SplashState state;
  final String? errorMessage;
  final double progress;
  final bool isConnected;
  final bool isAuthenticated;

  const SplashStateModel({
    required this.state,
    this.errorMessage,
    this.progress = 0.0,
    this.isConnected = false,
    this.isAuthenticated = false,
  });

  SplashStateModel copyWith({
    SplashState? state,
    String? errorMessage,
    double? progress,
    bool? isConnected,
    bool? isAuthenticated,
  }) {
    return SplashStateModel(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      progress: progress ?? this.progress,
      isConnected: isConnected ?? this.isConnected,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  bool get isLoading =>
      state != SplashState.ready && state != SplashState.error;
  bool get hasError => state == SplashState.error;
  bool get isReady => state == SplashState.ready;
}
