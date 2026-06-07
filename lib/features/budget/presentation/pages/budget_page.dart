import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';

class BudgetPage extends ConsumerWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: dashboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
          data: (data) {
            if (data == null) return const Center(child: CircularProgressIndicator());
            final transactions = data['transactions'] as List<dynamic>;
            double totalExpense = 0;
            for (var tx in transactions) {
              if (tx['type'] == 'expense') totalExpense += tx['amount'];
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  _buildSectionTitle('Spending by Category'),
                  _buildPieChartMock(totalExpense),
                  _buildSectionTitle('Income vs Expenses (6 months)'),
                  _buildBarChartMock(),
                  _buildSectionTitle('50/30/20 Budget Rule'),
                  _buildRuleMock(),
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
              Text('Analytics', style: GoogleFonts.dmSerifDisplay(fontSize: 24, color: AppTheme.textDark)),
              const Text('Financial Insights', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0x1E10B981))),
            child: const Text('June 2025', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.emDk)),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
    );
  }

  Widget _buildPieChartMock(double totalExpense) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1E10B981)),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.emXlt, // Mock for pie chart visual
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('₱${totalExpense.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const Text('total', style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• Food 35%', style: TextStyle(color: AppTheme.em, fontSize: 12)),
                Text('• Transport 20%', style: TextStyle(color: Color(0xFF2563eb), fontSize: 12)),
                Text('• Utilities 18%', style: TextStyle(color: Color(0xFF7c3aed), fontSize: 12)),
                Text('• Entertain 15%', style: TextStyle(color: AppTheme.amber, fontSize: 12)),
                Text('• Other 12%', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBarChartMock() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1E10B981)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar('Jan', 0.6),
              _buildBar('Feb', 0.8),
              _buildBar('Mar', 0.5),
              _buildBar('Apr', 0.9),
              _buildBar('May', 0.7),
              _buildBar('Jun', 0.4),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.square, size: 12, color: AppTheme.em),
              SizedBox(width: 4),
              Text('Income', style: TextStyle(fontSize: 10)),
              SizedBox(width: 16),
              Icon(Icons.square, size: 12, color: AppTheme.red),
              SizedBox(width: 4),
              Text('Expense', style: TextStyle(fontSize: 10)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBar(String label, double heightFactor) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 80 * heightFactor,
          decoration: const BoxDecoration(
            color: AppTheme.em,
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
      ],
    );
  }

  Widget _buildRuleMock() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1E10B981)),
      ),
      child: Column(
        children: [
          _buildRuleBar('Needs (50%)', '₱14,200 / ₱21,000', 0.68, AppTheme.em),
          const SizedBox(height: 12),
          _buildRuleBar('Wants (30%)', '₱11,800 / ₱12,600', 0.94, AppTheme.amber),
          const SizedBox(height: 12),
          _buildRuleBar('Savings (20%)', '₱5,400 / ₱8,400', 0.64, const Color(0xFF2563eb)),
        ],
      ),
    );
  }

  Widget _buildRuleBar(String title, String val, double progress, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            Text(val, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
