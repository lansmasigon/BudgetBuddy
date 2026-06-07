import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: dashboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (data) {
            if (data == null) return const Center(child: CircularProgressIndicator());
            
            final user = data['user'] as Map<String, dynamic>;
            final name = user['name'] ?? 'Unknown User';
            final email = user['email'] ?? 'No Email';
            
            // Generate initials
            String initials = "U";
            if (name.isNotEmpty) {
              final parts = name.split(" ");
              initials = parts.length > 1 ? "${parts[0][0]}${parts[1][0]}" : parts[0][0];
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHero(name, email, initials),
                  _buildSectionTitle('Achievements', '0 earned'),
                  _buildAchievements(),
                  _buildSectionTitle('Settings', ''),
                  _buildSettingsList(context, ref),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHero(String name, String email, String initials) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 14),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [AppTheme.em, AppTheme.navy]),
            ),
            alignment: Alignment.center,
            child: Text(initials.toUpperCase(), style: GoogleFonts.dmSerifDisplay(color: Colors.white, fontSize: 22)),
          ),
          const SizedBox(height: 10),
          Text(name, style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: AppTheme.textDark)),
          const SizedBox(height: 2),
          Text(email, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: AppTheme.emXlt, borderRadius: BorderRadius.circular(20)),
            child: const Text('Zero-Based Budgeting', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.emDk)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          if (action.isNotEmpty) Text(action, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.emDk)),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Row(
            children: [
              _buildBadge('First Wallet', 'Earned', Icons.account_balance_wallet, AppTheme.emXlt, AppTheme.emDk, 1.0),
              const SizedBox(width: 8),
              _buildBadge('First Goal', 'Earned', Icons.flag, AppTheme.emXlt, AppTheme.emDk, 1.0),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildBadge('First Budget', 'Earned', Icons.pie_chart, AppTheme.emXlt, AppTheme.emDk, 1.0),
              const SizedBox(width: 8),
              _buildBadge('Consistent', 'Locked', Icons.local_fire_department, Colors.grey.shade200, AppTheme.textMuted, 0.4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String title, String sub, IconData icon, Color bg, Color ic, double opacity) {
    return Expanded(
      child: Opacity(
        opacity: opacity,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x1E10B981)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: ic, size: 14),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                    Text(sub, style: const TextStyle(fontSize: 9, color: AppTheme.textMuted)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          _buildSettingsRow(Icons.person, 'Personal Info', 'Name, email', trailing: const Icon(Icons.chevron_right, size: 16)),
          _buildSettingsRow(Icons.dark_mode, 'Appearance', 'Dark mode', trailing: Switch(value: false, onChanged: (v) {}, activeColor: AppTheme.em)),
          _buildSettingsRow(Icons.description, 'Export Report', 'Generate PDF', trailing: const Icon(Icons.chevron_right, size: 16)),
          _buildSettingsRow(Icons.security, 'Security', 'Password, sessions', trailing: const Icon(Icons.chevron_right, size: 16)),
          GestureDetector(
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
            child: _buildSettingsRow(Icons.logout, 'Sign Out', '', iconColor: AppTheme.red, titleColor: AppTheme.red, borderColor: const Color(0x26EF4444)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(IconData icon, String title, String subtitle, {Widget? trailing, Color? iconColor, Color? titleColor, Color? borderColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor ?? const Color(0x1E10B981)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? AppTheme.emDk, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: titleColor ?? AppTheme.textDark)),
                if (subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
