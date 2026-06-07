import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/transaction_provider.dart';

class AddTransactionDialog extends ConsumerStatefulWidget {
  const AddTransactionDialog({super.key});

  @override
  ConsumerState<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends ConsumerState<AddTransactionDialog> {
  bool isIncome = false;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedWallet = 'Cash';

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
            const Text('Add Transaction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Expense'),
                    selected: !isIncome,
                    onSelected: (val) => setState(() => isIncome = false),
                    selectedColor: AppTheme.red.withOpacity(0.2),
                    labelStyle: TextStyle(color: !isIncome ? AppTheme.red : Colors.black),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Income'),
                    selected: isIncome,
                    onSelected: (val) => setState(() => isIncome = true),
                    selectedColor: AppTheme.emLt,
                    labelStyle: TextStyle(color: isIncome ? AppTheme.emDk : Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount', prefixText: '₱ ', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description (e.g. Lunch)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedWallet,
              decoration: const InputDecoration(labelText: 'Wallet', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                DropdownMenuItem(value: 'GCash', child: Text('GCash')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => selectedWallet = val);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.em,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                final double? amount = double.tryParse(amountController.text);
                if (amount != null && descriptionController.text.isNotEmpty) {
                  // For MVP we just use the name as ID (backend doesn't validate strictly here or we need to look it up)
                  // In a full implementation, the Dropdown should hold the actual Wallet _id from Convex
                  final success = await ref.read(transactionsProvider.notifier).addTransaction(
                    selectedWallet, // Ideally actual _id from convex
                    isIncome ? 'income' : 'expense',
                    amount,
                    isIncome ? 'Income' : 'General',
                    descriptionController.text,
                  );
                  if (success) {
                    if (context.mounted) Navigator.pop(context);
                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction added!')));
                  }
                }
              },
              child: const Text('Save Transaction'),
            )
          ],
        ),
      ),
    );
  }
}
