class ScadenziarioException implements Exception {
  String cause;
  final bool recoverable;

  ScadenziarioException(this.cause, this.recoverable);
}
