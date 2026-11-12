import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client;
  AuthService(this._client);

  // sign in with email and password
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _client.auth.signInWithPassword(
      password: password,
      email: email,
    );
  }

  // signup with email and password
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
    String firstname,
    String lastname,
  ) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'firstname': firstname, 'lastname': lastname},
    );
  }

  // sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // get user email
  String? getUserEmail() {
    return _client.auth.currentUser?.email;
  }
}
