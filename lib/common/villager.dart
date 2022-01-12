import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:vibingtownflutter/common/pathpoint.dart';
import 'package:vibingtownflutter/common/levelcontroller.dart';

enum VillagerAnimations {
  idle,
  playingArcade,
  dancing,
  fishing,
  floating,
  singing,
  talking,
  playingVolleyball,
  walking
}

double animSpeed = 0.25;

class Villager extends SpriteAnimationGroupComponent {
  late final SpriteSheet spriteSheet;
  late SpriteAnimation anim;

  late PathPoint? from;
  late PathPoint target;

  final bool isActive;

  Villager(this.isActive, Image image, {int priority = 10, this.from})
      : super(priority: priority, anchor: Anchor.center) {
    spriteSheet =
        SpriteSheet.fromColumnsAndRows(image: image, columns: 8, rows: 3);

    size = spriteSheet.getSprite(0, 0).srcSize;

    if (!isActive) return;
    target =
        points[from!.connections[Random().nextInt(from!.connections.length)]];
  }

  @override
  Future<void>? onLoad() {
    animations = {
      VillagerAnimations.playingArcade: spriteSheet.createAnimation(
          stepTime: animSpeed, from: 0, to: 2, row: 0),
      VillagerAnimations.singing: spriteSheet.createAnimation(
          stepTime: animSpeed, from: 2, to: 4, row: 0),
      VillagerAnimations.fishing: spriteSheet.createAnimation(
          stepTime: animSpeed, from: 4, to: 6, row: 0),
      VillagerAnimations.floating: spriteSheet.createAnimation(
          stepTime: animSpeed, from: 0, to: 2, row: 1),
      VillagerAnimations.talking: spriteSheet.createAnimation(
          stepTime: animSpeed, from: 2, to: 7, row: 1),
      VillagerAnimations.idle: spriteSheet.createAnimation(
          stepTime: animSpeed, from: 0, to: 2, row: 2),
      VillagerAnimations.dancing: spriteSheet.createAnimation(
          stepTime: animSpeed, from: 2, to: 4, row: 2),
      VillagerAnimations.playingVolleyball: spriteSheet.createAnimation(
          stepTime: animSpeed, from: 4, to: 6, row: 2),
      VillagerAnimations.walking: spriteSheet.createAnimation(
          stepTime: animSpeed, from: 6, to: 8, row: 2),
    };
    current = VillagerAnimations.walking;

    if (!isActive) return super.onLoad();
    double lerpPos = Random().nextDouble();
    double? x = lerpDouble(from!.x, target.x, lerpPos);
    double? y = lerpDouble(from!.y, target.y, lerpPos);
    position = Vector2(x!, y!);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (dt > 2 || !isActive) return;

    Vector2 direction = (target.position - position).normalized();
    scale.x = -direction.x.sign;
    position += direction * dt * 20;
    if ((target.position - position).length < 1) {
      from = target;
      target = points[
          target.connections[Random().nextInt(target.connections.length)]];
    }
  }

  void setAnimation(VillagerAnimations newAnim) {
    current = newAnim;
  }
}
