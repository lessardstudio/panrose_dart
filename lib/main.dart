import 'dart:math';
import 'package:flutter/material.dart';
import 'types.dart';
import 'options_frame.dart';
import 'penrose_tiles_painter.dart';

void main() {
  runApp(const PenroseTilesApp());
}

class PenroseTilesApp extends StatelessWidget {
  const PenroseTilesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penrose Tiles',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PenroseTilesHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PenroseTilesHomePage extends StatefulWidget {
  const PenroseTilesHomePage({super.key});

  @override
  State<PenroseTilesHomePage> createState() => _PenroseTilesHomePageState();
}

class _PenroseTilesHomePageState extends State<PenroseTilesHomePage> {
  late DrawOptions options;

  @override
  void initState() {
    super.initState();
    // Initialize options - will be updated in didChangeDependencies
    options = DrawOptions(
      numSubdivisions: 5,
      numRays: 10,
      wheelRadius: 400,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Calculate initial wheel radius based on screen size
    final size = MediaQuery.of(context).size;
    final wheelRadius = 1.2 * sqrt(pow(size.width / 2.0, 2) + pow(size.height / 2.0, 2));
    
    setState(() {
      options = options.copyWith(wheelRadius: wheelRadius);
    });
  }

  void _handleOptionsChanged(DrawOptions newOptions) {
    setState(() {
      options = newOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Canvas for drawing Penrose tiles
          CustomPaint(
            painter: PenroseTilesPainter(options),
            size: Size.infinite,
            child: Container(),
          ),
          // Options panel
          OptionsFrame(
            options: options,
            onChanged: _handleOptionsChanged,
          ),
        ],
      ),
    );
  }
}
