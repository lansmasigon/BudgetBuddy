import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'login_page.dart';
import 'register_page.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _heroCtrl;
  late final AnimationController _cardCtrl;
  late final Animation<double> _fadeHero;
  late final Animation<Offset> _slideHero;
  late final Animation<double> _fadeCards;

  @override
  void initState() {
    super.initState();

    _heroCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _cardCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeHero = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _slideHero = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOutCubic));

    _fadeCards = CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut);

    _heroCtrl.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _cardCtrl.forward();
    });
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _cardCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF6FAF8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNavBar(context, isDark),
              _buildHeroSection(context, isDark, size),
              _buildFeaturesSection(context, isDark),
              _buildBudgetMethodsSection(context, isDark),
              _buildCtaSection(context, isDark),
              _buildFooter(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Navigation Bar ───────────────────────────────────────────────────────

  Widget _buildNavBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Logo
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.emerald500, AppColors.emerald700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.savings_outlined,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'BudgetBuddy',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 18,
                color: isDark ? Colors.white : AppColors.gray900,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
            child: Text(
              'Login',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.emerald600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _PrimaryButton(
            label: 'Get Started',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            ),
            compact: true,
          ),
        ],
      ),
    );
  }

  // ─── Hero Section ─────────────────────────────────────────────────────────

  Widget _buildHeroSection(
      BuildContext context, bool isDark, Size size) {
    return FadeTransition(
      opacity: _fadeHero,
      child: SlideTransition(
        position: _slideHero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.emerald50,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                      color: AppColors.emerald500.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.emerald500,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Your Guide, Your Money, BudgetBuddy',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.emerald700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Headline
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Take Control\nOf Your ',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 38,
                        height: 1.15,
                        color: isDark ? Colors.white : AppColors.gray900,
                      ),
                    ),
                    TextSpan(
                      text: 'Finances',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 38,
                        height: 1.15,
                        color: AppColors.emerald600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Track expenses, build budgets, and grow\nyour savings — all in one beautiful app.',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  height: 1.6,
                  color: isDark ? AppColors.gray400 : AppColors.gray500,
                ),
              ),
              const SizedBox(height: 28),
              // CTA buttons
              Row(
                children: [
                  Expanded(
                    child: _PrimaryButton(
                      label: 'Start for Free',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OutlineButton(
                      label: 'See Features',
                      onTap: () {},
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Mock balance card
              _MockBalanceCard(isDark: isDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Features Section ─────────────────────────────────────────────────────

  Widget _buildFeaturesSection(BuildContext context, bool isDark) {
    final features = [
      _FeatureData(
        icon: Icons.account_balance_wallet_outlined,
        color: AppColors.emerald600,
        bg: AppColors.emerald50,
        title: 'Smart Wallets',
        desc: 'Manage Cash, GCash, Maya & bank accounts in one place.',
      ),
      _FeatureData(
        icon: Icons.pie_chart_outline,
        color: AppColors.blue600,
        bg: const Color(0xFFEFF6FF),
        title: 'Budget Methods',
        desc: 'Category, 50/30/20 Rule, or Zero-Based — you choose.',
      ),
      _FeatureData(
        icon: Icons.savings_outlined,
        color: AppColors.purple600,
        bg: const Color(0xFFF3E8FF),
        title: 'Savings Goals',
        desc: 'Set targets, link wallets, and watch your goals grow.',
      ),
      _FeatureData(
        icon: Icons.insert_chart_outlined,
        color: AppColors.amber500,
        bg: const Color(0xFFFEF3C7),
        title: 'Analytics',
        desc: 'Visual charts to understand where your money goes.',
      ),
      _FeatureData(
        icon: Icons.repeat_outlined,
        color: const Color(0xFFEA580C),
        bg: const Color(0xFFFFF7ED),
        title: 'Recurring Entries',
        desc: 'Automate salary, bills, and subscriptions.',
      ),
      _FeatureData(
        icon: Icons.picture_as_pdf_outlined,
        color: AppColors.navy500,
        bg: const Color(0xFFE8EEF7),
        title: 'PDF Reports',
        desc: 'Export and share financial summaries anytime.',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTag(label: 'Features'),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Everything You Need\n',
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 28,
                    color: isDark ? Colors.white : AppColors.gray900,
                  ),
                ),
                TextSpan(
                  text: 'to Budget Better',
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 28,
                    color: AppColors.emerald600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: features.length,
            itemBuilder: (_, i) => _FeatureCard(
              data: features[i],
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Budget Methods Section ───────────────────────────────────────────────

  Widget _buildBudgetMethodsSection(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTag(label: 'Budgeting'),
          const SizedBox(height: 10),
          Text(
            'Your Style,\nYour Rules',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 28,
              height: 1.2,
              color: isDark ? Colors.white : AppColors.gray900,
            ),
          ),
          const SizedBox(height: 20),
          _BudgetMethodCard(
            emoji: '📊',
            title: 'Category Budgeting',
            desc: 'Assign spending limits per category. Full control over every peso.',
            color: AppColors.emerald600,
            bg: isDark ? AppColors.darkCard : AppColors.emerald50,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _BudgetMethodCard(
            emoji: '⚖️',
            title: '50/30/20 Rule',
            desc: '50% Needs · 30% Wants · 20% Savings. A proven, effortless method.',
            color: AppColors.blue600,
            bg: isDark ? AppColors.darkCard : const Color(0xFFEFF6FF),
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _BudgetMethodCard(
            emoji: '🎯',
            title: 'Zero-Based Budgeting',
            desc: 'Every peso has a purpose. Allocate your income down to zero.',
            color: AppColors.purple600,
            bg: isDark ? AppColors.darkCard : const Color(0xFFF3E8FF),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  // ─── CTA Section ──────────────────────────────────────────────────────────

  Widget _buildCtaSection(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.emerald700, AppColors.emerald900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Start Your Financial\nJourney Today',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 26,
                height: 1.2,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Join 50,000+ Filipinos building better\nmoney habits with BudgetBuddy.',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                height: 1.6,
                color: Colors.white.withOpacity(0.75),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.emerald700,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Create Free Account',
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Footer ───────────────────────────────────────────────────────────────

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      child: Column(
        children: [
          Divider(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : AppColors.gray200,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.emerald500, AppColors.emerald700],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.savings_outlined,
                    color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              Text(
                'BudgetBuddy',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 15,
                  color: isDark ? Colors.white : AppColors.gray900,
                ),
              ),
              const Spacer(),
              Text(
                '© 2025',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: AppColors.gray400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Empowering financial literacy for every Filipino.',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: AppColors.gray400,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool compact;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 38 : 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emerald600,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(compact ? 10 : 14),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: compact ? 13 : 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _OutlineButton({
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor:
              isDark ? Colors.white : AppColors.gray800,
          side: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.15)
                : AppColors.gray200,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _MockBalanceCard extends StatelessWidget {
  final bool isDark;
  const _MockBalanceCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.emerald700, AppColors.emerald900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.emerald600.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL BALANCE',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.65),
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  'June 2025',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '₱84,520.00',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 34,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _MiniStat(
                  icon: Icons.arrow_downward_rounded,
                  label: 'Income',
                  value: '₱42,000'),
              Container(
                width: 1,
                height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white.withOpacity(0.2),
              ),
              _MiniStat(
                  icon: Icons.arrow_upward_rounded,
                  label: 'Expenses',
                  value: '₱18,340'),
              const Spacer(),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bar_chart_rounded,
                    color: Colors.white, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MiniStat(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.dmSans(
                    fontSize: 9,
                    color: Colors.white.withOpacity(0.65),
                    fontWeight: FontWeight.w500)),
            Text(value,
                style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
      ],
    );
  }
}

class _SectionTag extends StatelessWidget {
  final String label;
  const _SectionTag({required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.emerald50,
          borderRadius: BorderRadius.circular(99),
          border:
              Border.all(color: AppColors.emerald500.withOpacity(0.3)),
        ),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.emerald700,
            letterSpacing: 1.0,
          ),
        ),
      );
}

class _FeatureData {
  final IconData icon;
  final Color color;
  final Color bg;
  final String title;
  final String desc;
  const _FeatureData(
      {required this.icon,
      required this.color,
      required this.bg,
      required this.title,
      required this.desc});
}

class _FeatureCard extends StatelessWidget {
  final _FeatureData data;
  final bool isDark;
  const _FeatureCard({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: AppColors.emerald500.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark
                  ? data.color.withOpacity(0.15)
                  : data.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.color, size: 20),
          ),
          const Spacer(),
          Text(
            data.title,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.gray900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            data.desc,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              height: 1.5,
              color: isDark ? AppColors.gray400 : AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetMethodCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String desc;
  final Color color;
  final Color bg;
  final bool isDark;

  const _BudgetMethodCard({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.color,
    required this.bg,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    height: 1.5,
                    color: isDark ? AppColors.gray400 : AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: color),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String name;
  final String role;
  final String quote;
  final String avatar;
  final bool isDark;

  const _TestimonialCard({
    required this.name,
    required this.role,
    required this.quote,
    required this.avatar,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: AppColors.emerald500.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (_) => const Icon(Icons.star_rounded,
                  color: AppColors.amber400, size: 14),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '"$quote"',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              height: 1.6,
              color: isDark ? AppColors.gray400 : AppColors.gray600,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.emerald100,
                child: Text(
                  avatar,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.emerald700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.gray900,
                    ),
                  ),
                  Text(
                    role,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: AppColors.gray400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
