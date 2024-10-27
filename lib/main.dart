import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar Mobile Ads
  MobileAds.instance.initialize();

  // Definir o handler para mensagens em segundo plano
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Carrega o anúncio de abertura do app
  AppOpenAdManager.loadAd();

  runApp(const MyApp());
}

// Função para lidar com mensagens em segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Mensagem recebida em segundo plano: ${message.messageId}');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseMessaging _messaging;

  @override
  void initState() {
    super.initState();

    // Inicializar Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // Solicitar permissão para iOS
    _messaging.requestPermission();

    // Obter o token do dispositivo para envio de notificações
    _messaging.getToken().then((token) {
      print('Token do dispositivo: $token');
    });

    // Listener para mensagens quando o app está em primeiro plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Mensagem recebida em primeiro plano: ${message.notification?.title}');
      // Exibir notificação ou realizar ação
    });

    // Listener para quando o app é aberto a partir de uma notificação
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'Mensagem aberta a partir de uma notificação: ${message.notification?.title}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mensagens Bíblicas',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.pinkAccent,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class AppOpenAdManager {
  static AppOpenAd? _appOpenAd;
  static bool _isShowingAd = false;
  static bool _isAdShown = false;

  static void loadAd() {
    if (_isAdShown) return;

    AppOpenAd.load(
      adUnitId: 'ca-app-pub-1040656265404217/1184378405',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _showAdIfAvailable();
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  static void _showAdIfAvailable() {
    if (_appOpenAd == null || _isShowingAd) {
      return;
    }

    _isShowingAd = true;
    _isAdShown = true;

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
