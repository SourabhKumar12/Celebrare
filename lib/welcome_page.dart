import 'package:flutter/material.dart';
import 'package:celebrare/image_page.dart';

class WelcomPage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomPage> {
  bool showImage = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showImage = false;
      });
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).push(_createRoute());
      });
    });
  }

  PageRouteBuilder _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return SourabhPage();
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: Image.asset(
                  'images/celebrare.png',
                  height: 500.0,
                  width: 500.0,
                )
              
        ),
      ),
    );
  }
}
