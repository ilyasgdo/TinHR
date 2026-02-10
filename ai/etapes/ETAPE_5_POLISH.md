# ✨ ÉTAPE 5 — POLISH, TESTS & DÉPLOIEMENT

> **Objectif** : Finaliser l'UI, corriger les bugs, et préparer l'app pour un premier test réel.  
> **Statut** : ⬜ Non commencé  
> **Dépendance** : ✅ Étape 4 complétée

---

## Checklist

### 1. Polish UI/UX
- [ ] Revoir la cohérence visuelle (couleurs, typographie, espacements)
- [ ] Ajouter des animations de transition entre les écrans
- [ ] Implémenter un **Dark Mode** (optionnel mais recommandé)
- [ ] Ajouter des micro-animations (loading, success, error states)
- [ ] Responsive : tester sur différentes tailles d'écran

### 2. Gestion du profil
- [ ] Écran **Mon Profil** :
  - [ ] Voir ses propres informations
  - [ ] Modifier sa photo, ses tags, son titre
  - [ ] Modifier son rayon de recherche (km)
  - [ ] Se déconnecter
- [ ] Mettre à jour la position GPS à chaque ouverture de l'app

### 3. Gestion des erreurs
- [ ] Gérer la perte de connexion (offline mode basique)
- [ ] Gérer les erreurs Supabase (timeout, quota, etc.)
- [ ] Messages d'erreur user-friendly (pas de stacktrace)
- [ ] Loading states partout (skeleton loaders)

### 4. Row Level Security (RLS) — Sécurité
- [ ] Revoir TOUTES les policies RLS :
  - [ ] `profiles` : un user ne peut modifier que son propre profil
  - [ ] `swipes` : un user ne peut créer que ses propres swipes
  - [ ] `matches` : un user ne peut voir que ses propres matches
  - [ ] `messages` : un user ne peut lire/écrire que dans ses propres matches
- [ ] Tester chaque policy manuellement

### 5. Tests
- [ ] Tests unitaires sur les services (Auth, Feed, Swipe, Match, Chat)
- [ ] Tests d'intégration : parcours complet inscription → swipe → match → chat
- [ ] Test sur device Android réel
- [ ] Test sur device iOS réel (si disponible)

### 6. Build & Distribution
- [ ] Build APK Android debug pour tests
- [ ] Configurer les icônes et splash screen
- [ ] Préparer les assets (logo, images placeholder)

---

## ✅ Critères de validation
- [ ] L'app est fluide et visuellement cohérente
- [ ] Aucun crash sur un parcours complet
- [ ] Les RLS empêchent tout accès non autorisé
- [ ] L'APK fonctionne sur un device réel
- [ ] Le parcours complet fonctionne : inscription → profil → swipe → match → chat

---

## 📝 Ce qui a été fait
> _À compléter au fur et à mesure du développement._
