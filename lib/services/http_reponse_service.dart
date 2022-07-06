import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<http.Response> getRequestHttpResponse(
      {required String url, dynamic headers}) async {
    http.Response response =
        await http.get(Uri.parse(url), headers: headers ?? null);
    try {
      return response;
    } catch (exp) {
      throw Exception("error :$exp");
    }
  }

  static Future<http.Response> postRequestHttpResponse(
      {required String url, dynamic headers, dynamic body}) async {
    try {
      http.Response response = await http.post(Uri.parse(url),
          headers: headers ?? null, body: body ?? null);
      return response;
    } catch (exp) {
      throw Exception("error :$exp");
    }
  }

  static Future<http.Response> putRequestHttpResponse(
      {required String url, dynamic headers, dynamic body}) async {
    http.Response response = await http.put(Uri.parse(url),
        headers: headers ?? null, body: body ?? null);
    try {
      return response;
    } catch (exp) {
      throw Exception("error :$exp");
    }
  }

  static Future<http.Response> removeRequestHttpResponse(
      {required String url, dynamic headers, dynamic body}) async {
    http.Response response = await http.delete(Uri.parse(url),
        headers: headers ?? null, body: body ?? null);
    try {
      return response;
    } catch (exp) {
      throw Exception("error :$exp");
    }
  }
}
