import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../theme/app_theme.dart';
import '../models/code_review.dart';

class ReviewDetailScreen extends StatelessWidget {
  final CodeReview review;

  const ReviewDetailScreen({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analiz Sonucu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: review.reviewResult ?? ''));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sonuç kopyalandı'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: review.isSuccessful
                    ? AppTheme.successColor.withOpacity(0.1)
                    : AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: review.isSuccessful
                      ? AppTheme.successColor
                      : AppTheme.errorColor,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    review.isSuccessful ? Icons.check_circle : Icons.error,
                    color: review.isSuccessful
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.isSuccessful ? 'Analiz Başarılı' : 'Analiz Başarısız',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: review.isSuccessful
                                ? AppTheme.successColor
                                : AppTheme.errorColor,
                          ),
                        ),
                        Text(
                          '${review.language} • ${_formatDate(review.createdAt)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Review Result
            if (review.reviewResult != null) ...[
              const Text(
                'AI Değerlendirmesi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: MarkdownBody(
                  data: review.reviewResult!,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(color: AppTheme.textPrimary, height: 1.5),
                    code: TextStyle(
                      backgroundColor: AppTheme.cardColor,
                      color: AppTheme.secondaryColor,
                      fontFamily: 'monospace',
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Issues
            if (review.issues.isNotEmpty) ...[
              Row(
                children: [
                  Icon(Icons.warning_amber, color: AppTheme.warningColor),
                  const SizedBox(width: 8),
                  Text(
                    'Sorunlar (${review.issues.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...review.issues.map((issue) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.warningColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  issue,
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
              )),
            ],
            const SizedBox(height: 24),

            // Suggestions
            if (review.suggestions.isNotEmpty) ...[
              Row(
                children: [
                  Icon(Icons.lightbulb, color: AppTheme.secondaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Öneriler (${review.suggestions.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...review.suggestions.map((suggestion) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.secondaryColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  suggestion,
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
              )),
            ],
            const SizedBox(height: 24),

            // Original Code
            const Text(
              'İncelenen Kod',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                review.code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: AppTheme.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
