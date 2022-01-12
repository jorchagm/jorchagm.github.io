import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class BasicAnimationsExample extends FlameGame with TapDetector {
  late Image creature;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    creature = await images.load('creature.png');

    final animation = await loadSpriteAnimation(
      'chopper.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(48),
        stepTime: 0.15,
      ),
    );

    final spriteSize = Vector2.all(100.0);
    final animationComponent = SpriteAnimationComponent(
      animation: animation,
      size: spriteSize,
      priority: 10,
    );
    animationComponent.x = size.x / 2 - spriteSize.x;
    animationComponent.y = spriteSize.y;

    final reversedAnimationComponent = SpriteAnimationComponent(
      animation: animation.reversed(),
      size: spriteSize,
      priority: -10,
    );
    reversedAnimationComponent.x = size.x / 2;
    reversedAnimationComponent.y = spriteSize.y;

    add(animationComponent);
    add(reversedAnimationComponent);
    //add(Ember()..position = size / 2);
  }

  void addAnimation(Vector2 position) {
    final size = Vector2(291, 178);

    final animationComponent = SpriteAnimationComponent.fromFrameData(
      creature,
      SpriteAnimationData.sequenced(
        amount: 18,
        amountPerRow: 10,
        textureSize: size,
        stepTime: 0.15,
        loop: false,
      ),
      size: size,
      removeOnFinish: true,
      priority: 0,
    );

    animationComponent.position = position - size / 2;
    add(animationComponent);
  }

  @override
  void onTapDown(TapDownInfo info) {
    addAnimation(info.eventPosition.game);
  }
}