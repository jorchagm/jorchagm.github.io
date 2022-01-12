import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:vibingtownflutter/common/levelcontroller.dart';

enum ButtonState { unpressed, pressed, hover }

class Building extends SpriteGroupComponent<ButtonState>
    with Tappable, Hoverable {
  final Sprite pressedSprite;
  final Sprite unpressedSprite;
  final Sprite hoverSprite;
  late final SpriteComponent speechBubble;
  double alpha = 0;
  double targetAlpha = 0;

  Building(this.pressedSprite, this.unpressedSprite, this.hoverSprite,
      this.speechBubble, Vector2 position)
      : super(position: position, priority: 5, anchor: Anchor.center) {
    sprites = {
      ButtonState.pressed: pressedSprite,
      ButtonState.unpressed: unpressedSprite,
      ButtonState.hover: hoverSprite,
    };

    current = ButtonState.unpressed;
    size = sprite!.srcSize;
  }

  @override
  void update(double dt) {
    super.update(dt);

    alpha = lerpDouble(alpha, targetAlpha, 0.2)!;
    speechBubble.paint.color = Color.fromRGBO(255, 255, 255, alpha);

    if (!sensorActive || isHovered) return;
    if ((cameraPos - position + Vector2(0, 20)).length < 60) {
      current = ButtonState.hover;
      targetAlpha = 1;
      size = sprite!.srcSize;
    } else {
      current = ButtonState.unpressed;
      targetAlpha = 0;
      size = sprite!.srcSize;
    }
  }

  @override
  bool onHoverEnter(PointerHoverInfo info) {
    current = ButtonState.hover;
    size = sprite!.srcSize;
    targetAlpha = 1;
    return false;
  }

  @override
  bool onHoverLeave(PointerHoverInfo info) {
    current = ButtonState.unpressed;
    size = sprite!.srcSize;
    targetAlpha = 0;
    return false;
  }

  @override
  bool onTapDown(_) {
    current = ButtonState.pressed;
    size = sprite!.srcSize;
    return false;
  }

  @override
  bool onTapUp(_) {
    current = ButtonState.unpressed;
    size = sprite!.srcSize;
    return false;
  }
}
