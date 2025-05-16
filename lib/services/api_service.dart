import 'package:flutter_oauth2_login/helpers/constant.dart';
import 'package:flutter_oauth2_login/services/api_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

class ApiService {
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);

  Future<Response> getSecretArea() async {
    var secretUrl = Uri.parse('${Constants.baseUrl}/secret');
    final res = await client.get(secretUrl);
    return res;
  }
}
