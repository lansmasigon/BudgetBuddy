import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../../main.dart'; // For convexUrl
import '../../../auth/presentation/providers/auth_provider.dart';

final dashboardDataProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authState = ref.watch(authProvider);
  
  if (authState.isLoading) {
    // Still loading from shared preferences
    return null; // Signals UI to keep showing a loader
  }

  final userId = authState.userId;

  if (userId == null) {
    throw Exception('User not logged in');
  }

  final siteUrl = convexUrl.replaceAll('.cloud', '.site');
  
  final response = await http.post(
    Uri.parse('$siteUrl/api/getDashboard'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'userId': userId}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception('Failed to load dashboard data');
  }
});
