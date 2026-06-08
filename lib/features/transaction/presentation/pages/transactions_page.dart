import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';

class TransactionFilterNotifier extends Notifier<String> {
  @override
  String build() => 'All';
  void setFilter(String filter) => state = filter;
}

final transactionFilterProvider = NotifierProvider<TransactionFilterNotifier, String>(() => TransactionFilterNotifier());

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);
    final filter = ref.watch(transactionFilterProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: dashboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
          data: (data) {
            if (data == null) return const Center(child: CircularProgressIndicator());
            List<dynamic> transactions = data['transactions'] as List<dynamic>;

            // Filter the list
            if (filter == 'Income') {
              transactions = transactions.where((tx) => tx['type'] == 'income').toList();
            } else if (filter == 'Expense') {
              transactions = transactions.where((tx) => tx['type'] == 'expense').toList();
            } else if (filter == 'Transfer') {
              transactions = transactions.where((tx) => tx['type'] == 'transfer').toList();
            }

            double totalIncome = 0;
            double totalExpense = 0;
            for (var tx in data['transactions']) {
              if (tx['type'] == 'income') totalIncome += tx['amount'];
              if (tx['type'] == 'expense') totalExpense += tx['amount'];
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  _buildSummaryCards(totalIncome, totalExpense),
                  _buildFilterTabs(ref, filter),
                  _buildDateLabel('RECENT'),
                  _buildTransactionsList(transactions),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Transactions', style: GoogleFonts.dmSerifDisplay(fontSize: 24, color: AppTheme.textDark)),
              const Text('All History', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
            ],
          ),
          const CircleAvatar(
            backgroundColor: AppTheme.emXlt,
            radius: 16,
            child: Icon(Icons.tune, size: 16, color: AppTheme.emDk),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(double income, double expense) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.emXlt, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0x2610B981))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.trending_up, size: 12, color: AppTheme.emDk),
                      SizedBox(width: 4),
                      Text('Income', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.emDk)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('₱${income.toStringAsFixed(0)}', style: GoogleFonts.dmSerifDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.emDk)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFfff1f2), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0x1FEF4444))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.trending_down, size: 12, color: AppTheme.red),
                      SizedBox(width: 4),
                      Text('Expenses', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.red)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('₱${expense.toStringAsFixed(0)}', style: GoogleFonts.dmSerifDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.red)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(WidgetRef ref, String currentFilter) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          _buildTab(ref, currentFilter, 'All'),
          _buildTab(ref, currentFilter, 'Income'),
          _buildTab(ref, currentFilter, 'Expense'),
          _buildTab(ref, currentFilter, 'Transfer'),
        ],
      ),
    );
  }

  Widget _buildTab(WidgetRef ref, String currentFilter, String label) {
    final isActive = currentFilter == label;
    return GestureDetector(
      onTap: () => ref.read(transactionFilterProvider.notifier).setFilter(label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.em : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? AppTheme.em : const Color(0x1E10B981)),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isActive ? Colors.white : AppTheme.textMuted),
        ),
      ),
    );
  }

  Widget _buildDateLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 4),
      child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textMuted, letterSpacing: 1.2)),
    );
  }

  Widget _buildTransactionsList(List<dynamic> transactions) {
    if (transactions.isEmpty) return const Center(child: Text("No transactions found"));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: transactions.map((tx) {
          final isIncome = tx['type'] == 'income';
          return _buildTxnItem(
            tx['category'] ?? 'General',
            '${tx['type'].toString().toUpperCase()}',
            '${isIncome ? '+' : '-'}₱${(tx['amount'] as num).toStringAsFixed(0)}',
            isIncome,
            isIncome ? Icons.work : Icons.fastfood,
            isIncome ? AppTheme.emLt : const Color(0xFFfff7ed),
            isIncome ? AppTheme.emDk : const Color(0xFFea580c),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTxnItem(String name, String sub, String amt, bool isIncome, IconData icon, Color bg, Color ic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1E10B981)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: ic, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                Text(sub, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
          ),
          Text(amt, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isIncome ? AppTheme.emDk : AppTheme.red)),
        ],
      ),
    );
  }
}
