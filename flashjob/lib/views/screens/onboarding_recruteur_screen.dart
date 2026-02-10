import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/profile_viewmodel.dart';
import 'home_screen.dart';

/// Écran d'onboarding pour les recruteurs.
class OnboardingRecruteurScreen extends StatefulWidget {
  const OnboardingRecruteurScreen({super.key});

  @override
  State<OnboardingRecruteurScreen> createState() =>
      _OnboardingRecruteurScreenState();
}

class _OnboardingRecruteurScreenState extends State<OnboardingRecruteurScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prenomController = TextEditingController();
  final _etablissementController = TextEditingController();
  final _posteController = TextEditingController();
  final _salaireController = TextEditingController();
  final _adresseController = TextEditingController();
  XFile? _pickedImage;

  @override
  void dispose() {
    _prenomController.dispose();
    _etablissementController.dispose();
    _posteController.dispose();
    _salaireController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _pickedImage = image);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final profileVM = context.read<ProfileViewModel>();
    final authVM = context.read<AuthViewModel>();

    // Upload photo si sélectionnée
    if (_pickedImage != null) {
      final bytes = await _pickedImage!.readAsBytes();
      final success = await profileVM.uploadPhoto(bytes);
      if (!success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(profileVM.error ?? 'Erreur upload photo')),
          );
        }
        return;
      }
    }

    // Demander la localisation
    await profileVM.requestLocation();

    // Créer le profil
    final profile = await profileVM.createRecruteurProfile(
      prenom: _prenomController.text.trim(),
      nomEtablissement: _etablissementController.text.trim(),
      titrePoste: _posteController.text.trim(),
      salaireHoraire: double.parse(_salaireController.text.trim()),
      adresse: _adresseController.text.trim().isEmpty
          ? null
          : _adresseController.text.trim(),
    );

    if (profile != null && mounted) {
      authVM.setProfile(profile);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),

                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.secondary, Color(0xFF00B4D8)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.business_rounded,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Profil Recruteur',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary)),
                          Text('Décrivez votre offre',
                              style: TextStyle(
                                  fontSize: 13, color: AppTheme.textMuted)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Photo du lieu
                  Center(
                    child: GestureDetector(
                      onTap: _pickPhoto,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.secondary.withValues(alpha: 0.5),
                            width: 3,
                          ),
                        ),
                        child: _pickedImage == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo_rounded,
                                      color: AppTheme.secondary, size: 32),
                                  SizedBox(height: 4),
                                  Text('Photo du lieu',
                                      style: TextStyle(
                                          color: AppTheme.textMuted,
                                          fontSize: 11)),
                                ],
                              )
                            : const Icon(Icons.check_circle,
                                color: AppTheme.success, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Prénom / Nom contact
                  TextFormField(
                    controller: _prenomController,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Votre prénom',
                      prefixIcon:
                          Icon(Icons.person_outline, color: AppTheme.textMuted),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Entrez votre prénom' : null,
                  ),
                  const SizedBox(height: 14),

                  // Nom établissement
                  TextFormField(
                    controller: _etablissementController,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Nom de l\'établissement',
                      prefixIcon:
                          Icon(Icons.store_rounded, color: AppTheme.textMuted),
                    ),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Entrez le nom de l\'établissement'
                        : null,
                  ),
                  const SizedBox(height: 14),

                  // Poste à pourvoir
                  TextFormField(
                    controller: _posteController,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Poste à pourvoir (ex: Serveur)',
                      prefixIcon:
                          Icon(Icons.work_outline, color: AppTheme.textMuted),
                    ),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Entrez le poste à pourvoir'
                        : null,
                  ),
                  const SizedBox(height: 14),

                  // Salaire horaire
                  TextFormField(
                    controller: _salaireController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Salaire horaire (€)',
                      prefixIcon: Icon(Icons.euro_rounded,
                          color: AppTheme.textMuted),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Entrez le salaire horaire';
                      }
                      if (double.tryParse(val) == null) {
                        return 'Entrez un montant valide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Adresse
                  TextFormField(
                    controller: _adresseController,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Adresse (optionnel)',
                      prefixIcon: Icon(Icons.location_on_outlined,
                          color: AppTheme.textMuted),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Erreur
                  Consumer<ProfileViewModel>(
                    builder: (context, vm, _) {
                      if (vm.error == null) return const SizedBox.shrink();
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(vm.error!,
                            style: const TextStyle(
                                color: AppTheme.error, fontSize: 13)),
                      );
                    },
                  ),

                  // Bouton Submit
                  Consumer<ProfileViewModel>(
                    builder: (context, vm, _) {
                      return Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.secondary, Color(0xFF00B4D8)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.secondary.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: vm.isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: vm.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : const Text(
                                  'Publier mon offre',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
