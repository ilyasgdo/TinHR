import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';

/// Écran d'accueil principal (placeholder pour l'Étape 2).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final profile = auth.currentProfile;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.background, Color(0xFF16213E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: [
              // Tab 0 : Feed (placeholder)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.4),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.swipe_rounded,
                          size: 64, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Bienvenue ${profile?.prenom ?? ''} ! 👋',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile?.isCandidat == true
                          ? 'Le feed de swipe arrive à l\'Étape 2'
                          : 'Vos candidats arrivent à l\'Étape 2',
                      style: const TextStyle(
                          color: AppTheme.textMuted, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: profile?.isCandidat == true
                            ? AppTheme.primary.withValues(alpha: 0.2)
                            : AppTheme.secondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        profile?.isCandidat == true
                            ? '🔍 Candidat — ${profile?.titrePoste}'
                            : '🏢 Recruteur — ${profile?.nomEtablissement}',
                        style: TextStyle(
                          color: profile?.isCandidat == true
                              ? AppTheme.primaryLight
                              : AppTheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tab 1 : Matches (placeholder)
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_rounded,
                        size: 64, color: AppTheme.accent),
                    SizedBox(height: 16),
                    Text(
                      'Vos Matches',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Disponible à l\'Étape 3',
                        style: TextStyle(color: AppTheme.textMuted)),
                  ],
                ),
              ),

              // Tab 2 : Profil
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppTheme.surfaceLight,
                      backgroundImage: profile?.photoUrl != null
                          ? NetworkImage(profile!.photoUrl!)
                          : null,
                      child: profile?.photoUrl == null
                          ? const Icon(Icons.person,
                              size: 48, color: AppTheme.textMuted)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profile?.prenom ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile?.titrePoste ?? '',
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 16),
                    ),
                    if (profile?.tags.isNotEmpty == true) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: profile!.tags.map((tag) {
                          return Chip(
                            label: Text(tag,
                                style:
                                    const TextStyle(color: Colors.white, fontSize: 12)),
                            backgroundColor:
                                AppTheme.primary.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await auth.signOut();
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          );
                        }
                      },
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Se déconnecter'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.error.withValues(alpha: 0.2),
                        foregroundColor: AppTheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.swipe_rounded),
              label: 'Swipe',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: 'Matches',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
