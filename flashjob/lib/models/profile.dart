/// Modèle de profil utilisateur (Candidat ou Recruteur).
class Profile {
  final String id;
  final String userId;
  final String role; // 'candidat' ou 'recruteur'

  // Commun
  final String prenom;
  final String? photoUrl;

  // Candidat
  final String? titrePoste;
  final List<String> tags;
  final String? description;

  // Recruteur
  final String? nomEtablissement;
  final double? salaireHoraire;
  final String? adresse;

  // Géolocalisation
  final double? latitude;
  final double? longitude;

  // Paramètres
  final int rayonRechercheKm;

  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
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
    this.rayonRechercheKm = 20,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Crée un Profile depuis un Map Supabase.
  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
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
      rayonRechercheKm: (map['rayon_recherche_km'] as int?) ?? 20,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Convertit le Profile en Map pour Supabase.
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'role': role,
      'prenom': prenom,
      'photo_url': photoUrl,
      'titre_poste': titrePoste,
      'tags': tags,
      'description': description,
      'nom_etablissement': nomEtablissement,
      'salaire_horaire': salaireHoraire,
      'adresse': adresse,
      'latitude': latitude,
      'longitude': longitude,
      'rayon_recherche_km': rayonRechercheKm,
    };
  }

  bool get isCandidat => role == 'candidat';
  bool get isRecruteur => role == 'recruteur';

  /// Vérifie si le profil est complet.
  bool get isComplete {
    if (isCandidat) {
      return prenom.isNotEmpty &&
          photoUrl != null &&
          titrePoste != null &&
          tags.isNotEmpty;
    } else {
      return prenom.isNotEmpty &&
          nomEtablissement != null &&
          titrePoste != null &&
          salaireHoraire != null;
    }
  }

  Profile copyWith({
    String? id,
    String? userId,
    String? role,
    String? prenom,
    String? photoUrl,
    String? titrePoste,
    List<String>? tags,
    String? description,
    String? nomEtablissement,
    double? salaireHoraire,
    String? adresse,
    double? latitude,
    double? longitude,
    int? rayonRechercheKm,
  }) {
    return Profile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      prenom: prenom ?? this.prenom,
      photoUrl: photoUrl ?? this.photoUrl,
      titrePoste: titrePoste ?? this.titrePoste,
      tags: tags ?? this.tags,
      description: description ?? this.description,
      nomEtablissement: nomEtablissement ?? this.nomEtablissement,
      salaireHoraire: salaireHoraire ?? this.salaireHoraire,
      adresse: adresse ?? this.adresse,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rayonRechercheKm: rayonRechercheKm ?? this.rayonRechercheKm,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
