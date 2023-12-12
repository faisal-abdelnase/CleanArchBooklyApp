import 'package:dio/dio.dart';

abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);

  factory ServerFailure.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with api server');

      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with api server');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with api server');
      case DioExceptionType.badCertificate:
        return ServerFailure('BadCertificate with api server');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            e.response!.statusCode!, e.response!.data);
      case DioExceptionType.cancel:
        return ServerFailure('Request to ApiServer was canceld');
      case DioExceptionType.connectionError:
        return ServerFailure('No Internet Connection');
      case DioExceptionType.unknown:
        return ServerFailure('Opps There was an Error, Please try again');
    }
  }

  factory ServerFailure.fromResponse(int statesCode, dynamic response) {
    if (statesCode == 404) {
      return ServerFailure('Your request was not found, Please try later');
    } else if (statesCode == 500) {
      return ServerFailure('There is a problem with server, Please try later');
    } else if (statesCode == 400 || statesCode == 401 || statesCode == 403) {
      return ServerFailure(response["error"]["message"]);
    } else {
      return ServerFailure('There was an error , Please try again');
    }
  }
}
