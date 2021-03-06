// import 'package:flame/anchor.dart';
// import 'package:flame/position.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';
import 'package:flame/sprite.dart';
// import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

import '../../ui/HUD.dart';
import '../../ui/ui_element.dart';
import '../../utils/preload_assets.dart';
import '../../utils/tap_state.dart';

class ToolItem extends UIElement {
  final Paint _p = Paint();
  String spriteName;
  Sprite sprite;
  Offset pos = Offset.zero;

  TextComponent _text;

  Function(ToolItem) callback;

  bool isSelected = false;
  Offset size = Offset.zero;
  String name;

  ToolItem(this.spriteName, this.name, HUD hudRef, this.callback,
      {bool isBtSelected = false, this.size = Offset.zero})
      : super(hudRef) {
    isSelected = isBtSelected;
    _text = TextComponent(
    fontSize: 12.0,
    color: Color.fromRGBO(62, 44, 40, 1),
    fontFamily: "Blocktopia");
    loadSprite();
  }

  void loadSprite() async {
    sprite = PreloadAssets.getUiSprite(spriteName);
  }

  void draw(Canvas c) {
    if (sprite == null) return;

    bounds = Rect.fromLTWH(pos.dx - 16, pos.dy - 16, 32, 32);

    if (isSelected) {
      _p.color = Color.fromRGBO(127, 101, 66, .8);
    } else {
      _p.color = Color.fromRGBO(212, 189, 135, 1);
    }

    c.drawCircle(pos, 25, _p);
    sprite.render(c, position:Vector2(pos.dx - 16, pos.dy - 16));

    _text.render(
        c, name, Vector2(bounds.bottomCenter.dx, bounds.bottomCenter.dy + 24),
        anchor: Anchor.bottomCenter);

    checkPress();
  }

  void checkPress() {
    if (TapState.clickedAt(bounds) && callback != null) {
      callback(this);
    }
  }
}
