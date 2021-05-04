import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class GetWave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: WaveWidget(
        config: CustomConfig(
          gradients: [
            [Colors.yellow, Color(0x55FFEB3B)],
            [Colors.red, Color(0xEEF44336)],
            [Colors.orange, Color(0x66FF9800)],
            [Colors.red.shade800, Color(0x77E57373)],
          ],
          durations: [35000, 19440, 10800, 6000],
          heightPercentages: [0.50, 0.50, 0.50, 0.55],
          gradientBegin: Alignment.bottomLeft,
          gradientEnd: Alignment.topRight,
        ),
        waveAmplitude: 0,
        size: Size(
          double.infinity,
          double.infinity,
        ),
      ),
    );
  }
}
