import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'common/levelcontroller.dart';
import 'dart:html' as html;
//import 'package:url_strategy/url_strategy.dart';

void main() async {
  //setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: LevelController()),
          //AnimatedContainer(
          Container(
            color: const Color(0xffb991e9),
            height: 60.0,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Image.asset('assets/images/logo.png'),
                  iconSize: 100,
                  onPressed: () {
                    //html.window.open(widget.url,"_self");
                  },
                ),
                LayoutBuilder(builder: (context, constraints) {
                  return Row(
                    children: navBarItems,
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> navBarItems = [
  NavBarItem(
    imageNames: const ['Tunpressed.png', 'Tpressed.png', "Thover.png"],
    size: const [42.0, 42.0],
    url: 'https://twitter.com/MonkettesNFT',
  ),
  NavBarItem(
    imageNames: const ['Dunpressed.png', 'Dpressed.png', "Dhover.png"],
    size: const [42.0, 42.0],
    url: 'https://discord.com/invite/monkettes',
  ),
  NavBarItem(
    imageNames: const ['Junpressed.png', 'Jpressed.png', "Jhover.png"],
    size: const [100, 42],
    url: 'https://magiceden.io/marketplace/solana_monkette_busines',
  ),
];

class NavBarItem extends StatefulWidget {
  final List<String> imageNames;
  final List<double> size;
  final String url;

  NavBarItem({
    required this.imageNames,
    required this.size,
    required this.url,
  });

  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: HoverCrossFadeWidget(
        duration: const Duration(milliseconds: 1),
        firstChild: SizedBox(
          child: SpriteButton.asset(
            path: widget.imageNames[0],
            pressedPath: widget.imageNames[1],
            onPressed: () {},
            label: const Text(''),
            width: widget.size[0],
            height: widget.size[1],
          ),
        ),
        secondChild: SizedBox(
          child: SpriteButton.asset(
            path: widget.imageNames[2],
            pressedPath: widget.imageNames[1],
            onPressed: () {
              _launchURL();
            },
            label: const Text(''),
            width: widget.size[0],
            height: widget.size[1],
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    html.window.open(widget.url, "_self");
  }
}
