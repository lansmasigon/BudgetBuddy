import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../../main.dart'; // For convexUrl
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';

class TransactionNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false; // isLoading
  }

  Future<bool> addTransaction(String walletId, String type, double amount, String category, String description) async {
    state = true;
    final userId = ref.read(authProvider).userId;
    if (userId == null) {
      state = false;
      return false;
    }

    try {
      final siteUrl = convexUrl.replaceAll('.cloud', '.site');
      final response = await http.post(
        Uri.parse('$siteUrl/api/addTransaction'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'walletName': walletId, // passing the selected wallet string as walletName
          'type': type,
          'amount': amount,
          'category': category,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        // Invalidate dashboard provider so it fetches the new transaction!
        ref.invalidate(dashboardDataProvider);
        state = false;
        return true;
      }
    } catch (e) {
      print(e);
    }
    state = false;
    return false;
  }
}

final transactionsProvider = NotifierProvider<TransactionNotifier, bool>(() {
  return TransactionNotifier();
});
