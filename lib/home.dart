import 'package:flutter/material.dart';
import 'package:myapp/bannerads.dart';
import 'package:myapp/compartilhar.dart';
import 'package:myapp/favoritos.dart';
import 'package:myapp/main.dart';
import 'package:myapp/mensagemdodia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'category_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  Future<void> _saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> _openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  backgroundImage: AssetImage("images/logobg.png"),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Mensagens Bíblicas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Compartilhe a palavra de Deus',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                  icon: Icons.favorite,
                  label: 'Favoritos',
                 onTap: () {
  InterstitialAdManager.showAd(() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoritesScreen()),
    );
  });
},

                ),
                _buildDrawerItem(
                  icon: Icons.bookmark,
                  label: 'Mensagem do dia',


                     onTap: () {
  InterstitialAdManager.showAd(() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MensagemDoDiaScreen()),
    );
  });
},

                  ),
                
                _buildDrawerItem(
                  icon: Icons.share_outlined,
                  label: 'Compartilhar',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Compartilhar()),
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.star,
                  label: 'Avaliar aplicativo',
                  onTap: () => _openLink(
                    'https://play.google.com/store/apps/details?id=com.tooapps.mensagensbiblicas',
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.people_alt,
                  label: 'Siga-nos',
                  onTap: () => _openLink('https://www.instagram.com/too.apps/'),
                ),
                _buildDrawerItem(
                  icon: Icons.info_outline,
                  label: 'Política de Privacidade',
                  onTap: () => _openLink(
                      'https://mensagens-biblicas-c5254.web.app/politicadeprivacidade.html'),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),
          SwitchListTile(
            title: Text(_isDarkMode ? 'Modo Claro' : 'Modo Escuro'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
                _saveThemePreference(_isDarkMode);
              });
            },
            secondary: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.pink,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: const [
                Text('Mensagens Bíblicas', style: TextStyle(fontSize: 12)),
                Text('Too apps', style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData(
      primarySwatch: Colors.pink,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: _isDarkMode ? Colors.black : Colors.white,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: DefaultTabController(
        length: 12,
        child: Scaffold(
          drawer: _buildDrawer(context),
          appBar: AppBar(
            title: const Text('Mensagens Bíblicas'),
            bottom: const TabBar(
              tabAlignment: TabAlignment.start,
              labelColor: Colors.pink,
              indicatorColor: Colors.pink,
              isScrollable: true,
              tabs: [
                Tab(icon: Icon(Icons.explore)),
                Tab(text: 'Bom dia'),
                Tab(text: 'Boa Tarde'),
                Tab(text: 'Boa noite'),
                Tab(text: 'Provérbios'),
                Tab(text: 'Salmos'),
                Tab(text: 'Gratidão'),
                Tab(text: 'Aniversário'),
                Tab(text: 'Esperança'),
                Tab(text: 'Amor'),
                Tab(text: 'Paz'),
                Tab(text: 'Fé'),
              ],
            ),
          ),
          body: Stack(
            children: [
              const TabBarView(
                children: [
                  CategoryView(category: 'Descobrir'),
                  CategoryView(category: 'Bom dia'),
                  CategoryView(category: 'Boa Tarde'),
                  CategoryView(category: 'Boa noite'),
                  CategoryView(category: 'Provérbios'),
                  CategoryView(category: 'Salmos'),
                  CategoryView(category: 'Gratidão'),
                  CategoryView(category: 'Aniversário'),
                  CategoryView(category: 'Esperança'),
                  CategoryView(category: 'Amor'),
                  CategoryView(category: 'Paz'),
                  CategoryView(category: 'Fé'),
                ],
              ),
              BannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
