import 'package:flutter/material.dart';
import '../models/nearby_profile.dart';
import '../services/feed_service.dart';
import '../services/swipe_service.dart';

/// État du feed.
enum FeedStatus { initial, loading, loaded, empty, error }

/// ViewModel pour le feed de cartes swipables.
class FeedViewModel extends ChangeNotifier {
  final FeedService _feedService = FeedService();
  final SwipeService _swipeService = SwipeService();

  FeedStatus _status = FeedStatus.initial;
  List<NearbyProfile> _profiles = [];
  String? _error;
  bool _isMatchPopupVisible = false;
  NearbyProfile? _lastMatchedProfile;

  FeedStatus get status => _status;
  List<NearbyProfile> get profiles => _profiles;
  String? get error => _error;
  bool get isMatchPopupVisible => _isMatchPopupVisible;
  NearbyProfile? get lastMatchedProfile => _lastMatchedProfile;
  bool get hasProfiles => _profiles.isNotEmpty;

  /// Charge les profils à proximité.
  Future<void> loadProfiles({
    required String currentProfileId,
    required double latitude,
    required double longitude,
    int radiusKm = 20,
  }) async {
    _status = FeedStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _profiles = await _feedService.getNearbyProfiles(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
        currentProfileId: currentProfileId,
      );

      _status = _profiles.isEmpty ? FeedStatus.empty : FeedStatus.loaded;
      notifyListeners();
    } catch (e) {
      _error = 'Impossible de charger les profils';
      _status = FeedStatus.error;
      notifyListeners();
    }
  }

  /// Enregistre un swipe LIKE.
  Future<void> onLike({
    required String swiperId,
    required NearbyProfile profile,
  }) async {
    try {
      // Enregistrer le swipe
      await _swipeService.recordSwipe(
        swiperId: swiperId,
        swipedId: profile.id,
        action: 'like',
      );

      // Vérifier si c'est un match
      final isMatch = await _swipeService.checkAndCreateMatch(
        swiperId: swiperId,
        swipedId: profile.id,
      );

      if (isMatch) {
        _lastMatchedProfile = profile;
        _isMatchPopupVisible = true;
        notifyListeners();
      }
    } catch (e) {
      // Silently fail — l'UX ne doit pas être bloquée
      debugPrint('Erreur swipe like: $e');
    }
  }

  /// Enregistre un swipe DISLIKE.
  Future<void> onDislike({
    required String swiperId,
    required NearbyProfile profile,
  }) async {
    try {
      await _swipeService.recordSwipe(
        swiperId: swiperId,
        swipedId: profile.id,
        action: 'dislike',
      );
    } catch (e) {
      debugPrint('Erreur swipe dislike: $e');
    }
  }

  /// Ferme le popup de match.
  void dismissMatchPopup() {
    _isMatchPopupVisible = false;
    _lastMatchedProfile = null;
    notifyListeners();
  }

  /// Retire un profil de la pile (après swipe).
  void removeTopProfile() {
    if (_profiles.isNotEmpty) {
      _profiles.removeAt(0);
      if (_profiles.isEmpty) {
        _status = FeedStatus.empty;
      }
      notifyListeners();
    }
  }
}
