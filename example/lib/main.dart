import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ARScreen(),
    );
  }
}

class ARScreen extends StatefulWidget {
  const ARScreen({Key? key}) : super(key: key);

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  ArCoreController? _arCoreController;
  String _status = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Request camera permission
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        setState(() => _status = 'Camera permission denied');
        return;
      }

      setState(() => _status = 'Permission granted, checking ARCore...');

      // Check for ARCore availability
      final isAvailable = await ArCoreController.checkArCoreAvailability();
      if (!isAvailable) {
        setState(() => _status = 'ARCore is not available on this device.');
        return;
      }

      // Check if ARCore is installed
      final isInstalled = await ArCoreController.checkIsArCoreInstalled();
      if (!isInstalled) {
        setState(() => _status = 'ARCore not installed. Please install it from the Play Store.');
        return;
      }

      setState(() => _status = 'Ready to start AR');
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    _arCoreController = controller;

    try {
      final material = ArCoreMaterial(color: Colors.blue);
      final sphere = ArCoreSphere(materials: [material], radius: 0.1);
      final node = ArCoreNode(
        name: "sphere",
        shape: sphere,
        position: vector.Vector3(0, 0, -1.5),
      );

      _arCoreController?.addArCoreNode(node);
      setState(() => _status = 'AR Scene loaded!');
    } catch (e) {
      setState(() => _status = 'Failed to add node: $e');
    }
  }

  @override
  void dispose() {
    _arCoreController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Fittings'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          // AR View
          if (_status == 'Ready to start AR')
            ArCoreView(
              onArCoreViewCreated: _onArCoreViewCreated,
              enableTapRecognizer: true,
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      _status,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

          // Status overlay
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _status,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}