import 'package:supabase_flutter/supabase_flutter.dart';

/// Service d'authentification via Supabase Auth.
class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Utilisateur actuellement connecté.
  User? get currentUser => _client.auth.currentUser;

  /// Session active.
  Session? get currentSession => _client.auth.currentSession;

  /// Est connecté ?
  bool get isLoggedIn => currentUser != null;

  /// Stream des changements d'état d'auth.
  Stream<AuthState> onAuthStateChange() {
    return _client.auth.onAuthStateChange;
  }

  /// Inscription avec email/password.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    return response;
  }

  /// Connexion avec email/password.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  /// Déconnexion.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Traduit les erreurs Supabase en messages user-friendly.
  static String getErrorMessage(dynamic error) {
    final message = error.toString().toLowerCase();

    if (message.contains('invalid login credentials')) {
      return 'Email ou mot de passe incorrect';
    }
    if (message.contains('user already registered')) {
      return 'Cet email est déjà utilisé';
    }
    if (message.contains('password should be at least')) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    if (message.contains('invalid email')) {
      return 'Adresse email invalide';
    }
    if (message.contains('email not confirmed')) {
      return 'Veuillez confirmer votre email';
    }
    if (message.contains('network')) {
      return 'Erreur de connexion. Vérifiez votre internet.';
    }

    return 'Une erreur est survenue. Réessayez.';
  }
}
