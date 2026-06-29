import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageSelected;

  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  static const List<String> languageNames = [
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
  ];

  static const List<IconData> languageIcons = [
    Icons.code,
    Icons.javascript,
    Icons.code,
    Icons.phone_iphone,
    Icons.android,
    Icons.flutter_dash,
    Icons.coffee,
    Icons.code,
    Icons.code,
    Icons.code,
  ];

  static const List<Color> languageColors = [
    Color(0xFF3776AB),
    Color(0xFFF7DF1E),
    Color(0xFF3178C6),
    Color(0xFFFA7343),
    Color(0xFF7F52FF),
    Color(0xFF0175C2),
    Color(0xFFED8B00),
    Color(0xFF00599C),
    Color(0xFF00ADD8),
    Color(0xFFCE422B),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: languageNames.length,
        itemBuilder: (context, index) {
          final isSelected = selectedLanguage == languageNames[index];
          final color = languageColors[index];

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => onLanguageSelected(languageNames[index]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 80,
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withOpacity(0.2)
                      : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? color
                        : AppTheme.textHint.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      languageIcons[index],
                      color: isSelected
                          ? color
                          : AppTheme.textSecondary,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      languageNames[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? color
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
