import "package:flutter/material.dart";

class CustomPredictiveBackPageTransitionsBuilder
    extends PageTransitionsBuilder {
  const CustomPredictiveBackPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fastAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
    );

    final fastSecondaryAnimation = CurvedAnimation(
      parent: secondaryAnimation,
      curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
    );

    const originalBuilder = PredictiveBackPageTransitionsBuilder();

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return originalBuilder.buildTransitions(
          route,
          context,
          fastAnimation,
          fastSecondaryAnimation,
          child!,
        );
      },
      child: child,
    );
  }
}
