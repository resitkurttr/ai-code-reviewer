class AppConstants {
  // App Info
  static const String appName = 'AI Code Reviewer';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Yapay zeka destekli kod inceleme aracı';
  
  // API
  static const String apiBaseUrl = 'https://api.groq.com/openai/v1';
  static const String defaultModel = 'llama-3.3-70b-versatile';
  
  // Supported Languages
  static const List<String> supportedLanguages = [
    'Python',
    'JavaScript',
    'TypeScript',
    'Swift',
    'Kotlin',
    'Dart',
    'Java',
    'C++',
    'Go',
    'Rust',
    'C#',
    'PHP',
    'Ruby',
    'Scala',
    'Kotlin',
  ];
  
  // Storage Keys
  static const String reviewsKey = 'reviews';
  static const String settingsKey = 'settings';
  static const String apiKeyKey = 'api_key';
  
  // Limits
  static const int maxCodeLength = 10000;
  static const int maxReviewHistory = 100;
  static const int maxTokens = 2000;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
