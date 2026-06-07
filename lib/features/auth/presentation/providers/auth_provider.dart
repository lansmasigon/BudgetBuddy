import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../main.dart'; // For convexUrl

class AuthState {
  final bool isLoading;
  final String? userId;
  final String? error;

  AuthState({this.isLoading = false, this.userId, this.error});

  AuthState copyWith({bool? isLoading, String? userId, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _loadSession();
    return AuthState(isLoading: true);
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId');
    state = AuthState(isLoading: false, userId: id);
  }

  Future<bool> registerUser(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Convert .cloud to .site for HTTP Actions
      final siteUrl = convexUrl.replaceAll('.cloud', '.site');
      
      final response = await http.post(
        Uri.parse('$siteUrl/api/createUser'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userId = data['userId'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        
        state = AuthState(isLoading: false, userId: userId);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Registration failed');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final siteUrl = convexUrl.replaceAll('.cloud', '.site');
      final response = await http.post(
        Uri.parse('$siteUrl/api/loginUser'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userId = data['userId'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        
        state = AuthState(isLoading: false, userId: userId);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Invalid credentials');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    state = AuthState(isLoading: false, userId: null);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
