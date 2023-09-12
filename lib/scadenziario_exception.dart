class ScadenziarioException implements Exception {
  String message;
  final bool recoverable;

  ScadenziarioException(this.message, this.recoverable);
}
