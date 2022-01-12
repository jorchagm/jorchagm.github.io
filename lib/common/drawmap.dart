import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/layers.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:vibingtownflutter/common/levelcontroller.dart';

Vector2 wSize = Vector2(0, 0);

class DrawMap extends FlameGame {
  late Layer gameLayer;
  late Layer backgroundLayer;
  late final SpriteAnimation birdAnimation;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final backgroundSprite = Sprite(await images.load('VibingVillage.png'));
    final bird = SpriteSheet(
        image: await images.load('BeachBird.png'),
        srcSize: Vector2(16.0, 16.0));

    birdAnimation = bird.createAnimation(row: 0, stepTime: 0.2);

    gameLayer = GameLayer(birdAnimation);
    backgroundLayer = BackgroundLayer(backgroundSprite);
  }

  @override
  void update(double dt) {
    super.update(dt);
    birdAnimation.update(dt);
    wSize = Vector2(size.x, size.y);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    backgroundLayer.render(canvas);
    gameLayer.render(canvas);
  }

  @override
  Color backgroundColor() => const Color(0xFF000000);
}

class GameLayer extends DynamicLayer {
  SpriteAnimation birdAnimation;

  GameLayer(this.birdAnimation);

  @override
  void drawLayer() {
    canvas.save();

    Paint paint = Paint();
    paint.filterQuality = FilterQuality.none;
    paint.isAntiAlias = false;

    birdAnimation.getSprite().render(
          canvas,
          position: Vector2((wSize.x / 2) - 50 / 2, (wSize.y / 2) - 50 / 2),
          size: Vector2(50.0, 50.0),
          overridePaint: paint,
        );
    canvas.restore();
  }
}

class BackgroundLayer extends DynamicLayer {
  final Sprite sprite;

  BackgroundLayer(this.sprite);

  @override
  void drawLayer() {
    sprite.render(
      canvas,
      position: Vector2(
          (wSize.x / 2) - 2304 / 2,
          (wSize.y / 2) -
              1800 /
                  2), //position: Vector2((wSize.x / 2) - (1150) / 2, (wSize.y / 2)  - 900 / 2), //position: Vector2((wSize.x / 2) - (1500 * 1.27777778) / 2, (wSize.y / 2)  - 1500 / 2),
      size: Vector2(2304,
          1800), //size: Vector2(1150, 900), //size: Vector2(1500 * 1.27777778, 1500),
    );
  }
}
