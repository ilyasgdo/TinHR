import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'onboarding_candidat_screen.dart';
import 'onboarding_recruteur_screen.dart';

/// Écran de choix de rôle : Candidat ou Recruteur.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Titre
                const Text(
                  'Vous êtes...',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choisissez votre profil pour commencer',
                  style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
                ),
                const SizedBox(height: 48),

                // Carte Candidat
                Expanded(
                  child: _RoleCard(
                    icon: Icons.person_search_rounded,
                    title: 'Candidat',
                    subtitle: 'Je cherche un job',
                    description:
                        'Montrez vos compétences et trouvez l\'emploi parfait près de chez vous.',
                    gradient: AppTheme.primaryGradient,
                    glowColor: AppTheme.primary,
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const OnboardingCandidatScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Carte Recruteur
                Expanded(
                  child: _RoleCard(
                    icon: Icons.business_rounded,
                    title: 'Recruteur',
                    subtitle: 'Je cherche un employé',
                    description:
                        'Publiez votre offre et trouvez le candidat idéal en un swipe.',
                    gradient: const LinearGradient(
                      colors: [AppTheme.secondary, Color(0xFF00B4D8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    glowColor: AppTheme.secondary,
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const OnboardingRecruteurScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final LinearGradient gradient;
  final Color glowColor;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradient,
    required this.glowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: glowColor.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône avec gradient
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(icon, size: 36, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 15,
                color: glowColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textMuted,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
