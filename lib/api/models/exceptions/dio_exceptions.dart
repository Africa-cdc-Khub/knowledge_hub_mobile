import 'package:dio/dio.dart';

class DioExceptions implements Exception{
  late String errorMessage;

  DioExceptions.fromDioError(DioException dioError){
    switch(dioError.type){
    //DioExceptionType
      case DioExceptionType.connectionTimeout:
        errorMessage = "Connection timed out.";
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = "Request send timed out.";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "Receiving timed out.";
        break;
      case DioExceptionType.unknown:
        errorMessage = _handleStatusCode(dioError.response);
        break;
      case DioExceptionType.cancel:
        errorMessage = "Request to the server was cancelled.";
        break;
        /*
      case DioExceptionType.other:
        if(dioError.message.contains('SocketException')){
          errorMessage = 'No Internet Connection';
          break;
        }
        errorMessage = 'Unexpected error occurred.';
        break;
         */
      default:
        errorMessage = 'Oops! Something went wrong';
        break;
    }
  }

  String _handleStatusCode(Response? response) {
    switch(response?.statusCode){
      case 400:
        return  'Bad Request';
      case 401:
        return response != null ?  response.data['message'] : 'Wrong authentication details provided';
      case 403:
        return 'The authenticated user is not authorised to make this request';
      case 405:
        return 'Method not allowed.';
      case 404:
        return  response != null ?  response.data['body']['message'] : 'Request not found';
      case 415:
        return 'Unsupported media type.';
      case 417:
        return response != null ?  response.data['message'] :  'Undefined error.';
      case 429:
        return 'Too many requests.';
      case 500:
        return 'Internal server error.';
      default:
        return 'Oops! Something went wrong.';

    }
  }

  @override
  String toString() => errorMessage;

}
