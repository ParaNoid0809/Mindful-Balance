import 'package:dio/dio.dart';

class MoodService {
  static const String baseUrl = 'https://mindfulbalance-api-1.onrender.com';
  final Dio _dio;

  MoodService() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.sendTimeout = const Duration(seconds: 10);
    _dio.options.validateStatus = (status) {
      return status != null && status >= 200 && status < 500;
    };

    // Add logging interceptor for debugging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[Dio] $obj'),
      ),
    );
  }

  Future<Map<String, dynamic>> predictMood(String journalText) async {
    try {
      print('[MoodService] 🔍 Sending mood prediction request...');
      print('[MoodService] 📝 Journal text: $journalText');

      // Ensure the request body matches the API's expected format
      final requestBody = {'journal': journalText, 'language': 'en'};

      print('[MoodService] 📤 Request body: $requestBody');

      final response = await _dio.post('/predict/mood', data: requestBody);

      print('[MoodService] 📨 Response status: ${response.statusCode}');
      print('[MoodService] 🧾 Response data: ${response.data}');

      if (response.data is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print('[MoodService] ❗ DioError: ${e.message}');
      print('[MoodService] ❗ DioError Type: ${e.type}');
      print('[MoodService] ❗ DioError StackTrace: ${e.stackTrace}');
      print('[MoodService] 📄 Response data: ${e.response?.data}');
      print('[MoodService] 📄 Error: ${e.error}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return {
          'error':
              'Connection timed out. Please check your internet connection and try again.',
        };
      }

      if (e.type == DioExceptionType.connectionError) {
        return {
          'error':
              'Unable to connect to the server. Please check your internet connection and try again.',
        };
      }

      if (e.response?.statusCode == 422) {
        final detail = e.response?.data['detail'];
        if (detail is List && detail.isNotEmpty) {
          return {'error': detail[0]['msg'] ?? 'Validation error occurred'};
        }
      }

      return {
        'error':
            e.response?.data?['detail'] ??
            e.message ??
            'An unknown error occurred',
      };
    } catch (e) {
      print('[MoodService] ❗ Unexpected error: $e');
      return {'error': 'An unexpected error occurred: $e'};
    }
  }
}
