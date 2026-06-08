import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  late final AnimationController _animCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    
    final success = await ref.read(authProvider.notifier).loginUser(
      _emailCtrl.text,
      _passwordCtrl.text,
    );
    
    if (mounted) setState(() => _isLoading = false);
    
    if (success && mounted) {
      context.go('/');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBg : const Color(0xFFF6FAF8),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildBackButton(context, isDark),
                    const SizedBox(height: 32),
                    _buildHeader(isDark),
                    const SizedBox(height: 36),
                    _buildEmailField(isDark),
                    const SizedBox(height: 16),
                    _buildPasswordField(isDark),
                    const SizedBox(height: 14),
                    _buildRememberForgot(isDark),
                    const SizedBox(height: 28),
                    _buildLoginButton(),
                    const SizedBox(height: 24),
                    _buildDivider(isDark),
                    const SizedBox(height: 24),
                    _buildSocialButtons(isDark),
                    const SizedBox(height: 32),
                    _buildRegisterLink(context, isDark),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: AppColors.emerald500.withOpacity(0.15)),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: isDark ? Colors.white : AppColors.gray800,
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.emerald500, AppColors.emerald700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.savings_outlined,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            Text(
              'BudgetBuddy',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 20,
                color: isDark ? Colors.white : AppColors.gray900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          'Welcome back 👋',
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 32,
            color: isDark ? Colors.white : AppColors.gray900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue managing\nyour finances.',
          style: GoogleFonts.dmSans(
            fontSize: 15,
            height: 1.5,
            color: isDark ? AppColors.gray400 : AppColors.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: 'Email Address', isDark: isDark),
        const SizedBox(height: 8),
        _AppTextField(
          controller: _emailCtrl,
          hint: 'you@example.com',
          prefixIcon: Icons.mail_outline_rounded,
          isDark: isDark,
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Email is required';
            if (!v.contains('@')) return 'Enter a valid email';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: 'Password', isDark: isDark),
        const SizedBox(height: 8),
        _AppTextField(
          controller: _passwordCtrl,
          hint: '••••••••',
          prefixIcon: Icons.lock_outline_rounded,
          isDark: isDark,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 18,
              color: AppColors.gray400,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Password is required';
            if (v.length < 6) return 'At least 6 characters';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRememberForgot(bool isDark) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() => _rememberMe = !_rememberMe),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _rememberMe
                      ? AppColors.emerald600
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: _rememberMe
                        ? AppColors.emerald600
                        : isDark
                            ? AppColors.gray400
                            : AppColors.gray300,
                    width: 1.5,
                  ),
                ),
                child: _rememberMe
                    ? const Icon(Icons.check_rounded,
                        size: 13, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                'Remember me',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color:
                      isDark ? AppColors.gray400 : AppColors.gray500,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Forgot Password?',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.emerald600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emerald600,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Sign In',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Row(
      children: [
        Expanded(
            child: Divider(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : AppColors.gray200)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'or continue with',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: isDark ? AppColors.gray400 : AppColors.gray400,
            ),
          ),
        ),
        Expanded(
            child: Divider(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : AppColors.gray200)),
      ],
    );
  }

  Widget _buildSocialButtons(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            icon: Icons.g_mobiledata_rounded,
            label: 'Google',
            isDark: isDark,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SocialButton(
            icon: Icons.facebook_rounded,
            label: 'Facebook',
            isDark: isDark,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterLink(BuildContext context, bool isDark) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color:
                  isDark ? AppColors.gray400 : AppColors.gray500,
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/register'),
            child: Text(
              'Sign Up',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.emerald600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _FieldLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.gray800,
        ),
      );
}

class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool isDark;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _AppTextField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    required this.isDark,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.dmSans(
        fontSize: 14,
        color: isDark ? Colors.white : AppColors.gray900,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.dmSans(
          fontSize: 14,
          color: AppColors.gray400,
        ),
        prefixIcon: Icon(prefixIcon,
            size: 18,
            color: isDark ? AppColors.gray400 : AppColors.gray400),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark ? AppColors.darkCard : AppColors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: AppColors.emerald500.withOpacity(0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : AppColors.emerald500.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: AppColors.emerald500, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.red500),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.red500, width: 1.5),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;
  const _SocialButton(
      {required this.icon,
      required this.label,
      required this.isDark,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: GoogleFonts.dmSans(
            fontSize: 14, fontWeight: FontWeight.w500),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor:
            isDark ? Colors.white : AppColors.gray800,
        backgroundColor:
            isDark ? AppColors.darkCard : AppColors.white,
        side: BorderSide(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : AppColors.gray200,
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
