import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/code_review.dart';
import 'secure_storage_service.dart';

class AiService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1';
  static const String _model = 'llama-3.3-70b-versatile';
  
  String? _cachedApiKey;
  String? _selectedModel;

  // Set custom model
  void setModel(String model) {
    _selectedModel = model;
  }
  
  // Get current model
  String get currentModel => _selectedModel ?? _model;

  Future<ReviewResponse> reviewCode(ReviewRequest request) async {
    // Get API key from secure storage
    final apiKey = await SecureStorageService.getApiKey();
    
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API anahtarı bulunamadı. Lütfen ayarlardan girin.');
    }
    
    _cachedApiKey = apiKey;

    final prompt = _buildReviewPrompt(request);
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': currentModel,
          'messages': [
            {
              'role': 'system',
              'content': '''You are an expert code reviewer. Analyze the provided code and return a detailed review in JSON format with the following structure:
{
  "summary": "Brief overall assessment",
  "issues": [
    {
      "type": "error|warning|info",
      "message": "Description of the issue",
      "line": null,
      "suggestion": "How to fix it"
    }
  ],
  "suggestions": [
    {
      "title": "Suggestion title",
      "description": "Detailed description",
      "codeExample": "Optional code example"
    }
  ],
  "improvedCode": "Optional improved version of the code"
}

Be thorough but constructive. Focus on:
- Code quality and best practices
- Performance optimizations
- Security vulnerabilities
- Readability and maintainability
- Language-specific conventions'''
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.3,
          'max_tokens': 2000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return _parseReviewResponse(content);
      } else if (response.statusCode == 401) {
        throw Exception('API anahtarı geçersiz. Lütfen ayarlardan güncelleyin.');
      } else if (response.statusCode == 429) {
        throw Exception('Çok fazla istek. Lütfen biraz bekleyin.');
      } else {
        throw Exception('API hatası: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('İnternet bağlantısı yok');
      }
      throw Exception('Kod analizi başarısız: $e');
    }
  }

  String _buildReviewPrompt(ReviewRequest request) {
    String prompt = 'Language: ${request.language}\n\nCode to review:\n```${request.language}\n${request.code}\n```';
    
    if (request.context != null && request.context!.isNotEmpty) {
      prompt += '\n\nAdditional context: ${request.context}';
    }
    
    return prompt;
  }

  ReviewResponse _parseReviewResponse(String content) {
    try {
      // Try to extract JSON from the response
      final jsonStart = content.indexOf('{');
      final jsonEnd = content.lastIndexOf('}');
      
      if (jsonStart != -1 && jsonEnd != -1) {
        final jsonStr = content.substring(jsonStart, jsonEnd + 1);
        final data = jsonDecode(jsonStr);
        
        return ReviewResponse(
          summary: data['summary'] ?? 'Review completed',
          issues: (data['issues'] as List?)
              ?.map((e) => Issue(
                    type: e['type'] ?? 'info',
                    message: e['message'] ?? '',
                    line: e['line'],
                    suggestion: e['suggestion'],
                  ))
              .toList() ?? [],
          suggestions: (data['suggestions'] as List?)
              ?.map((e) => Suggestion(
                    title: e['title'] ?? '',
                    description: e['description'] ?? '',
                    codeExample: e['codeExample'],
                  ))
              .toList() ?? [],
          improvedCode: data['improvedCode'],
        );
      }
    } catch (e) {
      // If JSON parsing fails, return raw content
    }
    
    // Fallback: return raw content as summary
    return ReviewResponse(
      summary: content,
      issues: [],
      suggestions: [],
    );
  }
  
  // Validate API key by making a test request
  Future<bool> validateApiKey(String apiKey) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant',
          'messages': [
            {
              'role': 'user',
              'content': 'Test',
            }
          ],
          'max_tokens': 1,
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
