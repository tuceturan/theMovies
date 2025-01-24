import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiUrl = "https://api.themoviedb.org/3/";
  static const String _filterUrl = "search/movie";
  static const String _listUrl = "movie/popular";
  static const String _apiKey = "";

  static Future<Map> listMovies({int page = 1}) async {
    final response = await http
        .get(Uri.parse("$_apiUrl$_listUrl?api_key=$_apiKey&page=$page"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception("Failed to load movies");
    }
  }

  static Future<Map> filterMovies(String filter, {int page = 1}) async {
    final response = await http.get(Uri.parse(
        "$_apiUrl$_filterUrl?api_key=$_apiKey&query=$filter&page=$page"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception("Failed to load movies");
    }
  }
}
