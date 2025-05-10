import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Tratamento global de erros
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('Erro Flutter: ${details.exceptionAsString()}');
  };

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    MobileAds.instance.initialize();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    print('Token do dispositivo: $token');
  } catch (e) {
    print('Erro durante inicialização: $e');
  }

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Mensagem em segundo plano: ${message.messageId}');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    AppOpenAdManager.loadAd(); // Carrega anúncio de abertura após o init
    InterstitialAdManager.loadAd();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primarySwatch: Colors.pink,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mensagens Bíblicas',
      theme: theme,
      home: const SplashScreen(),
    );
  }
}

// GERENCIADOR DE ANÚNCIO DE ABERTURA
class AppOpenAdManager {
  static AppOpenAd? _appOpenAd;
  static bool _isShowingAd = false;

  static void loadAd() {
    if (_appOpenAd != null) return;

    AppOpenAd.load(
      adUnitId: 'ca-app-pub-1040656265404217/1184378405',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd falhou ao carregar: $error');
        },
      ),
  //    orientation: AppOpenAd.orientationPortrait,
    );
  }

  static void showAdIfAvailable() {
    if (_appOpenAd == null || _isShowingAd) return;

    _isShowingAd = true;

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _appOpenAd = null;
        _isShowingAd = false;
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _appOpenAd = null;
        _isShowingAd = false;
        loadAd();
      },
    );

    _appOpenAd!.show();
  }
}

class InterstitialAdManager {
  static InterstitialAd? _interstitialAd;

  static bool isAdLoaded() => _interstitialAd != null;

  static void loadAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-1040656265404217/4925562610',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) {
          print('InterstitialAd falhou ao carregar: $error');
          _interstitialAd = null;
          Future.delayed(const Duration(seconds: 5), loadAd);
        },
      ),
    );
  }

  static void showAd(VoidCallback onAdClosed) {
    if (_interstitialAd == null) {
      print('Anúncio intersticial não carregado.');
      onAdClosed();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        onAdClosed();
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        onAdClosed();
        loadAd();
      },
    );

    _interstitialAd!.show();
  }
}
