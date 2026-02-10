import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les variables d'environnement
  await dotenv.load(fileName: '.env');

  // Initialiser Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const FlashJobApp());
}

/// Instance globale du client Supabase
final supabase = Supabase.instance.client;

class FlashJobApp extends StatelessWidget {
  const FlashJobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlashJob',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const ConnectionTestScreen(),
    );
  }
}

/// Écran temporaire pour tester la connexion Supabase.
/// Sera remplacé par le SplashScreen à l'Étape 1.
class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  String _status = 'Connexion en cours...';
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  Future<void> _testConnection() async {
    try {
      // Test simple : vérifier que Supabase répond
      final response = await supabase.from('profiles').select().limit(1);
      setState(() {
        _status = '✅ Connecté à Supabase avec succès !';
        _connected = true;
      });
    } catch (e) {
      setState(() {
        // Si la table n'existe pas encore, c'est normal à ce stade
        if (e.toString().contains('relation') ||
            e.toString().contains('does not exist')) {
          _status =
              '✅ Connexion Supabase OK !\n⚠️ Table "profiles" pas encore créée.\n(Normal à ce stade)';
          _connected = true;
        } else {
          _status = '❌ Erreur : $e';
          _connected = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.background, Color(0xFF16213E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo / Titre
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'FlashJob',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Setup & Connection Test',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 48),

                // Status card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _connected
                          ? AppTheme.success.withValues(alpha: 0.3)
                          : AppTheme.surfaceLight,
                    ),
                  ),
                  child: Column(
                    children: [
                      if (!_connected && _status == 'Connexion en cours...')
                        const CircularProgressIndicator(
                          color: AppTheme.primary,
                        ),
                      if (_connected || _status != 'Connexion en cours...')
                        Icon(
                          _connected
                              ? Icons.check_circle_rounded
                              : Icons.error_rounded,
                          size: 48,
                          color:
                              _connected ? AppTheme.success : AppTheme.error,
                        ),
                      const SizedBox(height: 16),
                      Text(
                        _status,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: AppTheme.primaryLight, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'URL: ${dotenv.env['SUPABASE_URL']?.substring(0, 30)}...',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
