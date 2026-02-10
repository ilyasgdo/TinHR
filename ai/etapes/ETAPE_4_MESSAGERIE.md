# 💬 ÉTAPE 4 — MESSAGERIE ANTI-GHOSTING

> **Objectif** : Permettre aux utilisateurs matchés de discuter en temps réel, avec un mécanisme anti-ghosting (expiration 24h).  
> **Statut** : ⬜ Non commencé  
> **Dépendance** : ✅ Étape 3 complétée

---

## Checklist

### 1. Service de Messagerie
- [ ] Créer `ChatService` :
  - [ ] `sendMessage(matchId, senderId, content)` → INSERT dans `messages`
  - [ ] `getMessages(matchId)` → SELECT avec ORDER BY created_at
  - [ ] `subscribeToMessages(matchId)` → Supabase Realtime listener
  - [ ] `unsubscribe()` → Nettoyer les listeners

### 2. UI — Écran de Chat
- [ ] Créer l'écran **Chat** :
  - [ ] Header : photo + nom du match + compte à rebours 24h
  - [ ] Liste de messages (bulles style iMessage)
  - [ ] Différencier visuellement mes messages vs les siens
  - [ ] Input de texte avec bouton d'envoi
  - [ ] Scroll automatique vers le dernier message
  - [ ] Indicateur de chargement pendant l'envoi

### 3. Compte à rebours Anti-Ghosting
- [ ] Afficher un **timer visuel** dans le header du chat
- [ ] Calculer le temps restant : `expires_at - NOW()`
- [ ] Si le timer atteint 0 :
  - [ ] Désactiver l'input de message
  - [ ] Afficher un message "Ce match a expiré"
  - [ ] Option de retourner à la liste des matches

### 4. Logique d'expiration Backend
- [ ] Créer un **CRON job** Supabase (ou Edge Function schedulée) :
  - [ ] Supprimer/archiver les matches dont `expires_at < NOW()` et sans messages
- [ ] OU gérer côté client : vérifier l'expiration avant d'afficher

### 5. ChatViewModel
- [ ] Créer `ChatViewModel` :
  - [ ] Gestion de la liste de messages (stream)
  - [ ] Envoi de message
  - [ ] État du timer
  - [ ] Gestion de l'expiration

---

## ✅ Critères de validation
- [ ] Deux utilisateurs matchés peuvent s'envoyer des messages en temps réel
- [ ] Les messages apparaissent instantanément sans refresh
- [ ] Le compte à rebours 24h est visible et fonctionnel
- [ ] Un match expiré sans message est bien dissous
- [ ] L'input est désactivé si le match est expiré

---

## 📝 Ce qui a été fait
> _À compléter au fur et à mesure du développement._
