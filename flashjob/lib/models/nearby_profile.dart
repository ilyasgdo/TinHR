/// Modèle d'un profil avec distance (retourné par get_nearby_profiles).
class NearbyProfile {
  final String id;
  final String userId;
  final String role;
  final String prenom;
  final String? photoUrl;
  final String? titrePoste;
  final List<String> tags;
  final String? description;
  final String? nomEtablissement;
  final double? salaireHoraire;
  final String? adresse;
  final double? latitude;
  final double? longitude;
  final double distanceKm;

  NearbyProfile({
    required this.id,
    required this.userId,
    required this.role,
    required this.prenom,
    this.photoUrl,
    this.titrePoste,
    this.tags = const [],
    this.description,
    this.nomEtablissement,
    this.salaireHoraire,
    this.adresse,
    this.latitude,
    this.longitude,
    required this.distanceKm,
  });

  /// Depuis la réponse RPC Supabase.
  factory NearbyProfile.fromMap(Map<String, dynamic> map) {
    return NearbyProfile(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      role: map['role'] as String,
      prenom: map['prenom'] as String,
      photoUrl: map['photo_url'] as String?,
      titrePoste: map['titre_poste'] as String?,
      tags: (map['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      description: map['description'] as String?,
      nomEtablissement: map['nom_etablissement'] as String?,
      salaireHoraire: map['salaire_horaire'] != null
          ? (map['salaire_horaire'] as num).toDouble()
          : null,
      adresse: map['adresse'] as String?,
      latitude: map['latitude'] != null
          ? (map['latitude'] as num).toDouble()
          : null,
      longitude: map['longitude'] != null
          ? (map['longitude'] as num).toDouble()
          : null,
      distanceKm: (map['distance_km'] as num?)?.toDouble() ?? 0.0,
    );
  }

  bool get isCandidat => role == 'candidat';
  bool get isRecruteur => role == 'recruteur';

  /// Distance formatée pour l'UI.
  String get distanceLabel {
    if (distanceKm < 1) {
      return '< 1 km';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }
}
