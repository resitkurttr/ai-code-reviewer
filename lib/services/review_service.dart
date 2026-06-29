import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/code_review.dart';
import 'ai_service.dart';

class ReviewService extends ChangeNotifier {
  final AiService _aiService = AiService();
  List<CodeReview> _reviews = [];
  bool _isReviewing = false;
  String? _error;

  List<CodeReview> get reviews => _reviews;
  bool get isReviewing => _isReviewing;
  String? get error => _error;

  ReviewService() {
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reviewsJson = prefs.getString('reviews') ?? '[]';
      final List<dynamic> reviewsList = jsonDecode(reviewsJson);
      _reviews = reviewsList.map((json) => CodeReview.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load reviews: $e';
      notifyListeners();
    }
  }

  Future<void> _saveReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reviewsJson = jsonEncode(_reviews.map((r) => r.toJson()).toList());
      await prefs.setString('reviews', reviewsJson);
    } catch (e) {
      _error = 'Failed to save reviews: $e';
    }
  }

  Future<CodeReview> reviewCode({
    required String code,
    required String language,
    String? context,
  }) async {
    _isReviewing = true;
    _error = null;
    notifyListeners();

    try {
      final request = ReviewRequest(
        code: code,
        language: language,
        context: context,
      );

      final response = await _aiService.reviewCode(request);

      final review = CodeReview(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        code: code,
        language: language,
        reviewResult: response.summary,
        issues: response.issues.map((e) => e.message).toList(),
        suggestions: response.suggestions.map((e) => e.title).toList(),
        createdAt: DateTime.now(),
        isSuccessful: true,
      );

      _reviews.insert(0, review);
      await _saveReviews();
      
      _isReviewing = false;
      notifyListeners();
      
      return review;
    } catch (e) {
      _error = e.toString();
      _isReviewing = false;
      notifyListeners();
      
      // Return failed review
      final failedReview = CodeReview(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        code: code,
        language: language,
        reviewResult: 'Review failed: $e',
        createdAt: DateTime.now(),
        isSuccessful: false,
      );
      
      _reviews.insert(0, failedReview);
      await _saveReviews();
      
      return failedReview;
    }
  }

  Future<void> deleteReview(String id) async {
    _reviews.removeWhere((r) => r.id == id);
    await _saveReviews();
    notifyListeners();
  }

  Future<void> clearAllReviews() async {
    _reviews.clear();
    await _saveReviews();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
