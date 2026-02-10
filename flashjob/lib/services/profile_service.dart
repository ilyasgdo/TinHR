import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/profile.dart';

/// Service de gestion des profils via Supabase.
class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Récupère le profil de l'utilisateur connecté.
  Future<Profile?> getMyProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return Profile.fromMap(response);
  }

  /// Récupère un profil par son ID.
  Future<Profile?> getProfileById(String profileId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', profileId)
        .maybeSingle();

    if (response == null) return null;
    return Profile.fromMap(response);
  }

  /// Crée un nouveau profil.
  Future<Profile> createProfile({
    required String role,
    required String prenom,
    String? photoUrl,
    String? titrePoste,
    List<String>? tags,
    String? description,
    String? nomEtablissement,
    double? salaireHoraire,
    String? adresse,
    double? latitude,
    double? longitude,
  }) async {
    final userId = _client.auth.currentUser!.id;

    final data = {
      'user_id': userId,
      'role': role,
      'prenom': prenom,
      'photo_url': photoUrl,
      'titre_poste': titrePoste,
      'tags': tags ?? [],
      'description': description,
      'nom_etablissement': nomEtablissement,
      'salaire_horaire': salaireHoraire,
      'adresse': adresse,
      'latitude': latitude,
      'longitude': longitude,
    };

    final response =
        await _client.from('profiles').insert(data).select().single();

    return Profile.fromMap(response);
  }

  /// Met à jour le profil.
  Future<Profile> updateProfile(String profileId, Map<String, dynamic> updates) async {
    final response = await _client
        .from('profiles')
        .update(updates)
        .eq('id', profileId)
        .select()
        .single();

    return Profile.fromMap(response);
  }

  /// Upload une photo vers Supabase Storage et retourne l'URL publique.
  /// Accepte les bytes directement pour la compatibilité web.
  Future<String> uploadPhotoBytes({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final userId = _client.auth.currentUser!.id;
    final storagePath = '$userId/$fileName';

    await _client.storage.from('avatars').uploadBinary(
          storagePath,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    final publicUrl =
        _client.storage.from('avatars').getPublicUrl(storagePath);

    return publicUrl;
  }
}
