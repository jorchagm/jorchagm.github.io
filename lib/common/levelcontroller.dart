import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:flutter/cupertino.dart';
import 'package:vibingtownflutter/common/animateddecoration.dart';
import 'package:vibingtownflutter/common/building.dart';
import 'package:vibingtownflutter/common/background.dart';
import 'package:vibingtownflutter/common/cameracontroller.dart';
import 'package:vibingtownflutter/common/mapdecoration.dart';
import 'package:vibingtownflutter/common/villager.dart';
import 'package:vibingtownflutter/common/pathpoint.dart';

late Vector2 mapSize;
late Vector2 cameraPos;

List<PathPoint> points = List.empty(growable: true);
var pathPoints = [
  [
    Vector2(-115, -22),
    [1, 2]
  ],
  [
    Vector2(-75, -22),
    [0, 5, 6]
  ],
  [
    Vector2(-115, 100),
    [0, 3]
  ],
  [
    Vector2(230, 100),
    [2, 4]
  ],
  [
    Vector2(260, 150),
    [3]
  ],
  [
    Vector2(-60, 8),
    [1, 8]
  ],
  [
    Vector2(-60, -60),
    [1, 7]
  ],
  [
    Vector2(34, -60),
    [6, 8]
  ],
  [
    Vector2(34, 8),
    [5, 7]
  ],
];

var interactionPoints = [
  //Docks
  [
    [
      [Vector2(360, 228), VillagerAnimations.fishing, 25, 1],
      [Vector2(148, 260), VillagerAnimations.fishing, 25, 1],
    ],
  ],
  //Museum
  [
    [
      [Vector2(-166, -137), VillagerAnimations.talking, 25, 1],
      [Vector2(-188, -137), VillagerAnimations.talking, 25, -1],
    ],
  ],
  //Library
  [
    [
      [Vector2(-8, -148), VillagerAnimations.talking, 25, 1],
      [Vector2(-28, -148), VillagerAnimations.talking, 25, -1],
    ],
  ],
  //Shrine
  [
    [
      [Vector2(264, -124), VillagerAnimations.idle, 25, 1],
      [Vector2(200, -148), VillagerAnimations.idle, 25, -1],
    ],
  ],
  //Bank
  [
    [
      [Vector2(-166, -12), VillagerAnimations.talking, 25, 1],
      [Vector2(-188, -12), VillagerAnimations.talking, 25, -1],
    ],
  ],
  //Bazaar
  [
    [
      [Vector2(54, -22), VillagerAnimations.talking, 25, -1],
      [Vector2(82, -18), VillagerAnimations.talking, 25, 1],
    ],
  ],
  //Plaza
  [
    [
      [Vector2(-17, -68), VillagerAnimations.singing, 25, 1],
      [Vector2(-34, -32), VillagerAnimations.dancing, 25, -1],
      [Vector2(1, -32), VillagerAnimations.dancing, 25, 1],
    ],
  ],
  //Carnival
  [
    [
      [Vector2(294, 135), VillagerAnimations.playingArcade, 15, -1],
      [Vector2(320, 135), VillagerAnimations.playingArcade, 15, 1],
    ],
  ],
  //Beach
  [
    [
      [Vector2(-50, 320), VillagerAnimations.floating, 25, -1],
      [Vector2(-180, 280), VillagerAnimations.floating, 25, 1],
    ],
  ],
];

var buildings = [
  ["bank", Vector2(-216, -56)],
  ["museum", Vector2(-215, -193.5960591133005)],
  ["ferrisWheel", Vector2(289, 43.5)],
  ["bazaar", Vector2(84.60591133004925, -54)],
  ["shrine", Vector2(241, -183.25123152709358)],
  ["library", Vector2(16.625615763546797, -191)],
];

var villagerSpritesheets = [
  'hamster.png',
  'owl.png',
  'baby_monkette.png',
  'doggo.png',
  'cat.png',
  'fokiballena.png',
  'fox.png',
  'frog.png',
  'ninfa.png'
];

var decorations = [
  ["carnivalStandGreen", Vector2(216.5, 128), 20],
  ["banners", Vector2(246, 159), 20],
  ["flowerBedBig", Vector2(-27, 116.5), 20],
  ["flowerBedBig", Vector2(69, 116.5), 20],
  ["umbrellaRed", Vector2(-83, 175.5), 20],
  ["umbrellaPurple", Vector2(-195, 193.5), 20],
  ["umbrellaGreen", Vector2(-295, 180.5), 20],
  ["stairs", Vector2(181.3, 194), 0],
  ["mushroom", Vector2(156, -218), 25],
];

var animatedDecorations = [
  ["Fountain.png", Vector2(-54, -66), 2, 3, 0],
  ["BeachBird.png", Vector2(-106, 270), 1, 4, 0],
  ["CarnivalBird1.png", Vector2(-27, 66), 3, 6, 1],
  ["CarnivalBird2.png", Vector2(43, 58), 3, 6, 1],
  ["Dock.png", Vector2(139.5, 207), 2, 2, 0],
  ["GreenLifeSaver.png", Vector2(-273.5, 256), 2, 2, 0],
  ["LibraryBird.png", Vector2(-25, -214), 4, 6, 0],
  ["Monolith.png", Vector2(120, -265), 4, 5, 0],
  ["Pond.png", Vector2(280, -137), 2, 3, 0],
  ["RedLifeSaver.png", Vector2(-23, 265), 2, 2, 0],
  ["SandCastle.png", Vector2(-266.5, 198), 3, 6, 1],
  ["Stereo.png", Vector2(63, 127), 2, 5, 0],
  ["TreesBird1.png", Vector2(-345.5, -209), 3, 6, 2],
  ["TreesBird2.png", Vector2(-299.5, -247), 3, 6, 0],
  ["TreesBird3.png", Vector2(-259, -228), 3, 6, 1],
  ["WestHousesBird.png", Vector2(-163, 31), 3, 6, 1],
];

/*
var decorationSprites = [
  "cooler",
  "bench",
  "arcade",
  "star",
  "lampost",
  "flowerBigBlue",
  "flowerBigPink",
  "flowerStem",
  "flowerSmallBlue",
  "flowerSmallRed",
  "flowerLavenderYellow",
  "flowerDaisy",
  "mushroom",
  "flowerBedBig",
  "flowerBedSmall",
  "beachTowelBlue",
  "beachTowelRed",
  "stairs",
  "beachChair",
  "rockBig",
  "rockSmall",
  "treeStump",
  "grass",
  "fenceSmall",
  "banners",
  "house0",
  "house1",
  "tree0",
  "tree1",
  "tree2",
  "tree3",
  "beachVolleyballCourt",
  "carnivalStandRed",
  "carnivalStandGreen",
  "umbrellaPurple",
  "umbrellaRed",
  "umbrellaGreen",
  "foundation0",
  "foundation1",
  "foundation2",
  "ground",
  "fencesBig",
  "egg",
  "stone"
];*/

late bool sensorActive = true;

class LevelController extends FlameGame
    with HasTappables, HasHoverables, HasDraggables {
  late CameraController cameraController;
  @override
  Future<void>? onLoad() async {
    super.onLoad();
    double scale = size.y * 2 / 900;
    cameraPos = camera.position + (size / 2);
    camera.zoom *= scale * 1.5;
    sensorActive = size.x < size.y;

    scale = 1;
    mapSize = Vector2(1150, 900);

    add(Background(size / 2));
    add(cameraController = CameraController(
        (-mapSize / 2) + size / 2, (mapSize / 2) - (size / 2), camera, scale));

    Sprite circleSprite = await loadSprite("circle.png");
    for (int i = 0; i < pathPoints.length; i++) {
      PathPoint pathPoint = PathPoint(
          (pathPoints[i][0] as Vector2) + (size / 2),
          circleSprite,
          pathPoints[i][1] as List<int>);
      points.add(pathPoint);
      add(pathPoint);
    }

    for (int i = 0; i < villagerSpritesheets.length; i++) {
      Sprite spr = await loadSprite(villagerSpritesheets[i].toString());
      PathPoint point = points[Random().nextInt(points.length)];
      add(Villager(true, spr.image, from: point)..position = point.position);
    }

    Random random = Random();
    List<int> unusedIndexes = List.empty(growable: true);
    for (int i = 0; i < interactionPoints.length; i++) {
      unusedIndexes.add(i);
    }

    int activeInteractionPoints =
        min(interactionPoints.length, 5 + random.nextInt(7));
    for (int i = 0; i < activeInteractionPoints; i++) {
      int n = random.nextInt(unusedIndexes.length);
      int areaIndex = unusedIndexes[n];
      unusedIndexes.removeAt(n);

      var array = interactionPoints[areaIndex]
          [random.nextInt(interactionPoints[areaIndex].length)];

      for (int j = 0; j < array.length; j++) {
        Sprite spr = await loadSprite(
            villagerSpritesheets[random.nextInt(villagerSpritesheets.length)]
                .toString());

        Villager v = Villager(false, spr.image, priority: array[j][2] as int)
          ..position = (array[j][0] as Vector2) + size / 2
          ..scale = Vector2(array[j][3] as double, 1);
        add(v)
            .then((value) => v.setAnimation(array[j][1] as VillagerAnimations));
      }
    }

    Sprite speechBubbleSprite = await loadSprite('DialogBubble_half.png');
    FireAtlas mapAtlas = await loadFireAtlas("vibingtown.fa");
    for (int i = 0; i < buildings.length; i++) {
      final Sprite pressedSprite =
          mapAtlas.getSprite(buildings[i][0].toString() + "Selected");
      final Sprite unpressedSprite =
          mapAtlas.getSprite(buildings[i][0].toString());
      final Sprite hoverSprite =
          mapAtlas.getSprite(buildings[i][0].toString() + "Outline");

      final Vector2 pos = (buildings[i][1] as Vector2) + (size / 2);
      SpriteComponent speechBubble = SpriteComponent(
        sprite: speechBubbleSprite,
        position: pos + Vector2(0, -30),
        size: speechBubbleSprite.srcSize,
        anchor: Anchor.bottomCenter,
        paint: Paint()..color = const Color.fromRGBO(255, 255, 255, 0),
        priority: 50,
      );
      add(speechBubble);
      add(Building(
          pressedSprite, unpressedSprite, hoverSprite, speechBubble, pos));
    }

    for (int i = 0; i < decorations.length; i++) {
      Sprite sprite = mapAtlas.getSprite(decorations[i][0].toString());
      Vector2 pos = (decorations[i][1] as Vector2) + size / 2;

      add(DecorationObject(
          pos, sprite.srcSize, sprite, decorations[i][2] as int));
    }

    for (int i = 0; i < animatedDecorations.length; i++) {
      int rows = animatedDecorations[i][2] as int;
      int columns = animatedDecorations[i][3] as int;
      Sprite sprite = await loadSprite(animatedDecorations[i][0].toString());
      SpriteSheet spriteSheet = SpriteSheet.fromColumnsAndRows(
          image: sprite.image, columns: columns, rows: rows);
      Vector2 pos = (animatedDecorations[i][1] as Vector2) + size / 2;

      List<Sprite> sprites = List.empty(growable: true);
      int spriteCount = rows * columns;
      for (int j = 0; j < rows; j++) {
        for (int k = 0; k < columns; k++) {
          int spritesLeft = spriteCount - (j * columns) - k;

          if (spritesLeft > (animatedDecorations[i][4] as int)) {
            sprites.add(spriteSheet.getSprite(j, k));
          }
        }
      }

      add(AnimatedDecoration(
          SpriteAnimation.spriteList(sprites, stepTime: 0.1, loop: true), pos));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    cameraPos = camera.position + (size / 2);
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    cameraController.onTapDown(info);
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo details) {
    super.onDragUpdate(pointerId, details);
    cameraController.onDragUpdate(details);
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo details) {
    super.onDragEnd(pointerId, details);
    cameraController.onDragEnd(details);
  }
}
