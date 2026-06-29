import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/secure_storage_service.dart';
import '../services/ai_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  bool _notifications = true;
  bool _autoReview = false;
  String _selectedModel = 'llama-3.3-70b-versatile';
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isApiKeyVisible = false;
  bool _isLoading = false;
  bool _hasApiKey = false;
  String? _maskedApiKey;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    
    final hasKey = await SecureStorageService.hasApiKey();
    final apiKey = await SecureStorageService.getApiKey();
    
    setState(() {
      _hasApiKey = hasKey;
      _maskedApiKey = apiKey != null ? _maskApiKey(apiKey) : null;
      _isLoading = false;
    });
  }

  String _maskApiKey(String key) {
    if (key.length <= 8) return '***;
    return '${key.substring(0, 4)}***key.substring(key.length - 4)}';
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveApiKey() async {
    final apiKey = _apiKeyController.text.trim();
    
    if (apiKey.isEmpty) {
      _showSnackBar('API anahtarı boş olamaz', isError: true);
      return;
    }
    
    if (!SecureStorageService.isValidApiKey(apiKey)) {
      _showSnackBar('Geçersiz API anahtarı. gsk_ ile başlamalı', isError: true);
      return;
    }
    
    setState(() => _isLoading = true);
    
    // Validate API key
    final aiService = AiService();
    final isValid = await aiService.validateApiKey(apiKey);
    
    if (!isValid) {
      setState(() => _isLoading = false);
      _showSnackBar('API anahtarı geçersiz veya çalışmıyor', isError: true);
      return;
    }
    
    // Save API key
    final success = await SecureStorageService.saveApiKey(apiKey);
    
    setState(() {
      _isLoading = false;
      _hasApiKey = success;
      _maskedApiKey = success ? _maskApiKey(apiKey) : null;
    });
    
    if (success) {
      _apiKeyController.clear();
      _showSnackBar('API anahtarı kaydedildi');
    } else {
      _showSnackBar('API anahtarı kaydedilemedi', isError: true);
    }
  }

  Future<void> _deleteApiKey() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API Anahtarını Sil'),
        content: const Text('API anahtarını silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final success = await SecureStorageService.deleteApiKey();
      setState(() {
        _hasApiKey = false;
        _maskedApiKey = null;
      });
      _showSnackBar('API anahtarı silindi');
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.errorColor : AppTheme.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.2),
                  AppTheme.secondaryColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primaryColor,
                  child: const Icon(Icons.person, size: 30, color: AppTheme.textPrimary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Code Reviewer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'v1.0.0',
                        style: TextStyle(
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

          // API Settings
          _buildSectionHeader('API Ayarları'),
          _buildSettingsCard([
            // API Key Status
            if (_hasApiKey) ...[
              ListTile(
                leading: Icon(
                  Icons.vpn_key,
                  color: AppTheme.successColor,
                ),
                title: const Text(
                  'API Anahtarı',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                subtitle: Text(
                  _maskedApiKey ?? 'Kayıtlı',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, size: 20),
                      onPressed: () {
                        // Show full key temporarily
                        _showApiKeyDialog();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: AppTheme.errorColor),
                      onPressed: _deleteApiKey,
                    ),
                  ],
                ),
              ),
            ] else ...[
              // API Key Input
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.vpn_key, color: AppTheme.warningColor),
                        const SizedBox(width: 8),
                        const Text(
                          'Groq API Anahtarı Gerekli',
                          style: TextStyle(
                            color: AppTheme.warningColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Groq\'tan ücretsiz API anahtarı almak için:\n'
                      '1. console.groq.com adresine gidin\n'
                      '2. Giriş yapın veya hesap oluşturun\n'
                      '3. API Keys bölümünden anahtar oluşturun',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _apiKeyController,
                      obscureText: !_isApiKeyVisible,
                      style: const TextStyle(color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'gsk_...',
                        hintStyle: TextStyle(color: AppTheme.textHint),
                        prefixIcon: const Icon(Icons.key),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isApiKeyVisible ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() => _isApiKeyVisible = !_isApiKeyVisible);
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _saveApiKey,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.save),
                        label: const Text('Kaydet'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const Divider(),
            
            // Model Selection
            _buildDropdown(
              label: 'AI Model',
              value: _selectedModel,
              items: const [
                'llama-3.3-70b-versatile',
                'openai/gpt-oss-20b',
                'llama-3.1-8b-instant',
                'qwen/qwen3-32b',
                'qwen/qwen3.6-27b',
              ],
              onChanged: (value) {
                setState(() => _selectedModel = value!);
              },
            ),
          ]),
          const SizedBox(height: 24),

          // General Settings
          _buildSectionHeader('Genel Ayarlar'),
          _buildSettingsCard([
            _buildSwitchTile(
              title: 'Karanlık Mod',
              subtitle: 'Tema tercihi',
              value: _darkMode,
              onChanged: (value) {
                setState(() => _darkMode = value);
              },
            ),
            _buildSwitchTile(
              title: 'Bildirimler',
              subtitle: 'Analiz tamamlandığında bildir',
              value: _notifications,
              onChanged: (value) {
                setState(() => _notifications = value);
              },
            ),
            _buildSwitchTile(
              title: 'Otomatik Analiz',
              subtitle: 'Kod yapıştırıldığında otomatik analiz et',
              value: _autoReview,
              onChanged: (value) {
                setState(() => _autoReview = value);
              },
            ),
          ]),
          const SizedBox(height: 24),

          // About
          _buildSectionHeader('Hakkında'),
          _buildSettingsCard([
            _buildNavigationTile(
              icon: Icons.info_outline,
              title: 'Uygulama Hakkında',
              onTap: () => _showAboutDialog(),
            ),
            _buildNavigationTile(
              icon: Icons.star_outline,
              title: 'Puan Ver',
              onTap: () {},
            ),
            _buildNavigationTile(
              icon: Icons.share,
              title: 'Paylaş',
              onTap: () {},
            ),
            _buildNavigationTile(
              icon: Icons.mail_outline,
              title: 'Geri Bildirim Gönder',
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text(
                'Ayarları Kaydet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Footer
          Center(
            child: Text(
              'Made with ❤️ by Reşit Kurt',
              style: TextStyle(
                color: AppTheme.textHint,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: AppTheme.textPrimary),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    String? subtitle,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppTheme.errorColor : AppTheme.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppTheme.errorColor : AppTheme.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        color: AppTheme.textHint,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: AppTheme.surfaceColor,
                style: const TextStyle(color: AppTheme.textPrimary),
                items: items.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ayarlar kaydedildi'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'AI Code Reviewer',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.code,
        size: 48,
        color: AppTheme.primaryColor,
      ),
      children: [
        const Text(
          'Yapay zeka destekli kod inceleme aracı.\n\n'
          'Mobil geliştiriciler için tasarlandı.',
        ),
      ],
    );
  }

  void _showApiKeyDialog() async {
    final apiKey = await SecureStorageService.getApiKey();
    if (apiKey != null && mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('API Anahtarı'),
          content: SelectableText(
            apiKey,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kapat'),
            ),
          ],
        ),
      );
    }
  }
}
