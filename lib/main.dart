import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  MobileAds.instance.initialize();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  print("Token do dispositivo: $token");

  // Carrega anúncios de abertura e intersticial antes do app iniciar
  await Future.wait([
    AppOpenAdManager.loadAd(),
    InterstitialAdManager.loadAd(),
  ]);

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Mensagem recebida em segundo plano: ${message.messageId}');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.pink,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    final ThemeData darkTheme = ThemeData(
      primarySwatch: Colors.pink,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mensagens Bíblicas',
      theme: _isDarkMode ? darkTheme : lightTheme,
      home: SplashScreen(),
    );
  }
}

// GERENCIADOR DE ANÚNCIO DE ABERTURA
class AppOpenAdManager {
  static AppOpenAd? _appOpenAd;
  static bool _isShowingAd = false;

  static Future<void> loadAd() async {
    if (_appOpenAd != null) return;

    AppOpenAd.load(
      adUnitId: 'ca-app-pub-1040656265404217/1184378405',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _showAdIfAvailable();
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd falhou ao carregar: $error');
        },
      ),
    );
  }

  static void _showAdIfAvailable() {
    if (_appOpenAd == null || _isShowingAd) return;

    _isShowingAd = true;

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _appOpenAd = null;
        _isShowingAd = false;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _appOpenAd = null;
        _isShowingAd = false;
      },
    );

    _appOpenAd!.show();
  }
}

class InterstitialAdManager {
  static InterstitialAd? _interstitialAd;

  // Método para verificar se o anúncio foi carregado
  static bool isAdLoaded() {
    return _interstitialAd != null;
  }

  static Future<void> loadAd() async {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-1040656265404217/4925562610',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd falhou ao carregar: $error');
          _interstitialAd = null;
          Future.delayed(const Duration(seconds: 5), loadAd); // Recarrega
        },
      ),
    );
  }

  static void showAd(VoidCallback onAdClosed) {
    if (_interstitialAd == null) {
      print('Anúncio intersticial não carregado.');
      return;
    }

    _interstitialAd!.show();
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        onAdClosed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        onAdClosed();
      },
    );
  }
}
