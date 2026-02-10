# 🔐 ÉTAPE 1 — AUTHENTIFICATION & ONBOARDING

> **Objectif** : Permettre à un utilisateur de créer un compte, se connecter, et choisir son rôle (Candidat ou Recruteur).  
> **Statut** : ✅ Complété  
> **Dépendance** : ✅ Étape 0 complétée

---

## Checklist

### 1. Écrans d'Auth
- [x] Créer l'écran **Splash Screen** (logo + chargement)
- [x] Créer l'écran **Login** (email + password)
- [x] Créer l'écran **Register** (email + password + confirmation)
- [x] Gérer la navigation : redirection auto si déjà connecté

### 2. Intégration Supabase Auth
- [x] Implémenter `AuthService` avec :
  - [x] `signUp(email, password)`
  - [x] `signIn(email, password)`
  - [x] `signOut()`
  - [x] `getCurrentUser()`
  - [x] `onAuthStateChange()` (listener)
- [x] Gérer les erreurs (email déjà utilisé, mot de passe trop faible, etc.)
- [x] Gérer la persistance de session

### 3. Choix du rôle
- [x] Créer l'écran **Choix de rôle** (Candidat / Recruteur) — affiché après la 1ère inscription
- [x] Sauvegarder le rôle dans la table `profiles`

### 4. Onboarding Candidat
- [x] Écran de création de profil candidat :
  - [x] Upload photo (vers Supabase Storage)
  - [x] Prénom
  - [x] Titre du poste recherché
  - [x] 3 Tags de compétences (saisie libre)
  - [x] Description / historique
  - [x] Demander la permission GPS et récupérer la position

### 5. Onboarding Recruteur
- [x] Écran de création de profil recruteur :
  - [x] Nom de l'établissement
  - [x] Photo du lieu
  - [x] Titre du poste à pourvoir
  - [x] Salaire horaire
  - [x] Adresse (saisie manuelle)

### 6. ViewModel & State Management
- [x] Créer `AuthViewModel` (gestion de l'état auth)
- [x] Créer `ProfileViewModel` (gestion du profil)
- [x] Router intelligent : Splash → Login/Register → Choix rôle → Onboarding → Home

---

## ✅ Critères de validation
- [x] Un utilisateur peut s'inscrire et se connecter
- [x] Le rôle est bien enregistré en base
- [x] Le profil complet est créé avec photo uploadée
- [x] La position GPS est enregistrée dans le profil
- [x] La session persiste au redémarrage de l'app

---

## 📝 Ce qui a été fait
- `models/profile.dart` — Modèle Profile avec fromMap/toMap/copyWith/isComplete
- `services/auth_service.dart` — AuthService (signUp, signIn, signOut, erreurs FR)
- `services/profile_service.dart` — ProfileService (CRUD profiles, upload photo Storage)
- `viewmodels/auth_viewmodel.dart` — AuthViewModel (machine d'état auth + profil check)
- `viewmodels/profile_viewmodel.dart` — ProfileViewModel (upload photo, GPS, création profil)
- `views/screens/splash_screen.dart` — Splash animé avec redirection auto
- `views/screens/login_screen.dart` — Login avec validation et erreurs
- `views/screens/register_screen.dart` — Register avec confirmation mot de passe
- `views/screens/role_selection_screen.dart` — Choix Candidat/Recruteur avec cartes
- `views/screens/onboarding_candidat_screen.dart` — Profil candidat complet
- `views/screens/onboarding_recruteur_screen.dart` — Profil recruteur complet
- `views/screens/home_screen.dart` — Home avec navigation bottom (placeholder Étape 2)
- `main.dart` mis à jour avec MultiProvider et SplashScreen
- `flutter analyze` → **No issues found!**
