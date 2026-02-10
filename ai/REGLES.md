# 📏 RÈGLES DE DÉVELOPPEMENT — FlashJob

> Ces règles sont **obligatoires** et doivent être respectées à chaque intervention sur le code.

---

## 🔴 Règles Absolues

### 1. Toujours vérifier ce qui a été fait avant
> **Avant de coder quoi que ce soit**, lire le fichier `PROGRESSION.md` et les fichiers d'étapes pour savoir exactement où en est le projet. Ne jamais dupliquer du travail déjà fait.

### 2. Ne jamais s'éloigner du MVP
> Le scope est défini dans `ai/mvp.md`. **Aucune feature hors scope** ne doit être ajoutée. Pas de "nice to have", pas de "ça serait cool si...". On livre le MVP, point.

### 3. Une étape à la fois
> Ne pas commencer une étape si la précédente n'est pas **entièrement terminée et validée**. Les dépendances entre étapes existent pour une raison.

### 4. Credentials d'abord, code ensuite
> L'Étape 0 (Setup) doit être **100% complétée** avant toute ligne de code métier. Sans credentials Supabase fonctionnels, rien ne peut avancer.

---

## 🟡 Règles de Code

### 5. Architecture MVVM stricte
- `models/` → Données pures (pas de logique)
- `views/` → UI pure (pas de logique métier)
- `viewmodels/` → Logique de présentation
- `services/` → Communication avec Supabase
- `core/` → Config, constantes, utilitaires

### 6. Nommer clairement
- Fichiers, classes, fonctions : noms explicites en anglais
- Pas d'abréviations cryptiques
- Un fichier = une responsabilité

### 7. Pas de TODO en production
- Chaque TODO doit être résolu dans la même étape
- Si un TODO concerne une étape future : le noter dans le fichier d'étape concerné, pas dans le code

---

## 🟢 Règles de Processus

### 8. Mettre à jour la progression
> Après chaque sous-tâche complétée, **cocher la case** dans le fichier d'étape correspondant et mettre à jour `PROGRESSION.md`.

### 9. Tester avant de passer à la suite
> Chaque étape a des **critères de validation**. Tous doivent être verts avant de passer à l'étape suivante.

### 10. Git commit par fonctionnalité
> Un commit par sous-fonctionnalité terminée avec un message clair :
> ```
> feat(auth): implement sign up with Supabase
> feat(feed): add PostGIS nearby profiles query
> fix(chat): fix realtime subscription leak
> ```

### 11. Documenter les décisions
> Si une décision technique est prise (ex: choix d'un package, changement d'approche), la noter dans la section "Ce qui a été fait" du fichier d'étape.

---

## 🔒 Stack Imposée — Ne pas dévier

| Composant | Techno | Alternative autorisée |
|---|---|---|
| Frontend | Flutter | ❌ Aucune |
| Backend | Supabase | ❌ Aucune |
| Auth | Supabase Auth | ❌ Aucune |
| Base de données | PostgreSQL | ❌ Aucune |
| Géolocalisation | PostGIS | ❌ Aucune |
| Stockage | Supabase Storage | ❌ Aucune |
| Realtime | Supabase Realtime | ❌ Aucune |
| Coût | 0€ (Free Tier) | ❌ Aucun service payant |
