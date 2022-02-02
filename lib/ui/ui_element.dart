import 'package:flutter/material.dart';

import 'HUD.dart';


abstract class UIElement {
  Rect bounds = Rect.zero;
  HUD hudRef;
  bool drawOnHUD = false;

  UIElement(this.hudRef) {
    hudRef.addElement(this);
  }
  void draw(Canvas c) {}
}
