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

  static const List<Map<String, dynamic>> languages = [
    {'name': 'Python', 'icon': Icons.code, 'color': Color(0xFF3776AB)},
    {'name': 'JavaScript', 'icon': Icons.javascript, 'color': Color(0xFFF7DF1E)},
    {'name': 'TypeScript', 'icon': Icons.code, 'color': Color(0xFF3178C6)},
    {'name': 'Swift', 'icon': Icons.phone_ios, 'color': Color(0xFFFA7343)},
    {'name': 'Kotlin', 'icon': Icons.android, 'color': Color(0xFF7F52FF)},
    {'name': 'Dart', 'icon': Icons.flutter_dash, 'color': Color(0xFF0175C2)},
    {'name': 'Java', 'icon': Icons.coffee, 'color': Color(0xFFED8B00)},
    {'name': 'C++', 'icon': Icons.code, 'color': Color(0xFF00599C)},
    {'name': 'Go', 'icon': Icons.code, 'color': Color(0xFF00ADD8)},
    {'name': 'Rust', 'icon': Icons.code, 'color': Color(0xFFCE422B)},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final lang = languages[index];
          final isSelected = selectedLanguage == lang['name'];
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => onLanguageSelected(lang['name']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 80,
                decoration: BoxDecoration(
                  color: isSelected
                      ? (lang['color'] as Color).withOpacity(0.2)
                      : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? lang['color'] as Color
                        : AppTheme.textHint.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      lang['icon'] as IconData,
                      color: isSelected
                          ? lang['color'] as Color
                          : AppTheme.textSecondary,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lang['name'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? lang['color'] as Color
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
