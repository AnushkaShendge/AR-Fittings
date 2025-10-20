import 'package:arcore_flutter_plugin/src/arcore_node.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';

import 'package:arcore_flutter_plugin/src/shape/arcore_shape.dart';

class ArCoreRotatingNode extends ArCoreNode {
  ArCoreRotatingNode({
    this.shape,
    this.degreesPerSecond = 0.0,
    String? name,
    Vector3? position,
    Vector3? scale,
    Vector4? rotation,
  }) : super(
          name: name ?? '',
          shape: shape,
          position: position,
          scale: scale,
          rotation: rotation,
        );

  final double degreesPerSecond;
  final ArCoreShape? shape;

  @override
  Map<String, dynamic> toMap() => <String, dynamic>{
        'degreesPerSecond': this.degreesPerSecond,
      }
        ..addAll(super.toMap())
        ..removeWhere((String k, dynamic v) => v == null);
}

