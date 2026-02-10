Spécifications Techniques & Fonctionnelles - Projet "FlashJob"
Rôle : Tu agis en tant que Lead Developer Fullstack. Ta mission est de développer le MVP d'une application mobile de recrutement inspirée des applications de rencontre (type Tinder), optimisée pour les métiers en tension (restauration, logistique).

Objectif Principal : Créer une application fluide, temps réel, basée sur la géolocalisation, permettant de matcher un candidat et un recruteur en moins de 5 minutes.

1. LA STACK TECHNIQUE (Imposée & Contraintes Gratuité)
Tu dois utiliser exclusivement des technologies ou disposant d'un "Free Tier" généreux pour un démarrage à 0€.

Frontend : Flutter (Dernière version stable). Architecture propre (MVVM ou Clean Architecture).

Backend & Base de données : Supabase (PostgreSQL).

Auth : Supabase Auth (Email/Password pour le MVP).

Database : PostgreSQL.

Géolocalisation : Extension PostGIS (Native dans Supabase/Postgres) pour les calculs de distance sans API payante type Google Maps.

Stockage : Supabase Storage (Pour les photos de profil).

Realtime : Supabase Realtime (Pour les notifications de Match et le Chat).

2. DÉFINITION DES RÔLES UTILISATEURS
Le système doit gérer deux types de profils distincts dès l'inscription :

Le Candidat : Cherche un job. Affiche ses compétences et sa disponibilité.

Le Recruteur : Cherche un employé. Affiche une offre (Lieu, Salaire, Poste).

3. FEATURES & FONCTIONNALITÉS DÉTAILLÉES (Scope MVP)
A. Onboarding & Profil "No-CV"
Feature : Création de compte ultra-rapide.

Données Candidat : Photo (obligatoire), Prénom, Titre du poste recherché (ex: "Serveur"), 3 Tags de compétences (ex: "Anglais", "Cocktails", "Service en salle"), description et historique de travail ectudes ... Zone géographique (GPS actuel).

Données Recruteur : Nom de l'établissement, Photo du lieu, Titre du poste à pourvoir, Salaire horaire, Adresse (GPS).

B. Moteur de Géolocalisation & Feed (Le Cœur du système)
Objectif : Afficher une pile de cartes (Stack) pertinentes pour l'utilisateur.

Règle Métier 1 (Filtre de Rôle) : Les Recruteurs ne voient QUE les Candidats. Les Candidats ne voient QUE les Recruteurs.

Règle Métier 2 (Géolocalisation PostGIS) : L'algorithme ne doit renvoyer que les profils situés dans un rayon de X km (configurable, par défaut 20km) autour de l'utilisateur. Le calcul doit être fait côté Base de Données pour la performance.

Règle Métier 3 (Exclusion) : Un utilisateur ne doit jamais revoir un profil qu'il a déjà "Liké" ou "Disliké".

C. Interaction de Swipe & Matching
Feature : Interface type "Tinder" (Swipe Droite = Intéressé, Swipe Gauche = Pas intéressé).
logique de recomandation de job et de profils 

Logique Backend :

Enregistrement de l'action dans la base de données.

Détection de Match : Si l'utilisateur A like B, le système doit vérifier instantanément si B a déjà liké A.

Si la condition est remplie (Double Like) -> Création d'un objet "Match" en base de données.

Si Match -> Notification visuelle immédiate ("C'est un Match !").

D. Messagerie Anti-Ghosting
Feature : Le chat ne s'ouvre QUE s'il y a un Match.

Contrainte "Flash" : Pour inciter à la réactivité, afficher un compte à rebours visuel. Si aucun message n'est échangé sous 24h, le match est automatiquement dissous (supprimé ou archivé).

Technique : Utiliser les WebSockets (Supabase Realtime) pour une discussion instantanée sans rechargement.

4. INSTRUCTIONS DE DÉVELOPPEMENT
 genere un plan sous forme ETAPE 0.md etape 1 .md etape 2.md ... et a chaque etape tu dis ce que tu as fais et coche les etapes dans u dossier comportant toutes les etapes don un premiere etappe de setup pour que tu a acces a tout les crendential pour travailler et uniquement apres tu dev lmes autre etapes 

 ensuite genere des regles du type toujour regarder ce qui a ete faios avant , ne jamais s'eloigner du mvp 