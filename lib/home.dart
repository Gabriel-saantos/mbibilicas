import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'category_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: 'pub-1040656265404217', // Substitua pelo seu ID de unidade de anúncio
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Failed to load a banner ad: ${error.message}');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9, // Atualize o comprimento do TabController
      child: Scaffold(
      //  floatingActionButton: FloatingActionButton(
        //  onPressed: () {},
//child: const Icon(Icons.favorite),
//),
        appBar: AppBar(
          title: const Text('Mensagens Bíblicas'),
          bottom: const TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: <Widget>[
              Tab(text: 'Bom dia'),
              Tab(text: 'Boa Tarde'),
              Tab(text: 'Boa noite'),
              Tab(text: 'Fé'),
              Tab(text: 'Esperança'),
              Tab(text: 'Amor'),
              Tab(text: 'Paz'),
              Tab(text: 'Salmos'),
              Tab(text: 'Provérbios'),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            const TabBarView(
              children: <Widget>[
                CategoryView(category: 'Bom dia'),
                CategoryView(category: 'Boa Tarde'),
                CategoryView(category: 'Boa noite'),
                CategoryView(category: 'Fé'),
                CategoryView(category: 'Esperança'),
                CategoryView(category: 'Amor'),
                CategoryView(category: 'Paz'),
                CategoryView(category: 'Salmos'),
                CategoryView(category: 'Provérbios'),
              ],
            ),
            if (_isBannerAdReady)
              Positioned(
                bottom: 0,
                child: Container(
                  alignment: Alignment.center,
                  child: AdWidget(ad: _bannerAd),
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
