import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, this.scale = 1});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: const SpinKitWaveSpinner(
        color: Colors.white,
      ),
    );
  }
}
