//400
class BadRequest implements Exception {
  final String message;
  BadRequest(this.message);
}

//401
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

//404
class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

//409
class UserAlreadyExists implements Exception {
  final String message;
  UserAlreadyExists(this.message);
}

//440
class LoginTimeOutException implements Exception {
  final String message;

  LoginTimeOutException(this.message);
}

//500
class InternalServerErrorException implements Exception {
  final String message;

  InternalServerErrorException(this.message);
}
