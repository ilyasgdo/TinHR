import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/feed_viewmodel.dart';
import '../widgets/swipe_card.dart';

/// Widget de pile de cartes avec swipe.
class CardStack extends StatefulWidget {
  const CardStack({super.key});

  @override
  State<CardStack> createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  final CardSwiperController _swiperController = CardSwiperController();

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FeedViewModel, AuthViewModel>(
      builder: (context, feedVM, authVM, child) {
        // Loading
        if (feedVM.status == FeedStatus.loading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppTheme.primaryLight),
                SizedBox(height: 16),
                Text(
                  'Recherche de profils...',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 15),
                ),
              ],
            ),
          );
        }

        // Error
        if (feedVM.status == FeedStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    color: AppTheme.error.withValues(alpha: 0.7), size: 56),
                const SizedBox(height: 16),
                Text(
                  feedVM.error ?? 'Erreur inconnue',
                  style: const TextStyle(color: AppTheme.textMuted),
                ),
                const SizedBox(height: 20),
                _buildRetryButton(feedVM, authVM),
              ],
            ),
          );
        }

        // Empty
        if (feedVM.status == FeedStatus.empty || !feedVM.hasProfiles) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(Icons.explore_off_rounded,
                      color: AppTheme.textMuted, size: 48),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Plus de profils à afficher',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Revenez plus tard ou élargissez votre rayon de recherche.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 24),
                _buildRetryButton(feedVM, authVM),
              ],
            ),
          );
        }

        // Cards stack
        return Stack(
          children: [
            // Swiper
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: CardSwiper(
                controller: _swiperController,
                cardsCount: feedVM.profiles.length,
                numberOfCardsDisplayed:
                    feedVM.profiles.length < 3 ? feedVM.profiles.length : 3,
                backCardOffset: const Offset(0, -30),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                onSwipe: (previousIndex, currentIndex, direction) {
                  final profile = feedVM.profiles[previousIndex];
                  final swiperId = authVM.currentProfile?.id;
                  if (swiperId == null) return true;

                  if (direction == CardSwiperDirection.right) {
                    feedVM.onLike(swiperId: swiperId, profile: profile);
                  } else if (direction == CardSwiperDirection.left) {
                    feedVM.onDislike(swiperId: swiperId, profile: profile);
                  }
                  return true;
                },
                onEnd: () {
                  // Tous les profils ont été swipés
                  feedVM.removeTopProfile();
                },
                cardBuilder: (context, index, horizontalOffset, verticalOffset) {
                  return SwipeCard(profile: feedVM.profiles[index]);
                },
              ),
            ),

            // Boutons Like / Dislike
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Dislike
                  _buildActionButton(
                    icon: Icons.close_rounded,
                    color: AppTheme.error,
                    onTap: () => _swiperController.swipe(CardSwiperDirection.left),
                    size: 60,
                  ),
                  const SizedBox(width: 28),
                  // Like
                  _buildActionButton(
                    icon: Icons.favorite_rounded,
                    color: AppTheme.success,
                    onTap: () => _swiperController.swipe(CardSwiperDirection.right),
                    size: 70,
                    isPrimary: true,
                  ),
                ],
              ),
            ),

            // Match popup
            if (feedVM.isMatchPopupVisible && feedVM.lastMatchedProfile != null)
              _buildMatchOverlay(feedVM),
          ],
        );
      },
    );
  }

  Widget _buildRetryButton(FeedViewModel feedVM, AuthViewModel authVM) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          final profile = authVM.currentProfile;
          if (profile != null &&
              profile.latitude != null &&
              profile.longitude != null) {
            feedVM.loadProfiles(
              currentProfileId: profile.id,
              latitude: profile.latitude!,
              longitude: profile.longitude!,
              radiusKm: profile.rayonRechercheKm,
            );
          }
        },
        icon: const Icon(Icons.refresh_rounded, color: Colors.white),
        label: const Text('Recharger',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    double size = 60,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isPrimary ? null : AppTheme.surface,
          gradient: isPrimary
              ? LinearGradient(colors: [color, color.withValues(alpha: 0.7)])
              : null,
          shape: BoxShape.circle,
          border: isPrimary
              ? null
              : Border.all(color: color.withValues(alpha: 0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? color.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.2),
              blurRadius: isPrimary ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: isPrimary ? Colors.white : color,
            size: isPrimary ? 32 : 28),
      ),
    );
  }

  Widget _buildMatchOverlay(FeedViewModel feedVM) {
    final profile = feedVM.lastMatchedProfile!;
    return GestureDetector(
      onTap: feedVM.dismissMatchPopup,
      child: Container(
        color: Colors.black.withValues(alpha: 0.8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animation match
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.5),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(Icons.bolt_rounded,
                    color: Colors.white, size: 64),
              ),
              const SizedBox(height: 24),
              const Text(
                '⚡ C\'est un Match !',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Vous et ${profile.prenom} êtes intéressés !',
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: feedVM.dismissMatchPopup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
