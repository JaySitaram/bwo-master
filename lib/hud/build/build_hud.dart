import 'package:flame/extensions.dart';

import '../../Entity/wall/wall.dart';

import '../../Entity/Player/Player.dart';
// import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../../game_controller.dart';
import '../../map/map_controller.dart';
import '../../ui/HUD.dart';
import '../../ui/ui_element.dart';
import '../../utils/tap_state.dart';
import 'build_tools_bar.dart';

class BuildHUD extends UIElement {
  final Player _player;
  Sprite _buildSprite;
  Sprite _buildSpriteOpen;
  Sprite _deleteSprite;

  Sprite _lowWallSprite;
  Sprite _midWallSprite;
  Sprite _fullWallSprite;
  Sprite _upstairSprite;
  Sprite _switchLevelButtonSprite;

  // Position bPos = Position.empty();
  // Position sPos = Position.empty();

  static BuildButtonState buildBtState = BuildButtonState.none;

  BuildToolsBar _buildToolsBar;

  final MapController _map;

  BuildHUD(this._player, this._map, HUD hudRef) : super(hudRef) {
    drawOnHUD = true;
    loadSprite();
    _buildToolsBar = BuildToolsBar(_player, _map, hudRef);
  }

  void loadSprite() async {
    _buildSprite = await Sprite.load("ui/hammer.png");
    _buildSpriteOpen = await Sprite.load("ui/hammer_open.png");
    _deleteSprite = await Sprite.load("ui/handsaw.png");

    _lowWallSprite = await Sprite.load("ui/low_wall.png");
    _midWallSprite = await Sprite.load("ui/mid_wall.png");
    _fullWallSprite = await Sprite.load("ui/full_wall.png");
    _upstairSprite = await Sprite.load("ui/upstair.png");

    _switchLevelButtonSprite = _midWallSprite;
  }

  void draw(Canvas c) {
    if (_buildSprite == null ||
        _buildSpriteOpen == null ||
        _deleteSprite == null) return;

    // bPos = Position(10, GameController.screenSize.height - 176);
    if (buildBtState == BuildButtonState.build) {
      _buildSpriteOpen.render(c, position:Vector2(10, GameController.screenSize.height - 176));
    } else if (buildBtState == BuildButtonState.delete) {
      _deleteSprite.render(c, position:Vector2(10, GameController.screenSize.height - 176));
    } else {
      _buildSprite.render(c, position:Vector2(10, GameController.screenSize.height - 176));
    }
    _handlerBuildButtonClick();

    if (buildBtState == BuildButtonState.build ||
        buildBtState == BuildButtonState.delete) {
      _map.buildFoundation.myFoundation?.drawBuildArea(c);
    }

    // Switch level button
    if (_map.buildFoundation.myFoundation != null) {
      // sPos = Position(10, GameController.screenSize.height - 224);
      var sRect = Rect.fromLTWH(Vector2(10, GameController.screenSize.height - 224).x, Vector2(10, GameController.screenSize.height - 224).y, 32, 32);
      if (TapState.clickedAt(sRect)) {
        _handlerWallLevelButtonClick();
      }
      _switchLevelButtonSprite?.render(c, position:Vector2(10, GameController.screenSize.height - 224));
      var isBuildingMode = buildBtState != BuildButtonState.none;
      _map.buildFoundation.myFoundation
          ?.switchWallHeightAll(isBuildingMode: isBuildingMode);
      _map.buildFoundation.myFoundation
          ?.switchDoor(isBuildingMode: isBuildingMode);
    }

    _updateWallLevelSprite();
  }

  void _handlerBuildButtonClick() {
    var bRect = Rect.fromLTWH(Vector2(10, GameController.screenSize.height - 176).x, Vector2(10, GameController.screenSize.height - 176).y, 32, 32);
    if (TapState.clickedAt(bRect)) {
      if (buildBtState == BuildButtonState.none) {
        _buildToolsBar.setActive(true);
        buildBtState = BuildButtonState.build;
        _player.canWalk = false;
      } else {
        //finish building
        buildBtState = BuildButtonState.none;
        _player.canWalk = true;
        _buildToolsBar.setActive(false);
        _map.buildFoundation.myFoundation?.save();
      }
    }
  }

  void _handlerWallLevelButtonClick() {
    if (_map.buildFoundation.myFoundation != null) {
      var foundation = _map.buildFoundation.myFoundation;

      if (foundation.showWallLevel == WallLevel.mid) {
        foundation.showWallLevel = WallLevel.hight;
      } else if (foundation.showWallLevel == WallLevel.hight) {
        foundation.showWallLevel = WallLevel.upstair;
      } else if (foundation.showWallLevel == WallLevel.upstair) {
        foundation.showWallLevel = WallLevel.low;
      } else if (foundation.showWallLevel == WallLevel.low) {
        foundation.showWallLevel = WallLevel.mid;
      }
    }
  }

  void _updateWallLevelSprite() {
    if (_map.buildFoundation.myFoundation != null) {
      var wallLevel = _map.buildFoundation.myFoundation.showWallLevel;

      if (wallLevel == WallLevel.mid) {
        _switchLevelButtonSprite = _midWallSprite;
      } else if (wallLevel == WallLevel.hight) {
        _switchLevelButtonSprite = _fullWallSprite;
      } else if (wallLevel == WallLevel.upstair) {
        _switchLevelButtonSprite = _upstairSprite;
      } else if (wallLevel == WallLevel.low) {
        _switchLevelButtonSprite = _lowWallSprite;
      }
    }
  }
}

enum BuildButtonState {
  none,
  build,
  delete,
}
