-- ============================================
-- FlashJob MVP - Schéma de Base de Données
-- À exécuter dans le SQL Editor de Supabase
-- ============================================

-- 1. Activer PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;

-- 2. Table des profils
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL UNIQUE,
  role TEXT NOT NULL CHECK (role IN ('candidat', 'recruteur')),
  
  -- Commun
  prenom TEXT NOT NULL,
  photo_url TEXT,
  
  -- Candidat
  titre_poste TEXT, -- poste recherché
  tags TEXT[] DEFAULT '{}', -- 3 compétences max
  description TEXT,
  
  -- Recruteur
  nom_etablissement TEXT,
  salaire_horaire DECIMAL(10,2),
  adresse TEXT,
  
  -- Géolocalisation
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  location GEOGRAPHY(POINT, 4326), -- Point PostGIS pour les calculs de distance
  
  -- Paramètres
  rayon_recherche_km INTEGER DEFAULT 20,
  
  -- Métadonnées
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index géographique pour les recherches par proximité
CREATE INDEX IF NOT EXISTS idx_profiles_location ON profiles USING GIST(location);
CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON profiles(user_id);

-- Trigger pour mettre à jour le point PostGIS automatiquement
CREATE OR REPLACE FUNCTION update_location()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.latitude IS NOT NULL AND NEW.longitude IS NOT NULL THEN
    NEW.location = ST_SetSRID(ST_MakePoint(NEW.longitude, NEW.latitude), 4326)::geography;
  END IF;
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_update_location
  BEFORE INSERT OR UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_location();

-- ============================================
-- 3. Table des swipes
-- ============================================
CREATE TABLE IF NOT EXISTS swipes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  swiper_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  swiped_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  action TEXT NOT NULL CHECK (action IN ('like', 'dislike')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Un utilisateur ne peut swiper un autre qu'une seule fois
  UNIQUE(swiper_id, swiped_id)
);

CREATE INDEX IF NOT EXISTS idx_swipes_swiper ON swipes(swiper_id);
CREATE INDEX IF NOT EXISTS idx_swipes_swiped ON swipes(swiped_id);

-- ============================================
-- 4. Table des matches
-- ============================================
CREATE TABLE IF NOT EXISTS matches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_a UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  user_b UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '24 hours'),
  
  -- Pas de doublon de match
  UNIQUE(user_a, user_b)
);

CREATE INDEX IF NOT EXISTS idx_matches_users ON matches(user_a, user_b);

-- ============================================
-- 5. Table des messages
-- ============================================
CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id UUID REFERENCES matches(id) ON DELETE CASCADE NOT NULL,
  sender_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_messages_match ON messages(match_id);

-- ============================================
-- 6. Fonction RPC - Profils à proximité
-- ============================================
CREATE OR REPLACE FUNCTION get_nearby_profiles(
  user_lat DOUBLE PRECISION,
  user_lng DOUBLE PRECISION,
  radius_km INTEGER DEFAULT 20,
  current_user_id UUID DEFAULT NULL
)
RETURNS TABLE (
  id UUID,
  user_id UUID,
  role TEXT,
  prenom TEXT,
  photo_url TEXT,
  titre_poste TEXT,
  tags TEXT[],
  description TEXT,
  nom_etablissement TEXT,
  salaire_horaire DECIMAL,
  adresse TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  distance_km DOUBLE PRECISION
) AS $$
DECLARE
  current_role TEXT;
BEGIN
  -- Récupérer le rôle de l'utilisateur actuel
  SELECT p.role INTO current_role FROM profiles p WHERE p.id = current_user_id;
  
  RETURN QUERY
  SELECT 
    p.id,
    p.user_id,
    p.role,
    p.prenom,
    p.photo_url,
    p.titre_poste,
    p.tags,
    p.description,
    p.nom_etablissement,
    p.salaire_horaire,
    p.adresse,
    p.latitude,
    p.longitude,
    ROUND((ST_Distance(
      p.location,
      ST_SetSRID(ST_MakePoint(user_lng, user_lat), 4326)::geography
    ) / 1000)::numeric, 1)::double precision AS distance_km
  FROM profiles p
  WHERE 
    -- Filtrer par rôle opposé
    p.role != current_role
    -- Exclure soi-même
    AND p.id != current_user_id
    -- Filtrer par distance
    AND ST_DWithin(
      p.location,
      ST_SetSRID(ST_MakePoint(user_lng, user_lat), 4326)::geography,
      radius_km * 1000 -- conversion km -> mètres
    )
    -- Exclure les profils déjà swipés
    AND p.id NOT IN (
      SELECT s.swiped_id FROM swipes s WHERE s.swiper_id = current_user_id
    )
  ORDER BY distance_km ASC
  LIMIT 20;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- 7. Fonction RPC - Vérifier et créer un match
-- ============================================
CREATE OR REPLACE FUNCTION check_and_create_match(
  p_swiper_id UUID,
  p_swiped_id UUID
)
RETURNS BOOLEAN AS $$
DECLARE
  match_exists BOOLEAN;
BEGIN
  -- Vérifier si l'autre personne a déjà liké
  SELECT EXISTS (
    SELECT 1 FROM swipes 
    WHERE swiper_id = p_swiped_id 
    AND swiped_id = p_swiper_id 
    AND action = 'like'
  ) INTO match_exists;
  
  IF match_exists THEN
    -- Créer le match (en évitant les doublons)
    INSERT INTO matches (user_a, user_b)
    VALUES (
      LEAST(p_swiper_id, p_swiped_id),
      GREATEST(p_swiper_id, p_swiped_id)
    )
    ON CONFLICT (user_a, user_b) DO NOTHING;
    
    RETURN TRUE;
  END IF;
  
  RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- 8. Row Level Security (RLS)
-- ============================================

-- Activer RLS sur toutes les tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE swipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Policies pour profiles
CREATE POLICY "Les profils sont visibles par tous les utilisateurs authentifiés"
  ON profiles FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Un utilisateur ne peut modifier que son propre profil"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Un utilisateur peut créer son propre profil"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Policies pour swipes
CREATE POLICY "Un utilisateur ne peut voir que ses propres swipes"
  ON swipes FOR SELECT
  TO authenticated
  USING (swiper_id IN (SELECT id FROM profiles WHERE user_id = auth.uid()));

CREATE POLICY "Un utilisateur peut créer ses propres swipes"
  ON swipes FOR INSERT
  TO authenticated
  WITH CHECK (swiper_id IN (SELECT id FROM profiles WHERE user_id = auth.uid()));

-- Policies pour matches
CREATE POLICY "Un utilisateur ne peut voir que ses propres matches"
  ON matches FOR SELECT
  TO authenticated
  USING (
    user_a IN (SELECT id FROM profiles WHERE user_id = auth.uid())
    OR user_b IN (SELECT id FROM profiles WHERE user_id = auth.uid())
  );

-- Policies pour messages
CREATE POLICY "Un utilisateur peut voir les messages de ses matches"
  ON messages FOR SELECT
  TO authenticated
  USING (
    match_id IN (
      SELECT m.id FROM matches m
      WHERE m.user_a IN (SELECT id FROM profiles WHERE user_id = auth.uid())
      OR m.user_b IN (SELECT id FROM profiles WHERE user_id = auth.uid())
    )
  );

CREATE POLICY "Un utilisateur peut envoyer des messages dans ses matches"
  ON messages FOR INSERT
  TO authenticated
  WITH CHECK (
    sender_id IN (SELECT id FROM profiles WHERE user_id = auth.uid())
    AND match_id IN (
      SELECT m.id FROM matches m
      WHERE m.user_a IN (SELECT id FROM profiles WHERE user_id = auth.uid())
      OR m.user_b IN (SELECT id FROM profiles WHERE user_id = auth.uid())
    )
  );

-- ============================================
-- 9. Activer Realtime sur les tables nécessaires
-- ============================================
ALTER PUBLICATION supabase_realtime ADD TABLE matches;
ALTER PUBLICATION supabase_realtime ADD TABLE messages;

-- ============================================
-- ✅ Vérification
-- ============================================
-- SELECT PostGIS_version();
-- SELECT * FROM profiles LIMIT 1;
