import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ArCoreMaterial extends Equatable {
  const ArCoreMaterial({
    required this.color,
    this.metallic,
    this.roughness,
    this.reflectance,
    this.textureBytes,
  });

  final Color color;
  final Uint8List? textureBytes;
  final double? metallic;
  final double? roughness;
  final double? reflectance;

  @override
  List<Object?> get props => [
        color,
        metallic,
        roughness,
        reflectance,
        textureBytes,
      ];

  Map<String, dynamic> toMap() => <String, dynamic>{
        'color': {
          'r': color.red,
          'g': color.green,
          'b': color.blue,
          'a': color.alpha,
        },
        'metallic': metallic,
        'roughness': roughness,
        'reflectance': reflectance,
        'textureBytes': textureBytes,
      }..removeWhere((String k, dynamic v) => v == null);
}

