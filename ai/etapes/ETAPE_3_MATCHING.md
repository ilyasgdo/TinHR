# 🎯 ÉTAPE 3 — SYSTÈME DE MATCHING

> **Objectif** : Détecter un double-like et créer un Match avec notification visuelle.  
> **Statut** : ⬜ Non commencé  
> **Dépendance** : ✅ Étape 2 complétée

---

## Checklist

### 1. Logique de détection de Match (Backend)
- [ ] Créer une **Database Function** PostgreSQL `check_and_create_match(swiper_id, swiped_id)` :
  - [ ] Vérifie si `swiped_id` a déjà liké `swiper_id`
  - [ ] Si oui → INSERT dans `matches` avec `expires_at = NOW() + 24h`
  - [ ] Retourne `true` si match créé, `false` sinon
- [ ] Appeler cette fonction après chaque swipe "LIKE" depuis `SwipeService`

### 2. Notification Realtime de Match
- [ ] Configurer Supabase Realtime sur la table `matches`
- [ ] Créer `MatchService` :
  - [ ] `subscribeToMatches(userId)` — écoute les nouveaux matches en temps réel
  - [ ] `getMyMatches(userId)` — récupère tous les matches actifs
  - [ ] `isMatchExpired(match)` — vérifie l'expiration 24h
- [ ] Créer `MatchViewModel` : gestion de l'état des matches

### 3. UI — Popup "C'est un Match !"
- [ ] Créer le dialog/modal **MatchPopup** :
  - [ ] Photos des deux profils côte à côte
  - [ ] Message "C'est un Match ! 🎉"
  - [ ] Bouton "Envoyer un message" → ouvre le chat
  - [ ] Bouton "Continuer à swiper"
- [ ] Déclencher le popup en temps réel dès la détection

### 4. Écran Liste des Matches
- [ ] Créer l'écran **Matches** :
  - [ ] Liste des matches actifs (avec photo, nom, poste)
  - [ ] Indicateur de temps restant (compte à rebours 24h)
  - [ ] Tap sur un match → ouvre le chat (Étape 4)
  - [ ] Suppression automatique des matches expirés

---

## ✅ Critères de validation
- [ ] Un double-like crée bien un match en base
- [ ] Le popup "C'est un Match !" apparaît en temps réel
- [ ] La liste des matches affiche les matches actifs
- [ ] Les matches expirés (>24h) sont correctement filtrés/supprimés

---

## 📝 Ce qui a été fait
> _À compléter au fur et à mesure du développement._
