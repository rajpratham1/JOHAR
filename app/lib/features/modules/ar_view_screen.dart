import 'package:flutter/material.dart';

/// Placeholder AR surface.
///
/// TODO(johar): replace with real markerless AR using `ar_flutter_plugin`
/// (ARCore). Steps to wire it up:
///   1. Un-comment ar_flutter_plugin in pubspec.yaml and `flutter pub get`.
///   2. Add ARCore + CAMERA permission to android/app/src/main/AndroidManifest.xml.
///   3. Load the glTF/GLB model for this hazard, detect a plane, and place it.
///   4. Provide a non-AR 3D fallback (model_viewer_plus) for devices without
///      ARCore so the app still runs on all mid-range phones.
class ArViewScreen extends StatelessWidget {
  const ArViewScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Container(
        color: Colors.black,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.view_in_ar, size: 96, color: Colors.white24),
            const SizedBox(height: 16),
            const Text('AR scene',
                style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Markerless ARCore simulation renders here.\nPoint the camera at the floor to place the hazard scenario.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, height: 1.5),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
