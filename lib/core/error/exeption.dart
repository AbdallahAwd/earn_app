import '../network/error_model.dart';

class ServerExeption implements Exception {
  final ErrorModel error;

  ServerExeption(this.error);
}
