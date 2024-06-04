import 'package:flutter/material.dart';

class BeforeImageLoaded extends StatelessWidget {
  final VoidCallback onCameraPressed;
  final VoidCallback onGallerySwipe;

  const BeforeImageLoaded({
    super.key,
    required this.onCameraPressed,
    required this.onGallerySwipe,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = AnimationController(
      vsync: Scaffold.of(context),
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    final animation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.people_alt_sharp,
                  size: 200,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: onCameraPressed,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
              child: const Icon(Icons.camera_outlined, color: Colors.red, size: 50),
            ),
            const SizedBox(height: 50),
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, animation.value),
                  child: Transform.rotate(
                    angle: 1.5708,
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            const Text('Desliza hacia arriba para abrir la galería'),
            const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }
}