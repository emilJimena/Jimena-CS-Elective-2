/*
  Continuously listen to auth state changes and update the app state accordingly.

 ---------------

 unauthenticated --> Login Page
 authenticated --> Products Page

 */

import 'package:cs_elective_2/pages/LoginPage.dart';
import 'package:cs_elective_2/pages/Products.dart';
import 'package:cs_elective_2/providers/auth_providers.dart'; // adjust path
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      // If the stream errors, fall back to the login page.
      error: (_, __) => const LoginPage(),
      data: (state) {
        final session = state.session;
        print('Access token: ${session?.accessToken}');
        print('Refresh token: ${session?.refreshToken}');
        print('Expires at: ${session?.expiresAt}'); // unix seconds
        print('User ID: ${session?.user.id}');
        // readable version
        // final exp = DateTime.fromMillisecondsSinceEpoch(
        //   session!.expiresAt! * 1000,
        // );
        // print('Expires at: $exp');
        return session == null ? const LoginPage() : const ProductsPage();
      },
    );
  }
}
