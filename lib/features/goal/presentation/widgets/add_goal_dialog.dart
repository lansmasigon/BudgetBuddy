import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';

class AddGoalDialog extends ConsumerStatefulWidget {
  const AddGoalDialog({super.key});

  @override
  ConsumerState<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends ConsumerState<AddGoalDialog> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Add Savings Goal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Goal Name (e.g. New Laptop)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Target Amount', prefixText: '₱ ', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Target Date (e.g. Dec 2025)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.em,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: isLoading ? null : () async {
                final amount = double.tryParse(amountController.text);
                if (amount != null && nameController.text.isNotEmpty) {
                  setState(() => isLoading = true);
                  
                  final userId = ref.read(authProvider).userId;
                  final siteUrl = convexUrl.replaceAll('.cloud', '.site');
                  
                  try {
                    await http.post(
                      Uri.parse('$siteUrl/api/addGoal'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'userId': userId,
                        'name': nameController.text,
                        'targetAmount': amount,
                        'targetDate': dateController.text,
                      }),
                    );
                    
                    ref.invalidate(dashboardDataProvider);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Goal added!')));
                    }
                  } catch (e) {
                    setState(() => isLoading = false);
                  }
                }
              },
              child: isLoading ? const CircularProgressIndicator() : const Text('Save Goal'),
            )
          ],
        ),
      ),
    );
  }
}
