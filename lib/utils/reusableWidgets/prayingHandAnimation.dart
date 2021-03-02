import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class PayingHandAnimation extends StatefulWidget {
  @override
  _PayingHandAnimationState createState() => _PayingHandAnimationState();
}

class _PayingHandAnimationState extends State<PayingHandAnimation>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation slidingAnimation;

  Random random = new Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
      
    );
    slidingAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    Size size = getScreenSize(context: context);

    return Stack(
        children: List.generate(30, (index) {
      double randomX = random.nextDouble();
      double randromY = random.nextDouble();
      int randomSpeed = random.nextInt(3);

      return getHand(
          xx: 20 + (randomX * (size.width - 60)),
          yy: size?.height * (randromY),
          speed: (randomSpeed + 1.0));
    })
        /*[
        getHand(xx: size?.width * 0.1, yy: size?.height * 0.1, speed: 1.5),
        getHand(xx: size?.width * 0.2, yy: size?.height * 0.3),
        getHand(xx: size?.width * 0.4, yy: size?.height * 0.2, speed: 1.2),
        getHand(xx: size?.width * 0.6, yy: size?.height * 0.25),
        getHand(xx: size?.width * 0.8, yy: size?.height * 0.15, speed: 1.1),
        getHand(xx: size?.width * 1, yy: size?.height * 0.05),
        getHand(xx: size?.width * 0.3, yy: size?.height * 0.05),
        getHand(xx: size?.width * 0.5, yy: size?.height * 0.12, speed: 1.1),
        getHand(xx: size?.width * 0.7, yy: size?.height * 0.14),
        getHand(xx: size?.width * 0.9, yy: size?.height * 0.05, speed: 1.2),

        getHand(xx: size?.width * 0.1, yy: size?.height * 0.0, speed: 1.5),
        getHand(xx: size?.width * 0.2, yy: size?.height * -0.01),
        getHand(xx: size?.width * 0.4, yy: size?.height * 0.02, speed: 1.2),
        getHand(xx: size?.width * 0.6, yy: size?.height * 0.03),
        getHand(xx: size?.width * 0.8, yy: size?.height * 0.0, speed: 1.1),
        getHand(xx: size?.width * 1, yy: size?.height * 0.0),
        getHand(xx: size?.width * 0.3, yy: size?.height *- 0.01),
        getHand(xx: size?.width * 0.5, yy: size?.height * 0.02, speed: 1.1),
        getHand(xx: size?.width * 0.7, yy: size?.height *- 0.05),
        getHand(xx: size?.width * 0.9, yy: size?.height * -0.04, speed: 1.2)
      ],*/
        );
  }

  getHand({xx: 0, yy: 0, speed: 1}) {
    double height = getScreenSize(context: context).height;
    return AnimatedBuilder(
      animation: slidingAnimation,
      child: Image.asset(
        AssetStrings.hands,
        height: 20,
        width: 20,
      ),
      builder: (context, value) {
        return Positioned(
          bottom: slidingAnimation.value * (height * speed) + yy,
          left: xx,
          child: Image.asset(
            AssetStrings.hands,
            height: 20 + (slidingAnimation.value * 100),
            width: 20 + (slidingAnimation.value * 100),
            scale: 1,
            // color: Colors.red,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
