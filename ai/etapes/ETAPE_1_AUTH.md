# 🔐 ÉTAPE 1 — AUTHENTIFICATION & ONBOARDING

> **Objectif** : Permettre à un utilisateur de créer un compte, se connecter, et choisir son rôle (Candidat ou Recruteur).  
> **Statut** : ⬜ Non commencé  
> **Dépendance** : ✅ Étape 0 complétée

---

## Checklist

### 1. Écrans d'Auth
- [ ] Créer l'écran **Splash Screen** (logo + chargement)
- [ ] Créer l'écran **Login** (email + password)
- [ ] Créer l'écran **Register** (email + password + confirmation)
- [ ] Gérer la navigation : redirection auto si déjà connecté

### 2. Intégration Supabase Auth
- [ ] Implémenter `AuthService` avec :
  - [ ] `signUp(email, password)`
  - [ ] `signIn(email, password)`
  - [ ] `signOut()`
  - [ ] `getCurrentUser()`
  - [ ] `onAuthStateChange()` (listener)
- [ ] Gérer les erreurs (email déjà utilisé, mot de passe trop faible, etc.)
- [ ] Gérer la persistance de session

### 3. Choix du rôle
- [ ] Créer l'écran **Choix de rôle** (Candidat / Recruteur) — affiché après la 1ère inscription
- [ ] Sauvegarder le rôle dans la table `profiles`

### 4. Onboarding Candidat
- [ ] Écran de création de profil candidat :
  - [ ] Upload photo (vers Supabase Storage)
  - [ ] Prénom
  - [ ] Titre du poste recherché
  - [ ] 3 Tags de compétences (saisie libre ou prédéfinie)
  - [ ] Description / historique
  - [ ] Demander la permission GPS et récupérer la position

### 5. Onboarding Recruteur
- [ ] Écran de création de profil recruteur :
  - [ ] Nom de l'établissement
  - [ ] Photo du lieu
  - [ ] Titre du poste à pourvoir
  - [ ] Salaire horaire
  - [ ] Adresse (saisie manuelle + conversion GPS)

### 6. ViewModel & State Management
- [ ] Créer `AuthViewModel` (gestion de l'état auth)
- [ ] Créer `ProfileViewModel` (gestion du profil)
- [ ] Router intelligent : Splash → Login/Register → Choix rôle → Onboarding → Home

---

## ✅ Critères de validation
- [ ] Un utilisateur peut s'inscrire et se connecter
- [ ] Le rôle est bien enregistré en base
- [ ] Le profil complet est créé avec photo uploadée
- [ ] La position GPS est enregistrée dans le profil
- [ ] La session persiste au redémarrage de l'app

---

## 📝 Ce qui a été fait
> _À compléter au fur et à mesure du développement._
