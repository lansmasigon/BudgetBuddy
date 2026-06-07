import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';

class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

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
            // Normally Goals are fetched from data['goals'], but we don't have them in dashboard API yet
            // Let's mock the display using some dynamic calculation if possible or just remove static placeholders
            
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  _buildTotalSavedCard(0, 100000), // mock for MVP
                  _buildSectionTitle('Active Goals'),
                  _buildGoalCards(),
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
              Text('Savings Goals', style: GoogleFonts.dmSerifDisplay(fontSize: 24, color: AppTheme.textDark)),
              const Text('3 active goals', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
            ],
          ),
          const CircleAvatar(
            backgroundColor: AppTheme.emXlt,
            radius: 16,
            child: Icon(Icons.add, size: 18, color: AppTheme.emDk),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSavedCard(double saved, double target) {
    double progress = target == 0 ? 0 : saved / target;
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
          const Text('TOTAL SAVED', style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 4),
          Text('₱${saved.toStringAsFixed(0)}', style: GoogleFonts.dmSerifDisplay(color: Colors.white, fontSize: 32)),
          const SizedBox(height: 4),
          Text('of ₱${target.toStringAsFixed(0)} target · ${(progress * 100).toInt()}% complete', style: const TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            borderRadius: BorderRadius.circular(4),
          ),
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

  Widget _buildGoalCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          _buildGoalCard('Emergency Fund', 'Linked: BDO Bank', Icons.shield, '₱0', '₱50,000', 0, 'Dec 2025', '₱50,000 remaining', AppTheme.em, AppTheme.emXlt, AppTheme.emDk),
        ],
      ),
    );
  }

  Widget _buildGoalCard(String title, String subtitle, IconData icon, String saved, String total, double progress, String date, String remaining, Color color, Color bgBadge, Color txtBadge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1E10B981)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                    Text(subtitle, style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: bgBadge, borderRadius: BorderRadius.circular(12)),
                child: Text('${(progress * 100).toInt()}%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: txtBadge)),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(saved, style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: AppTheme.textDark)),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text('/ $total', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 10, color: AppTheme.textMuted),
                  const SizedBox(width: 4),
                  Text(date, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                ],
              ),
              Text(remaining, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
            ],
          )
        ],
      ),
    );
  }
}
