import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get newsApiKey => dotenv.env['NEWS_API_KEY'] ?? '';
  static String get newsApiBaseUrl => dotenv.env['NEWS_API_BASE_URL'] ?? 'https://newsapi.org/v2';
}