# 🔧 ÉTAPE 0 — SETUP & CREDENTIALS

> **Objectif** : Préparer l'environnement de développement complet avant d'écrire la moindre ligne de code métier.  
> **Statut** : ✅ Complété

---

## Checklist

### 1. Création du projet Flutter
- [x] Initialiser le projet Flutter (`flutter create flashjob`)
- [x] Vérifier que `flutter doctor` passe (Flutter 3.38.9 — Chrome OK)
- [x] Configurer l'architecture MVVM (dossiers `lib/models`, `lib/views`, `lib/viewmodels`, `lib/services`, `lib/core`)

### 2. Création du projet Supabase
- [x] Projet Supabase créé
- [x] Credentials récupérés :
  - [x] `SUPABASE_URL`
  - [x] `SUPABASE_ANON_KEY`
  - [x] `SUPABASE_SERVICE_ROLE_KEY`
- [x] Credentials stockés dans `.env` (ajouté au `.gitignore`)

### 3. Configuration Supabase dans Flutter
- [x] Dépendances installées (`supabase_flutter`, `flutter_dotenv`, `geolocator`, `provider`)
- [x] Supabase initialisé dans `main.dart` via `.env`
- [x] Connexion testée : `***** Supabase init completed *****` ✅

### 4. Activation des services Supabase
- [ ] Activer **Supabase Auth** (Email/Password) → à faire dans le dashboard
- [ ] Créer un bucket `avatars` dans **Supabase Storage** → à faire dans le dashboard
- [ ] Activer **Supabase Realtime** → script SQL prêt (`ALTER PUBLICATION`)
- [ ] Activer l'extension **PostGIS** → script SQL prêt (`CREATE EXTENSION`)

### 5. Schéma de base de données initial
- [x] Script SQL complet créé : `flashjob/supabase/schema.sql`
  - [x] Table `profiles` avec PostGIS (point géographique)
  - [x] Table `swipes` avec contrainte d'unicité
  - [x] Table `matches` avec expiration 24h
  - [x] Table `messages`
  - [x] Fonction `get_nearby_profiles()` (RPC PostGIS)
  - [x] Fonction `check_and_create_match()` (RPC)
  - [x] RLS policies pour toutes les tables
  - [x] Trigger `update_location()` automatique
- [ ] **⚠️ EXÉCUTER le script SQL dans le SQL Editor Supabase**

### 6. Git & Documentation
- [x] Repo Git initialisé
- [x] `.env` ajouté au `.gitignore`
- [x] Design system créé (`core/theme.dart` — dark mode premium)

### 7. Déploiement Web sur Render
- [ ] Créer un compte sur [render.com](https://render.com) (Free Tier)
- [ ] Créer un **Static Site** sur Render :
  - [ ] Source : connecter le repo GitHub/GitLab
  - [ ] Build Command : `cd flashjob && flutter build web --release`
  - [ ] Publish Directory : `flashjob/build/web`
- [ ] Configurer les **variables d'environnement** sur Render :
  - [ ] `SUPABASE_URL`
  - [ ] `SUPABASE_ANON_KEY`
- [ ] Tester le déploiement : l'app est accessible via l'URL Render
- [ ] Vérifier que la connexion Supabase fonctionne en production

---

## ✅ Critères de validation
- [x] `flutter run -d chrome` démarre sans erreur
- [x] La connexion à Supabase fonctionne (log: `Supabase init completed`)
- [ ] Les tables sont créées dans Supabase → **EXÉCUTER `schema.sql`**
- [ ] PostGIS activé → **EXÉCUTER `schema.sql`**
- [ ] Le bucket `avatars` est créé → **À faire dans le dashboard**
- [ ] L'app est déployée et accessible sur Render

---

## 📝 Ce qui a été fait
- **2026-02-10** : Flutter SDK 3.38.9 installé (`C:\flutter`), projet créé, architecture MVVM, 85 packages installés, `.env` configuré, design system dark premium, `main.dart` avec test connexion Supabase (OK), schéma SQL complet prêt à exécuter.

## ⚠️ Actions requises de l'utilisateur
1. **Exécuter `flashjob/supabase/schema.sql`** dans le SQL Editor de Supabase
2. **Créer le bucket `avatars`** dans Supabase Storage (dashboard)
3. **Vérifier que Auth Email/Password** est activé (dashboard)
4. **Créer un Static Site sur Render** connecté au repo, avec build command `cd flashjob && flutter build web --release` et publish dir `flashjob/build/web`
