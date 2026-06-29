class CodeReview {
  final String id;
  final String code;
  final String language;
  final String? reviewResult;
  final List<String> issues;
  final List<String> suggestions;
  final DateTime createdAt;
  final bool isSuccessful;

  CodeReview({
    required this.id,
    required this.code,
    required this.language,
    this.reviewResult,
    this.issues = const [],
    this.suggestions = const [],
    required this.createdAt,
    this.isSuccessful = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'language': language,
      'reviewResult': reviewResult,
      'issues': issues,
      'suggestions': suggestions,
      'createdAt': createdAt.toIso8601String(),
      'isSuccessful': isSuccessful,
    };
  }

  factory CodeReview.fromJson(Map<String, dynamic> json) {
    return CodeReview(
      id: json['id'],
      code: json['code'],
      language: json['language'],
      reviewResult: json['reviewResult'],
      issues: List<String>.from(json['issues'] ?? []),
      suggestions: List<String>.from(json['suggestions'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      isSuccessful: json['isSuccessful'] ?? true,
    );
  }
}

class ReviewRequest {
  final String code;
  final String language;
  final String? context;

  ReviewRequest({
    required this.code,
    required this.language,
    this.context,
  });
}

class ReviewResponse {
  final String summary;
  final List<Issue> issues;
  final List<Suggestion> suggestions;
  final String? improvedCode;

  ReviewResponse({
    required this.summary,
    required this.issues,
    required this.suggestions,
    this.improvedCode,
  });
}

class Issue {
  final String type; // error, warning, info
  final String message;
  final int? line;
  final String? suggestion;

  Issue({
    required this.type,
    required this.message,
    this.line,
    this.suggestion,
  });
}

class Suggestion {
  final String title;
  final String description;
  final String? codeExample;

  Suggestion({
    required this.title,
    required this.description,
    this.codeExample,
  });
}
