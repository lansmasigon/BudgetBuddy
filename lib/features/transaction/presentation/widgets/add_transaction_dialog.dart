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
  String selectedType = 'expense';
  final TextEditingController amountController = TextEditingController();
  String? selectedCategory;
  String selectedWallet = 'Cash';
  String transferFromWallet = 'Cash';
  String transferToWallet = 'GCash';

  final List<String> categories = [
    'Food',
    'Transportation',
    'Electricity',
    'Water',
    'Internet',
    'Salary',
    'General',
  ];

  @override
  Widget build(BuildContext context) {
    final isTransfer = selectedType == 'transfer';
    
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Expense'),
                    selected: selectedType == 'expense',
                    onSelected: (val) => setState(() => selectedType = 'expense'),
                    selectedColor: AppTheme.red.withOpacity(0.2),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Income'),
                    selected: selectedType == 'income',
                    onSelected: (val) => setState(() => selectedType = 'income'),
                    selectedColor: AppTheme.emLt,
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Transfer'),
                    selected: isTransfer,
                    onSelected: (val) => setState(() => selectedType = 'transfer'),
                    selectedColor: Colors.blue.withOpacity(0.2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount', prefixText: '₱ ', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            if (!isTransfer) ...[
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => selectedCategory = val);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedWallet,
                decoration: const InputDecoration(labelText: 'Wallet', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'GCash', child: Text('GCash')),
                  DropdownMenuItem(value: 'Maya', child: Text('Maya')),
                  DropdownMenuItem(value: 'Bank', child: Text('Bank')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => selectedWallet = val);
                },
              ),
            ] else ...[
              DropdownButtonFormField<String>(
                value: transferFromWallet,
                decoration: const InputDecoration(labelText: 'Transfer From', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'GCash', child: Text('GCash')),
                  DropdownMenuItem(value: 'Maya', child: Text('Maya')),
                  DropdownMenuItem(value: 'Bank', child: Text('Bank')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => transferFromWallet = val);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: transferToWallet,
                decoration: const InputDecoration(labelText: 'Transfer To', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'GCash', child: Text('GCash')),
                  DropdownMenuItem(value: 'Maya', child: Text('Maya')),
                  DropdownMenuItem(value: 'Bank', child: Text('Bank')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => transferToWallet = val);
                },
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.em,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                final double? amount = double.tryParse(amountController.text);
                if (amount != null) {
                  if (isTransfer) {
                    // MVP Transfer: Withdraw from one, deposit to another
                    await ref.read(transactionsProvider.notifier).addTransaction(
                      transferFromWallet, 'expense', amount, 'Transfer', 'To $transferToWallet',
                    );
                    await ref.read(transactionsProvider.notifier).addTransaction(
                      transferToWallet, 'income', amount, 'Transfer', 'From $transferFromWallet',
                    );
                  } else {
                    if (selectedCategory == null) return;
                    await ref.read(transactionsProvider.notifier).addTransaction(
                      selectedWallet,
                      selectedType,
                      amount,
                      selectedCategory!,
                      selectedCategory!, // Use category as description for now
                    );
                  }
                  if (context.mounted) Navigator.pop(context);
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction added!')));
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
