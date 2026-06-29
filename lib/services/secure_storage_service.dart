import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  static const String _apiKeyKey = 'groq_api_key';
  static const String _envFileName = '.env';
  
  // Get API Key from secure storage
  static Future<String?> getApiKey() async {
    try {
      // First check SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? apiKey = prefs.getString(_apiKeyKey);
      
      // If not in SharedPreferences, try to read from .env
      if (apiKey == null || apiKey.isEmpty) {
        apiKey = await _readFromEnvFile();
      }
      
      return apiKey;
    } catch (e) {
      debugPrint('Error reading API key: $e');
      return null;
    }
  }
  
  // Save API Key to secure storage and .env file
  static Future<bool> saveApiKey(String apiKey) async {
    try {
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_apiKeyKey, apiKey);
      
      // Also save to .env file for persistence
      await _writeToEnvFile(apiKey);
      
      return true;
    } catch (e) {
      debugPrint('Error saving API key: $e');
      return false;
    }
  }
  
  // Delete API Key
  static Future<bool> deleteApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_apiKeyKey);
      
      // Clear from .env file
      await _clearEnvFile();
      
      return true;
    } catch (e) {
      debugPrint('Error deleting API key: $e');
      return false;
    }
  }
  
  // Check if API Key exists
  static Future<bool> hasApiKey() async {
    final apiKey = await getApiKey();
    return apiKey != null && apiKey.isNotEmpty;
  }
  
  // Validate API Key format
  static bool isValidApiKey(String apiKey) {
    // Groq API keys start with 'gsk_'
    return apiKey.startsWith('gsk_') && apiKey.length > 10;
  }
  
  // Read API key from .env file
  static Future<String?> _readFromEnvFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_envFileName');
      
      if (await file.exists()) {
        final contents = await file.readAsString();
        final lines = contents.split('\n');
        
        for (var line in lines) {
          if (line.startsWith('GROQ_API_KEY=')) {
            return line.substring('GROQ_API_KEY='.length).trim();
          }
        }
      }
      
      return null;
    } catch (e) {
      debugPrint('Error reading .env file: $e');
      return null;
    }
  }
  
  // Write API key to .env file
  static Future<void> _writeToEnvFile(String apiKey) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_envFileName');
      
      String content = '';
      
      // Read existing content if file exists
      if (await file.exists()) {
        content = await file.readAsString();
        // Remove existing GROQ_API_KEY line
        final lines = content.split('\n');
        lines.removeWhere((line) => line.startsWith('GROQ_API_KEY='));
        content = lines.join('\n');
      }
      
      // Add new API key
      if (content.isNotEmpty && !content.endsWith('\n')) {
        content += '\n';
      }
      content += 'GROQ_API_KEY=$apiKey\n';
      
      await file.writeAsString(content);
      debugPrint('API key saved to .env file');
    } catch (e) {
      debugPrint('Error writing .env file: $e');
    }
  }
  
  // Clear .env file
  static Future<void> _clearEnvFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_envFileName');
      
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error clearing .env file: $e');
    }
  }
  
  // Get API key with fallback
  static Future<String> getApiKeyOrDefault({String defaultKey = ''}) async {
    final apiKey = await getApiKey();
    return apiKey ?? defaultKey;
  }
}
