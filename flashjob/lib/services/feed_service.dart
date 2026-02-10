import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/nearby_profile.dart';

/// Service pour récupérer le feed de profils à proximité.
class FeedService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Récupère les profils à proximité via la RPC PostGIS.
  Future<List<NearbyProfile>> getNearbyProfiles({
    required double latitude,
    required double longitude,
    required int radiusKm,
    required String currentProfileId,
  }) async {
    final response = await _client.rpc('get_nearby_profiles', params: {
      'user_lat': latitude,
      'user_lng': longitude,
      'radius_km': radiusKm,
      'current_user_id': currentProfileId,
    });

    final data = response as List<dynamic>;
    return data
        .map((item) => NearbyProfile.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
