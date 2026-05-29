import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/features/auth/presentation/cubit/auth_cubit.dart';

enum AuthSheetMode { login, signUp }

Future<bool?> showAuthSheet(
  BuildContext context, {
  AuthSheetMode initialMode = AuthSheetMode.login,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => AuthSheet(initialMode: initialMode),
  );
}

class AuthSheet extends StatefulWidget {
  const AuthSheet({super.key, this.initialMode = AuthSheetMode.login});

  final AuthSheetMode initialMode;

  @override
  State<AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends State<AuthSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();
  final _signUpName = TextEditingController();
  final _signUpEmail = TextEditingController();
  final _signUpPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabs = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialMode == AuthSheetMode.signUp ? 1 : 0,
    );
  }

  @override
  void dispose() {
    _tabs.dispose();
    _loginEmail.dispose();
    _loginPassword.dispose();
    _signUpName.dispose();
    _signUpEmail.dispose();
    _signUpPassword.dispose();
    super.dispose();
  }

  Future<void> _submitLogin(AuthCubit cubit) async {
    await cubit.signIn(
      email: _loginEmail.text,
      password: _loginPassword.text,
    );
    if (!mounted) return;
    if (cubit.state.isSignedIn && cubit.state.errorMessage == null) {
      // Navigation handled by BlocConsumer listener.
    }
  }

  Future<void> _submitSignUp(AuthCubit cubit) async {
    await cubit.signUp(
      email: _signUpEmail.text,
      password: _signUpPassword.text,
      displayName: _signUpName.text,
    );
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: JourneyPanel(
        radius: 24,
        padding: EdgeInsets.zero,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.78,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.glassBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Account',
                          style: GoogleFonts.cinzel(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: colors.onScenic,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_rounded, color: colors.gold),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  controller: _tabs,
                  indicatorColor: colors.gold,
                  labelColor: colors.gold,
                  unselectedLabelColor: colors.onScenicMuted,
                  tabs: const [
                    Tab(text: 'LOGIN'),
                    Tab(text: 'SIGN UP'),
                  ],
                ),
                Expanded(
                  child: BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state.isSignedIn && !state.isLoading) {
                        Navigator.pop(context, true);
                      }
                    },
                    builder: (context, state) {
                      return TabBarView(
                        controller: _tabs,
                        children: [
                          _AuthForm(
                            children: [
                              _field(_loginEmail, 'Email', keyboard: TextInputType.emailAddress),
                              const SizedBox(height: 10),
                              _field(_loginPassword, 'Password', obscure: true),
                              const SizedBox(height: 16),
                              _primaryButton(
                                label: 'LOG IN',
                                loading: state.isLoading,
                                onPressed: () => _submitLogin(context.read<AuthCubit>()),
                              ),
                            ],
                          ),
                          _AuthForm(
                            children: [
                              _field(_signUpName, 'Display name'),
                              const SizedBox(height: 10),
                              _field(_signUpEmail, 'Email', keyboard: TextInputType.emailAddress),
                              const SizedBox(height: 10),
                              _field(_signUpPassword, 'Password', obscure: true),
                              const SizedBox(height: 16),
                              _primaryButton(
                                label: 'CREATE ACCOUNT',
                                loading: state.isLoading,
                                onPressed: () => _submitSignUp(context.read<AuthCubit>()),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          if (state.errorMessage != null) ...[
                            Text(
                              state.errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: colors.timerDanger, fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                          ],
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: state.isLoading
                                  ? null
                                  : () => context.read<AuthCubit>().signInWithGoogle(),
                              icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                              label: const Text('Continue with Google'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: colors.onScenic,
                                side: BorderSide(color: colors.glassBorder),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    final colors = context.appColors;
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      style: TextStyle(color: colors.onScenic),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colors.onScenicMuted),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.gold),
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required bool loading,
    required VoidCallback onPressed,
  }) {
    final colors = context.appColors;
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colors.gold,
          foregroundColor: colors.scrim,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: loading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.scrim,
                ),
              )
            : Text(label),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
