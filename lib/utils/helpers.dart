import 'package:intl/intl.dart';

class AppHelpers {
  // Date Formatting
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
  
  static String formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} yıl önce';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ay önce';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }

  // Code Helpers
  static String detectLanguage(String code) {
    if (code.contains('def ') && code.contains(':')) return 'Python';
    if (code.contains('function ') || code.contains('=>') || code.contains('console.log')) return 'JavaScript';
    if (code.contains('interface ') || code.contains('type ')) return 'TypeScript';
    if (code.contains('func ') || code.contains('import "fmt"')) return 'Go';
    if (code.contains('fn ') || code.contains('let mut')) return 'Rust';
    if (code.contains('public static void main')) return 'Java';
    if (code.contains('#include') || code.contains('std::')) return 'C++';
    if (code.contains('class ') && code.contains('extends')) return 'Swift';
    if (code.contains('fun ') || code.contains('val ')) return 'Kotlin';
    if (code.contains('void main()') || code.contains('Widget')) return 'Dart';
    return 'Unknown';
  }

  // String Helpers
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
  
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  // Validation
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  static bool isValidApiKey(String key) {
    return key.isNotEmpty && key.startsWith('gsk_');
  }

  // Code Analysis Helpers
  static int countLines(String code) {
    return code.split('\n').length;
  }
  
  static int countFunctions(String code) {
    int count = 0;
    if (code.contains('def ')) count += RegExp(r'def \w+').allMatches(code).length;
    if (code.contains('function ')) count += RegExp(r'function \w+').allMatches(code).length;
    if (code.contains('fn ')) count += RegExp(r'fn \w+').allMatches(code).length;
    return count;
  }
  
  static int countClasses(String code) {
    return RegExp(r'class \w+').allMatches(code).length;
  }

  // Error Handling
  static String getErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return 'İnternet bağlantısı yok';
    } else if (error.toString().contains('TimeoutException')) {
      return 'İstek zaman aşımına uğradı';
    } else if (error.toString().contains('401')) {
      return 'API anahtarı geçersiz';
    } else if (error.toString().contains('429')) {
      return 'Çok fazla istek. Lütfen bekleyin';
    } else {
      return 'Bir hata oluştu: ${error.toString()}';
    }
  }
}
