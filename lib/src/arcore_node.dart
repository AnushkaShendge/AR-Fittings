import 'package:arcore_flutter_plugin/src/arcore_image.dart';
import 'package:arcore_flutter_plugin/src/utils/vector_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:arcore_flutter_plugin/src/utils/random_string.dart'
    as random_string;
import 'package:arcore_flutter_plugin/src/shape/arcore_shape.dart';

class ArCoreNode {
  ArCoreNode({
    this.shape,
    this.image,
    this.children = const [],
    required this.name,
    this.position,
    this.scale,
    this.rotation,
  });

  final List<ArCoreNode> children;
  final String name;
  final ArCoreShape? shape;
  final ArCoreImage? image;
  final Vector3? position;
  final Vector3? scale;
  final Vector4? rotation;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'dartType': runtimeType.toString(),
        'name': name,
        'shape': shape?.toMap(),
        'image': image?.toMap(),
        'position': position != null
            ? convertVector3ToMap(position!)
            : convertVector3ToMap(Vector3.zero()),
        'scale': scale != null
            ? convertVector3ToMap(scale!)
            : convertVector3ToMap(Vector3(1.0, 1.0, 1.0)),
        'rotation': rotation != null
            ? convertVector4ToMap(rotation!)
            : convertVector4ToMap(Vector4(0.0, 0.0, 0.0, 1.0)),
        'children':
            children.map((ArCoreNode child) => child.toMap()).toList(),
      }..removeWhere((String k, dynamic v) => v == null);

  @override
  List<Object?> get props => [
        shape,
        image,
        children,
        name,
        position,
        scale,
        rotation,
      ];
}

