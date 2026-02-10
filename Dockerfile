# =============================================
# FlashJob - Dockerfile pour Render (Flutter Web)
# =============================================

# Étape 1 : Build Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copier le projet Flutter
COPY flashjob/ .

# Copier le .env à la racine du projet Flutter (nécessaire pour flutter_dotenv)
COPY .env .env

# Installer les dépendances
RUN flutter pub get

# Build web en release
RUN flutter build web --release

# Étape 2 : Servir avec Nginx
FROM nginx:alpine

# Copier la config nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier le build web
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
