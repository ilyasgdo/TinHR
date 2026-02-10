# =============================================
# FlashJob - Dockerfile pour Render (Flutter Web)
# =============================================

# Étape 1 : Build Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copier le projet Flutter
COPY flashjob/ .

# Installer les dépendances
RUN flutter pub get

# Build web en release
# Les clés Supabase sont publiques (anon key = clé client protégée par RLS)
RUN flutter build web --release \
    --dart-define=SUPABASE_URL=https://cfrjraxgeihrszircozf.supabase.co \
    --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNmcmpyYXhnZWlocnN6aXJjb3pmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA3NTc4OTEsImV4cCI6MjA4NjMzMzg5MX0.SZBQPW4tLOfJ49jzDezEaRlb3rk3Q8E3F4syrmOeXL8

# Étape 2 : Servir avec Nginx
FROM nginx:alpine

# Copier la config nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier le build web
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
