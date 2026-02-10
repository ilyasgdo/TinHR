import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/nearby_profile.dart';

/// Carte de profil swipable avec design premium.
class SwipeCard extends StatelessWidget {
  final NearbyProfile profile;

  const SwipeCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Photo de fond
            _buildPhoto(),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.4, 0.65, 1.0],
                ),
              ),
            ),

            // Badge distance (en haut à droite)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, color: AppTheme.primaryLight, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      profile.distanceLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Badge rôle (en haut à gauche)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: profile.isRecruteur
                      ? const LinearGradient(
                          colors: [AppTheme.secondary, Color(0xFF00B4D8)])
                      : AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      profile.isRecruteur
                          ? Icons.business_rounded
                          : Icons.person_search_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      profile.isRecruteur ? 'Recruteur' : 'Candidat',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Informations en bas
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Nom
                    Text(
                      profile.prenom,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Poste ou établissement
                    if (profile.titrePoste != null)
                      Row(
                        children: [
                          Icon(
                            profile.isRecruteur
                                ? Icons.work_rounded
                                : Icons.search_rounded,
                            color: AppTheme.primaryLight,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              profile.isRecruteur
                                  ? '${profile.titrePoste}'
                                  : 'Cherche : ${profile.titrePoste}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),

                    // Salaire (recruteur) ou Tags (candidat)
                    if (profile.isRecruteur && profile.salaireHoraire != null)
                      Row(
                        children: [
                          const Icon(Icons.euro_rounded,
                              color: AppTheme.success, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '${profile.salaireHoraire!.toStringAsFixed(0)}€/h',
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppTheme.success,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                    if (profile.isCandidat && profile.tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: profile.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.primary.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    // Nom établissement (recruteur)
                    if (profile.nomEtablissement != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.store_rounded,
                              color: Colors.white54, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            profile.nomEtablissement!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Description (si disponible)
                    if (profile.description != null &&
                        profile.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        profile.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.7),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    if (profile.photoUrl != null && profile.photoUrl!.isNotEmpty) {
      return Image.network(
        profile.photoUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholder(loading: true);
        },
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder({bool loading = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: profile.isRecruteur
              ? [const Color(0xFF0A4D68), const Color(0xFF088395)]
              : [const Color(0xFF4A1A6B), const Color(0xFF6C3483)],
        ),
      ),
      child: Center(
        child: loading
            ? const CircularProgressIndicator(color: Colors.white38)
            : Icon(
                profile.isRecruteur
                    ? Icons.business_rounded
                    : Icons.person_rounded,
                size: 80,
                color: Colors.white.withValues(alpha: 0.3),
              ),
      ),
    );
  }
}
