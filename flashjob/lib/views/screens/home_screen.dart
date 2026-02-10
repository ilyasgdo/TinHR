import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/feed_viewmodel.dart';
import '../widgets/card_stack.dart';

/// Écran principal — Feed, Matches, Profil.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _feedLoaded = false;

  @override
  void initState() {
    super.initState();
    // Charger le feed au premier affichage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFeed();
    });
  }

  void _loadFeed() {
    if (_feedLoaded) return;
    final authVM = context.read<AuthViewModel>();
    final feedVM = context.read<FeedViewModel>();
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
      _feedLoaded = true;
    }
  }

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
          child: Column(
            children: [
              // App bar
              _buildAppBar(),
              // Content
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: [
                    // Tab 0 — Feed / Swipe
                    const CardStack(),
                    // Tab 1 — Matches (placeholder)
                    _buildMatchesTab(),
                    // Tab 2 — Profil
                    _buildProfileTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Text(
            'FlashJob',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          // Notifications (futur)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.notifications_outlined,
                color: AppTheme.textMuted, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, color: AppTheme.textMuted, size: 56),
          SizedBox(height: 16),
          Text(
            'Vos Matches',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Bientôt disponible...',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, child) {
        final profile = authVM.currentProfile;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: profile?.photoUrl != null
                    ? ClipOval(
                        child: Image.network(profile!.photoUrl!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100),
                      )
                    : const Icon(Icons.person_rounded,
                        color: Colors.white, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                profile?.prenom ?? 'Utilisateur',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  profile?.isCandidat == true ? '🎯 Candidat' : '🏢 Recruteur',
                  style: const TextStyle(
                      color: AppTheme.textMuted, fontSize: 13),
                ),
              ),
              const SizedBox(height: 8),
              if (profile?.titrePoste != null)
                Text(
                  profile!.titrePoste!,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 15),
                ),
              const SizedBox(height: 32),

              // Info cards
              _buildInfoCard(
                icon: Icons.location_on_outlined,
                label: 'Rayon de recherche',
                value: '${profile?.rayonRechercheKm ?? 20} km',
              ),
              if (profile?.isRecruteur == true &&
                  profile?.salaireHoraire != null)
                _buildInfoCard(
                  icon: Icons.euro_rounded,
                  label: 'Salaire proposé',
                  value: '${profile!.salaireHoraire!.toStringAsFixed(0)}€/h',
                ),
              if (profile?.isCandidat == true && profile!.tags.isNotEmpty)
                _buildInfoCard(
                  icon: Icons.tag,
                  label: 'Compétences',
                  value: profile.tags.join(', '),
                ),
              const SizedBox(height: 24),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    authVM.signOut();
                    Navigator.of(context)
                        .pushReplacementNamed('/'); // Retour au splash
                  },
                  icon: const Icon(Icons.logout_rounded, color: AppTheme.error),
                  label: const Text('Déconnexion',
                      style: TextStyle(color: AppTheme.error)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.error),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppTheme.surfaceLight.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryLight, size: 22),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppTheme.textMuted, fontSize: 12)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(
              color: AppTheme.surfaceLight.withValues(alpha: 0.3)),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.textMuted,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.style_rounded),
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
    );
  }
}
