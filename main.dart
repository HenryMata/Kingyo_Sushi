import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Carousel',
      home: ImageCarousel(),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  _ImageCarouselState createState() => new _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 18.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    Widget carousel = new Carousel(
      boxFit: BoxFit.fill,
      images: [
        new AssetImage('assets/images/1.jpg'),
        new AssetImage('assets/images/2.jpg'),
        new AssetImage('assets/images/3.jpg'),
        new AssetImage('assets/images/4.jpg'),
        new AssetImage('assets/images/5.jpg'),
        new AssetImage('assets/images/6.jpg'),
        new AssetImage('assets/images/7.jpg'),
        new AssetImage('assets/images/8.jpg'),
        new AssetImage('assets/images/9.jpg'),
        new AssetImage('assets/images/10.jpg'),
      ],
      showIndicator: true,
      autoplay: false,
      //animationCurve: Curves.fastOutSlowIn,
      //animationDuration: Duration(seconds: 1),
    );

    Widget banner = new Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
        child: new Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0)),
            color: Colors.amber.withOpacity(0.5),
          ),
          padding: const EdgeInsets.all(10.0),
          child: new Text('Banner on top of carousel',
            style: TextStyle(
              fontFamily: 'fira',
              fontSize: animation.value,//18.0,
              //color: Colors.white,
            ),
          ),
        ),
      // ),
    //  ),
    );

    return new Scaffold(
      backgroundColor: Colors.black,
      
      body: new Container(
         
        child: new Container(
          
          padding: const EdgeInsets.only(top:35.0),
          height: screenHeight / 2,
          width: screenwidth,
          child: new ClipRRect(
            borderRadius: BorderRadius.circular(0.0),
            child: new Stack(
              children: [
                
                carousel,
                //new Text(currentpagepos.currentState.cambio==null ? "Hola":currentpagepos.currentState.cambio.toString()),
                banner,
              ],
            ),
            
            /*new Stack(
              children: [
                
                carousel,
                banner,
              ],
            ),*/
          ),
        ),
      ),
    );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}
