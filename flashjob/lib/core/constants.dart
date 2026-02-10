/// Configuration constants for the FlashJob application.
class AppConstants {
  // Supabase
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  // Geolocation
  static const double defaultSearchRadiusKm = 20.0;
  static const int maxProfilesPerBatch = 20;

  // Anti-Ghosting
  static const int matchExpirationHours = 24;

  // Storage
  static const String avatarsBucket = 'avatars';

  // Roles
  static const String roleCandidate = 'candidat';
  static const String roleRecruiter = 'recruteur';
}
