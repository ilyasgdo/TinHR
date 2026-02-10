import 'package:supabase_flutter/supabase_flutter.dart';

/// Service pour enregistrer les actions de swipe.
class SwipeService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Enregistre un swipe (like ou dislike).
  Future<void> recordSwipe({
    required String swiperId,
    required String swipedId,
    required String action, // 'like' ou 'dislike'
  }) async {
    await _client.from('swipes').insert({
      'swiper_id': swiperId,
      'swiped_id': swipedId,
      'action': action,
    });
  }

  /// Vérifie si un match a eu lieu (double-like) via la RPC.
  /// Retourne true si un match est créé.
  Future<bool> checkAndCreateMatch({
    required String swiperId,
    required String swipedId,
  }) async {
    final result = await _client.rpc('check_and_create_match', params: {
      'p_swiper_id': swiperId,
      'p_swiped_id': swipedId,
    });
    return result as bool;
  }
}
