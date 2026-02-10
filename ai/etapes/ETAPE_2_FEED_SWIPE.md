# 🃏 ÉTAPE 2 — FEED DE CARTES & SWIPE

> **Objectif** : Afficher les profils pertinents sous forme de cartes swipables et enregistrer les actions.  
> **Statut** : ✅ Complété  
> **Dépendance** : ✅ Étape 1 complétée

---

## Checklist

### 1. Fonction PostGIS — Profils à proximité
- [x] Créer/finaliser la RPC Supabase `get_nearby_profiles(user_lat, user_lng, radius_km, user_id)`
- [x] La fonction doit :
  - [x] Filtrer par rôle opposé (Candidat ↔ Recruteur)
  - [x] Exclure les profils déjà swipés (LEFT JOIN sur `swipes`)
  - [x] Trier par distance croissante
  - [x] Retourner un maximum de 20 profils à la fois (pagination)

### 2. Service de Feed
- [x] Créer `FeedService` qui appelle la RPC
- [x] Gérer le cache local des profils chargés
- [x] Gérer le rechargement quand la pile est vide

### 3. UI — Pile de cartes
- [x] Créer le widget **SwipeCard** :
  - [x] Photo en plein écran
  - [x] Informations superposées (nom, poste, distance, tags/salaire)
  - [x] Animation de swipe gauche/droite
- [x] Créer le widget **CardStack** :
  - [x] Pile de cartes superposées (effet de profondeur)
  - [x] Gestion du geste de swipe (flutter_card_swiper v7)
  - [x] Boutons Like / Dislike en bas

### 4. Enregistrement des actions
- [x] Créer `SwipeService` :
  - [x] `recordSwipe(swiperId, swipedId, action)` → INSERT dans `swipes`
  - [x] Vérifier le match après chaque LIKE via `check_and_create_match`
- [x] Créer `FeedViewModel` : état de la pile, chargement, actions

### 5. Écran principal (Home)
- [x] Créer l'écran **Home** avec :
  - [x] La pile de cartes au centre
  - [x] Navigation bottom bar (Feed, Matches, Profil)
  - [x] Indicateur de chargement / message "plus de profils"

---

## ✅ Critères de validation
- [x] Les profils proches du rôle opposé s'affichent
- [x] Les profils déjà vus ne réapparaissent pas
- [x] Le swipe gauche/droite fonctionne avec animation fluide
- [x] Les actions sont bien enregistrées en base de données
- [x] La pile se recharge quand elle est vide

---

## 📝 Ce qui a été fait
- `models/nearby_profile.dart` — Modèle avec distance + formatage
- `services/feed_service.dart` — Appel RPC `get_nearby_profiles`
- `services/swipe_service.dart` — `recordSwipe` + `checkAndCreateMatch`
- `viewmodels/feed_viewmodel.dart` — Machine d'état (initial/loading/loaded/empty/error)
- `views/widgets/swipe_card.dart` — Carte premium avec photo, badges, tags/salaire
- `views/widgets/card_stack.dart` — Pile swipable + boutons + popup match
- `views/screens/home_screen.dart` — Intégration feed + matches (placeholder) + profil
- `main.dart` mis à jour avec FeedViewModel
- `pubspec.yaml` + `flutter_card_swiper: ^7.2.0`
- `flutter analyze` → **No issues found!**
- `flutter build web --release` → **✅ Built**
