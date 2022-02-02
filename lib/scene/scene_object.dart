import 'package:flutter/material.dart';

import '../../ui/HUD.dart';

abstract class SceneObject {
  HUD hud = HUD();

  SceneObject();

  void draw(Canvas c) {}

  void update() {}
}
