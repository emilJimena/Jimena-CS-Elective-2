import 'package:cs_elective_2/providers/supabase_provider.dart';
import 'package:cs_elective_2/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Your AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(supabaseProvider));
});

/// Listens to Supabase auth changes (signed in / signed out / token refresh).
/// Use this for routing: show LoginPage when session is null, HomePage otherwise.
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseProvider).auth.onAuthStateChange;
});

/// Current user's email (rebuilds when auth state changes)
final userEmailProvider = Provider<String?>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(authServiceProvider).getUserEmail();
});

/// Handles sign in / sign up / sign out actions.
/// State is AsyncValue<void>: loading while a request runs, error if it fails.
class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  AuthService get _service => ref.read(authServiceProvider);

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _service.signInWithEmailPassword(email.trim(), password),
    );
  }

  Future<void> signUp(
    String email,
    String password,
    String firstname,
    String lastname,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _service.signUpWithEmailPassword(
        email.trim(),
        password,
        firstname,
        lastname,
      ),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.signOut());
  }
}

final isAdminProvider = FutureProvider<bool>((ref) async {
  ref.watch(authStateProvider); // re-check whenever someone logs in or out
  final res = await Supabase.instance.client.rpc('is_admin');
  return res == true;
});

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);
