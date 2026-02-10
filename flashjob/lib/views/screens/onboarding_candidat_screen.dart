import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/profile_viewmodel.dart';
import 'home_screen.dart';

/// Écran d'onboarding pour les candidats.
class OnboardingCandidatScreen extends StatefulWidget {
  const OnboardingCandidatScreen({super.key});

  @override
  State<OnboardingCandidatScreen> createState() =>
      _OnboardingCandidatScreenState();
}

class _OnboardingCandidatScreenState extends State<OnboardingCandidatScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prenomController = TextEditingController();
  final _posteController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController();
  final List<String> _tags = [];
  XFile? _pickedImage;

  @override
  void dispose() {
    _prenomController.dispose();
    _posteController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
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

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && _tags.length < 3 && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_tags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajoutez au moins 1 compétence')),
      );
      return;
    }

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
    final profile = await profileVM.createCandidatProfile(
      prenom: _prenomController.text.trim(),
      titrePoste: _posteController.text.trim(),
      tags: _tags,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
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
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.person_search_rounded,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Profil Candidat',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary)),
                          Text('Complétez votre profil',
                              style: TextStyle(
                                  fontSize: 13, color: AppTheme.textMuted)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Photo
                  Center(
                    child: GestureDetector(
                      onTap: _pickPhoto,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primary.withValues(alpha: 0.5),
                            width: 3,
                          ),
                        ),
                        child: _pickedImage == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt_rounded,
                                      color: AppTheme.primaryLight, size: 32),
                                  SizedBox(height: 4),
                                  Text('Photo',
                                      style: TextStyle(
                                          color: AppTheme.textMuted,
                                          fontSize: 12)),
                                ],
                              )
                            : const Icon(Icons.check_circle,
                                color: AppTheme.success, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Prénom
                  TextFormField(
                    controller: _prenomController,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Prénom',
                      prefixIcon:
                          Icon(Icons.person_outline, color: AppTheme.textMuted),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Entrez votre prénom' : null,
                  ),
                  const SizedBox(height: 14),

                  // Poste recherché
                  TextFormField(
                    controller: _posteController,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Poste recherché (ex: Serveur)',
                      prefixIcon:
                          Icon(Icons.work_outline, color: AppTheme.textMuted),
                    ),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Entrez le poste recherché'
                        : null,
                  ),
                  const SizedBox(height: 14),

                  // Tags / Compétences
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _tagController,
                          style: const TextStyle(color: AppTheme.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Compétence (${_tags.length}/3)',
                            prefixIcon: const Icon(Icons.tag,
                                color: AppTheme.textMuted),
                          ),
                          onFieldSubmitted: (_) => _addTag(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _tags.length < 3 ? _addTag : null,
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: _tags.length < 3
                                ? AppTheme.primaryGradient
                                : null,
                            color: _tags.length >= 3
                                ? AppTheme.surfaceLight
                                : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  if (_tags.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: _tags.map((tag) {
                        return Chip(
                          label: Text(tag,
                              style: const TextStyle(color: Colors.white)),
                          backgroundColor: AppTheme.primary.withValues(alpha: 0.3),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          deleteIconColor: AppTheme.textMuted,
                          onDeleted: () => _removeTag(tag),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 14),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Description, expérience... (optionnel)',
                      prefixIcon: Icon(Icons.description_outlined,
                          color: AppTheme.textMuted),
                      alignLabelWithHint: true,
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
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.4),
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
                                  'Créer mon profil',
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
