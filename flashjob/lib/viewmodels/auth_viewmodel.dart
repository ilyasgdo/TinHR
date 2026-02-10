import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../models/profile.dart';

/// État de l'authentification.
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  needsProfile, // connecté mais pas de profil
}

/// ViewModel pour la gestion de l'authentification.
class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  AuthStatus _status = AuthStatus.initial;
  String? _error;
  Profile? _currentProfile;
  StreamSubscription<AuthState>? _authSub;

  AuthStatus get status => _status;
  String? get error => _error;
  Profile? get currentProfile => _currentProfile;
  bool get isLoading => _status == AuthStatus.loading;
  User? get currentUser => _authService.currentUser;

  AuthViewModel() {
    _init();
  }

  /// Initialise le listener d'auth et vérifie la session.
  void _init() {
    _authSub = _authService.onAuthStateChange().listen((authState) {
      _handleAuthChange(authState);
    });

    // Vérifier la session existante
    if (_authService.isLoggedIn) {
      _checkProfile();
    } else {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  /// Gère les changements d'état d'auth.
  Future<void> _handleAuthChange(AuthState authState) async {
    switch (authState.event) {
      case AuthChangeEvent.signedIn:
        await _checkProfile();
        break;
      case AuthChangeEvent.signedOut:
        _currentProfile = null;
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        break;
      default:
        break;
    }
  }

  /// Vérifie si l'utilisateur a un profil complet.
  Future<void> _checkProfile() async {
    try {
      _currentProfile = await _profileService.getMyProfile();
      if (_currentProfile == null) {
        _status = AuthStatus.needsProfile;
      } else {
        _status = AuthStatus.authenticated;
      }
    } catch (e) {
      _status = AuthStatus.needsProfile;
    }
    notifyListeners();
  }

  /// Inscription.
  Future<bool> signUp({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      await _authService.signUp(email: email, password: password);
      _status = AuthStatus.needsProfile;
      notifyListeners();
      return true;
    } catch (e) {
      _error = AuthService.getErrorMessage(e);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  /// Connexion.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      await _authService.signIn(email: email, password: password);
      await _checkProfile();
      return true;
    } catch (e) {
      _error = AuthService.getErrorMessage(e);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  /// Déconnexion.
  Future<void> signOut() async {
    await _authService.signOut();
    _currentProfile = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  /// Met à jour le profil actuel après création/modification.
  void setProfile(Profile profile) {
    _currentProfile = profile;
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  /// Efface l'erreur.
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
