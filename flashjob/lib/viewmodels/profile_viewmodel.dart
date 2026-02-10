import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';

/// ViewModel pour la création et modification de profil.
class ProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  bool _isLoading = false;
  String? _error;
  String? _uploadedPhotoUrl;
  double? _latitude;
  double? _longitude;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get uploadedPhotoUrl => _uploadedPhotoUrl;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  bool get hasLocation => _latitude != null && _longitude != null;

  /// Upload une photo de profil (accepte les bytes directement).
  Future<bool> uploadPhoto(Uint8List bytes) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fileName =
          'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      _uploadedPhotoUrl = await _profileService.uploadPhotoBytes(
        bytes: bytes,
        fileName: fileName,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erreur lors de l\'upload de la photo';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Demande la permission GPS et récupère la position.
  Future<bool> requestLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Vérifier si le service de localisation est activé
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _error = 'Activez la localisation dans les paramètres';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Vérifier les permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = 'Permission de localisation refusée';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error = 'Permission de localisation bloquée. Allez dans les paramètres.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Récupérer la position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      _latitude = position.latitude;
      _longitude = position.longitude;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Impossible de récupérer la position';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Crée un profil candidat.
  Future<Profile?> createCandidatProfile({
    required String prenom,
    required String titrePoste,
    required List<String> tags,
    String? description,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final profile = await _profileService.createProfile(
        role: 'candidat',
        prenom: prenom,
        photoUrl: _uploadedPhotoUrl,
        titrePoste: titrePoste,
        tags: tags,
        description: description,
        latitude: _latitude,
        longitude: _longitude,
      );

      _isLoading = false;
      notifyListeners();
      return profile;
    } catch (e) {
      _error = 'Erreur création profil: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Crée un profil recruteur.
  Future<Profile?> createRecruteurProfile({
    required String prenom,
    required String nomEtablissement,
    required String titrePoste,
    required double salaireHoraire,
    String? adresse,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final profile = await _profileService.createProfile(
        role: 'recruteur',
        prenom: prenom,
        nomEtablissement: nomEtablissement,
        photoUrl: _uploadedPhotoUrl,
        titrePoste: titrePoste,
        salaireHoraire: salaireHoraire,
        adresse: adresse,
        latitude: _latitude,
        longitude: _longitude,
      );

      _isLoading = false;
      notifyListeners();
      return profile;
    } catch (e) {
      _error = 'Erreur création profil: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
