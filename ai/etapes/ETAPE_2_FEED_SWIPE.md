# 🃏 ÉTAPE 2 — FEED DE CARTES & SWIPE

> **Objectif** : Afficher les profils pertinents sous forme de cartes swipables et enregistrer les actions.  
> **Statut** : ⬜ Non commencé  
> **Dépendance** : ✅ Étape 1 complétée

---

## Checklist

### 1. Fonction PostGIS — Profils à proximité
- [ ] Créer/finaliser la RPC Supabase `get_nearby_profiles(user_lat, user_lng, radius_km, user_id)`
- [ ] La fonction doit :
  - [ ] Filtrer par rôle opposé (Candidat ↔ Recruteur)
  - [ ] Exclure les profils déjà swipés (LEFT JOIN sur `swipes`)
  - [ ] Trier par distance croissante
  - [ ] Retourner un maximum de 20 profils à la fois (pagination)

### 2. Service de Feed
- [ ] Créer `FeedService` qui appelle la RPC
- [ ] Gérer le cache local des profils chargés
- [ ] Gérer le rechargement quand la pile est vide

### 3. UI — Pile de cartes
- [ ] Créer le widget **SwipeCard** :
  - [ ] Photo en plein écran
  - [ ] Informations superposées (nom, poste, distance, tags/salaire)
  - [ ] Animation de swipe gauche/droite
- [ ] Créer le widget **CardStack** :
  - [ ] Pile de cartes superposées (effet de profondeur)
  - [ ] Gestion du geste de swipe (Dismissible ou package `flutter_card_swiper`)
  - [ ] Boutons Like / Dislike en bas

### 4. Enregistrement des actions
- [ ] Créer `SwipeService` :
  - [ ] `recordSwipe(swiperId, swipedId, action)` → INSERT dans `swipes`
  - [ ] Vérifier le match après chaque LIKE (voir Étape 3)
- [ ] Créer `FeedViewModel` : état de la pile, chargement, actions

### 5. Écran principal (Home)
- [ ] Créer l'écran **Home** avec :
  - [ ] La pile de cartes au centre
  - [ ] Navigation bottom bar (Feed, Matches, Profil)
  - [ ] Indicateur de chargement / message "plus de profils"

---

## ✅ Critères de validation
- [ ] Les profils proches du rôle opposé s'affichent
- [ ] Les profils déjà vus ne réapparaissent pas
- [ ] Le swipe gauche/droite fonctionne avec animation fluide
- [ ] Les actions sont bien enregistrées en base de données
- [ ] La pile se recharge quand elle est vide

---

## 📝 Ce qui a été fait
> _À compléter au fur et à mesure du développement._
