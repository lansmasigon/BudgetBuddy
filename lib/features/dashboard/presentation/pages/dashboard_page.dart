import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);

    return Scaffold(
      body: SafeArea(
        child: dashboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Please login to view dashboard', style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          ),
          data: (data) {
            if (data == null) return const Center(child: CircularProgressIndicator());
            
            final user = data['user'] as Map<String, dynamic>;
            final wallets = data['wallets'] as List<dynamic>;
            final transactions = data['transactions'] as List<dynamic>;

            double totalIncome = 0;
            double totalExpense = 0;
            double totalBalance = 0;

            for (var w in wallets) {
              totalBalance += w['balance'];
            }
            
            for (var tx in transactions) {
              if (tx['type'] == 'income') totalIncome += tx['amount'];
              if (tx['type'] == 'expense') totalExpense += tx['amount'];
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context, user['name'] ?? 'User'),
                  _buildBalanceCard(totalBalance, totalIncome, totalExpense),
                  _buildSectionTitle('My Wallets', 'See all'),
                  _buildWallets(wallets),
                  _buildSectionTitle('Recent Transactions', 'See all'),
                  _buildTransactions(transactions),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name) {
    // Get initials
    String initials = "U";
    if (name.isNotEmpty) {
      final parts = name.split(" ");
      initials = parts.length > 1 ? "${parts[0][0]}${parts[1][0]}" : parts[0][0];
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Good morning,', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
              Text(name, style: GoogleFonts.dmSerifDisplay(fontSize: 24, color: AppTheme.textDark)),
            ],
          ),
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppTheme.emXlt,
                radius: 16,
                child: Icon(Icons.notifications_none, size: 18, color: AppTheme.emDk),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => context.push('/profile'),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [AppTheme.em, AppTheme.navy]),
                  ),
                  alignment: Alignment.center,
                  child: Text(initials.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBalanceCard(double totalBalance, double totalIncome, double totalExpense) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppTheme.emDk, Color(0xFF065f46)]),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TOTAL BALANCE', style: TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 1.2)),
          const SizedBox(height: 4),
          Text('₱${totalBalance.toStringAsFixed(0)}', style: GoogleFonts.dmSerifDisplay(color: Colors.white, fontSize: 40)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStat(Icons.arrow_downward, 'Income', '₱${totalIncome.toStringAsFixed(0)}'),
              Container(width: 1, height: 30, color: Colors.white24, margin: const EdgeInsets.symmetric(horizontal: 14)),
              _buildStat(Icons.arrow_upward, 'Expenses', '₱${totalExpense.toStringAsFixed(0)}'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, String amount) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
            Text(amount, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  Widget _buildSectionTitle(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          Text(action, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.emDk)),
        ],
      ),
    );
  }

  Widget _buildWallets(List<dynamic> wallets) {
    if (wallets.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Text("No wallets found.", style: TextStyle(color: AppTheme.textMuted)),
      );
    }
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: wallets.map((w) {
          final isCash = w['type'] == 'cash';
          return _buildWalletChip(
            w['name'], 
            '₱${(w['balance'] as num).toStringAsFixed(0)}', 
            isCash ? Icons.money : Icons.account_balance_wallet, 
            isCash ? AppTheme.emLt : const Color(0xFFdbeafe), 
            isCash ? AppTheme.emDk : const Color(0xFF2563eb)
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWalletChip(String name, String amount, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x1E10B981)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
          Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
        ],
      ),
    );
  }

  Widget _buildTransactions(List<dynamic> transactions) {
    if (transactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Text("No recent transactions.", style: TextStyle(color: AppTheme.textMuted)),
      );
    }
    
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
