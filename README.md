# TissueBox
A mobile phone game made by Flutter.

## Dependencies
- Packages
	1. [flame](https://pub.dartlang.org/packages/flame)
	2. [shared_preferences](https://pub.dartlang.org/packages/shared_preferences)
- Font
	1. [Noto Sans](https://www.google.com/get/noto/#sans-lgc)
- Images
    1. Tissue Box - yum650350
    2. Tissue - yum650350
    3. Background - yum650350
    4. Crown - yum650350
- Audio
    1. Tissue - yum650350
    2. Tick Tock - yum650350
    3. Game Over - yum650350
    
## Build Info
```
$ flutter --version
Flutter 1.2.1 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 8661d8aecd (6 weeks ago) • 2019-02-14 19:19:53 -0800
Engine • revision 3757390fa4
Tools • Dart 2.1.2 (build 2.1.2-dev.0.0 0a7dcf17eb)
```
## Game Play
Beat the best to win the crown.
1. Drag up tissue to gain point(s).
2. If box is empty, drag it to the right/left to reload.

## Game Tips
1. Do not drag the box if it's not empry.
2. Drag the tissue up as straight as you can to get more points.

## Readable Code
The code in main.dart is simplified for Flutter Create 5kb challenge.
For those who wants to know how the code works, here is the human readable version of code.
You can simply replace it with main.dart,they are the same. 

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flame/game.dart';
import 'dart:math';

main() async {
  var util = Util();
  await util.fullScreen();
  await util.setOrientation(DeviceOrientation.portraitUp);
  const mp3 = '.mp3';
  await Flame.images.loadAll(['b', 'b0', 'b1', 'b2', 't', 'c']);
  audioLoad(c) async => (await Flame.audio.load(c)).path;
  setAudio(a, s, v) async {
    await a.setUrl(await audioLoad(s), isLocal: true);
    a.setVolume(v);
  }
  GameTable.setAudioList(GameTable.audioList1, await audioLoad('s$mp3'));
  GameTable.setAudioList(GameTable.audioList2, await audioLoad('d$mp3'));
  GameTable.setAudioList(GameTable.audioList3, await audioLoad('t$mp3'));
  await setAudio(GameTable.at, 'tk$mp3', 1.0);
  await setAudio(GameTable.aw, 'a$mp3', .5);
  var game = GameTable((await SharedPreferences.getInstance()).getInt('hs') ?? 0);
  var hDrag = HorizontalDragGestureRecognizer();
  var vDrag = VerticalDragGestureRecognizer();
  hDrag.onUpdate = game.onDragUpdate;
  hDrag.onStart = game.onDragStart;
  hDrag.onEnd = game.onDragEnd;
  vDrag.onUpdate = game.onDragUpdate;
  vDrag.onStart = game.onDragStart;
  vDrag.onEnd = game.onDragEnd;
  runApp(game.widget);
  util.addGestureRecognizer(hDrag);
  util.addGestureRecognizer(vDrag);
}

enum Drag { tissue, box, none }

class GameTable extends Game {
  static getSprite(g) => Sprite(g);
  static var at = AudioPlayer(),
      aw = AudioPlayer(),
      audioList1 = [AudioPlayer(), AudioPlayer(), AudioPlayer()],
      audioList2 = [AudioPlayer(), AudioPlayer()],
      audioList3 = [AudioPlayer(), AudioPlayer()],
      audioIndex1 = 0,
      audioIndex2 = 0,
      audioIndex3 = 0;
  static setAudioList(List<AudioPlayer> al,String audioName) => al.forEach((x) {
        x.setUrl(audioName, isLocal: true);
        x.setVolume(.2);
      });
  var background = getSprite('b'),
      crown = getSprite('c'),
      initialPoint = Offset.zero,
      destPoint = Offset.zero,
      dragState = Drag.none,
      g = false,
      o = false,
      timePass = .0,
      heighScore = 0,
      score = 0,
      l = 0;
  static getPlayIndex(a) {
    if (a == 1)
      audioIndex1 = audioIndex1 < audioList1.length - 1 ? audioIndex1 + 1 : 0;
    else if (a == 2)
      audioIndex2 = audioIndex2 < audioList2.length - 1 ? audioIndex2 + 1 : 0;
    else if (a == 3) audioIndex3 = audioIndex3 < audioList3.length - 1 ? audioIndex3 + 1 : 0;
    return a == 1 ? audioIndex1 : a == 2 ? audioIndex2 : audioIndex3;
  }

  final tru = true;
  double ts, point1;
  double get k => screenSize.width / 5 / ts;
  static get tissue1 => audioList1[getPlayIndex(1)];
  static get tissue2 => audioList2[getPlayIndex(2)];
  static get tissue3 => audioList3[getPlayIndex(3)];
  static getRect(a, b, c, d) => Rect.fromLTWH(a, b, c, d);
  Size screenSize;
  Rect rect;
  TissueBox tissueBox;
  init() async {
    resize(await Flame.util.initialDimensions());
    rect = getRect(.0, screenSize.height - ts * 23, ts * 9, ts * 23);
    tissueBox = TissueBox(this);
  }

  sh() async => await (await SharedPreferences.getInstance()).setInt('hs', heighScore);
  GameTable(this.heighScore) {
    init();
  }
  @override
  render(c) {
    tx(s, o, u, f, [b = false]) {
      var t = TextPainter(
          text: TextSpan(
              style: TextStyle(
                  color: b ? Colors.black : Colors.white,
                  fontSize: f,
                  fontFamily: 'NS'),
              text: s),
          textScaleFactor: k,
          textDirection: TextDirection.ltr);
      t.layout();
      t.paint(c, u ? TissueBox.getOffset(o.dx - t.width / 2, o.dy) : o);
    }

    background.renderRect(c, rect);
    tissueBox.render(c);
    var ct = tissueBox.il + tissueBox.boxRect.width / 2;
    if (g)
      tx(timePass.toStringAsFixed(timePass < 1 ? 1 : 0), TissueBox.getOffset(ct, tissueBox.it + tissueBox.boxRect.height + 10), tru,
          k * 10, tru);
    tx(heighScore.toString(), TissueBox.getOffset(33.0, k * 30), !tru, k * 12);
    crown.renderRect(c, getRect(28.0, k * 10, 49.2, 39.0));
    tx(score.toString(), TissueBox.getOffset(ct, k * 50), tru, k * 25);
    heighScore = score > heighScore ? score : heighScore;
  }

  @override
  update(t) {
    tissueBox.update(t);
    timePass -= g || o ? t : 0;
    if (timePass < 0 && g) {
      tissueBox.isAway = tru;
      g = !tru;
      timePass = 2;
      o = tru;
      sh();
      tissueBox.newGame();
    } else if (g && !o) {
      var v = timePass.floor();
      if (v < l && v < 6 && v != 0)
        TissueBox.delay(Duration(milliseconds: 300), () => GameTable.at.resume());
      l = v;
    }
    o = timePass <= 0 && o ? !tru : o;
  }

  resize(s) {
    screenSize = s;
    ts = screenSize.width / 9;
  }

  onDragStart(detail) {
    var p = detail.globalPosition;
    dragState = tissueBox.tissue.rect.contains(p) ? Drag.tissue : tissueBox.boxRect.contains(p) ? Drag.box : Drag.none;
    initialPoint = TissueBox.getOffset(p.dx == 0 ? initialPoint.dx : p.dx, p.dy == 0 ? initialPoint.dy : p.dy);
    point1 = (tissueBox.tissue.rect.left - p.dx).abs();
  }

  onDragUpdate(detail) {
    if (o || dragState == Drag.none) return;
    var p = detail.globalPosition;
    destPoint = TissueBox.getOffset(p.dx == 0 ? destPoint.dx : p.dx, p.dy == 0 ? destPoint.dy : p.dy);
    if (dragState == Drag.tissue) {
      if (initialPoint.dy - destPoint.dy > 100) {
        if (g != tru && o != tru) {
          g = tru;
          timePass = 10;
          score = 0;
        }
        var sub = (point1 - (tissueBox.tissue.rect.left - p.dx).abs()).abs();
        var addPoint = sub < 3 ? 3 : sub < 6 ? 2 : 1;
        dragState = Drag.none;
        tissueBox.nextTissue(addPoint);
        playTissueAudio(addPoint);
        score += addPoint;
      }
    } else if (dragState == Drag.box) {
      tissueBox.boxRect = getRect(tissueBox.il + destPoint.dx - initialPoint.dx, tissueBox.boxRect.top, TissueBox.q.dx, TissueBox.q.dy);
      tissueBox.ismoving = tru;
    }
  }

  playTissueAudio(i) => (i == 1 ? GameTable.tissue1 : i == 2 ? GameTable.tissue2 : GameTable.tissue3).resume();
  onDragEnd(detail) {
    initialPoint = Offset.zero;
    dragState = Drag.none;
    tissueBox.tissue.isMoving = !tru;
    tissueBox.ismoving = !tru;
    destPoint = initialPoint;
  }
}

class TissueBox {
  Rect get initialRect => GameTable.getRect(boxRect.center.dx - Tissue.width / 2, boxRect.top - boxRect.height + 19, Tissue.width, Tissue.width);
  Sprite get getBoxSprite => GameTable.getSprite('b' + rnd.nextInt(3).toString());
  var tissueAwayList = List<TissueAway>(), rnd = Random(), ismoving = false, isAway = false;
  Offset get u => getOffset(initialRect.left, initialRect.top - 150);
  final GameTable game;
  Sprite boxSprite;
  Rect boxRect;
  int tc;
  Tissue tissue;
  double get il => game.screenSize.width / 2 - TissueBox.q.dx / 2;
  double get it => game.screenSize.height - game.ts * 5.5;
  static var q = TissueBox.getOffset(150.0, 100.0);
  TissueBox(this.game) {
    boxRect = GameTable.getRect(il, it, q.dx, q.dy);
    tc = 10 - rnd.nextInt(5);
    tissue = Tissue(game, this);
    boxSprite = getBoxSprite;
  }
  render(Canvas c) {
    boxSprite.renderRect(c, boxRect);
    tissue.render(c);
    tissueAwayList.forEach((x) => x.render(c));
  }

  update(t) {
    tissue.update(t);
    tissueAwayList.removeWhere((x) => x.isAway);
    tissueAwayList.forEach((x) => x.update(t));
    var v = boxRect.left - il;
    if (ismoving && !game.o) {
      if (v.abs() > 50 && tc == 0) isAway = game.tru;
    } else if (isAway && !game.o) {
      boxRect = boxRect.shift(getOffset(v > 0 ? boxRect.left + game.k * 11 : boxRect.left - game.k * 11, boxRect.top));
      if (boxRect.right < -50 || boxRect.left > game.screenSize.width + 50) newBox();
    } else if (isAway && game.o) {
      var o = getOffset(boxRect.left, game.screenSize.height + Tissue.width) - getOffset(boxRect.left, boxRect.top);
      boxRect = boxRect.shift(game.k * 11 < o.distance
          ? Offset.fromDirection(o.direction, game.k * 11)
          : o);
    } else {
      var o = getOffset(il, it) - getOffset(boxRect.left, boxRect.top);
      boxRect = boxRect.shift(game.k * 11 < o.distance
          ? Offset.fromDirection(o.direction, game.k * 11)
          : o);
    }
  }

  static getOffset(x, y) => Offset(x, y);
  nextTissue(i) {
    var d = Duration(milliseconds: 100);
    tissueAwayList.add(TissueAway(game, this));
    if (i > 1)
      delay(d, () {
        tissueAwayList.add(TissueAway(game, this));
        if (i > 2)
          delay(d, () {
            tissueAwayList.add(TissueAway(game, this));
          });
      });
    tissue = Tissue(game, this, --tc == 0);
  }

  newBox() {
    boxSprite = getBoxSprite;
    boxRect = GameTable.getRect(boxRect.right < -0 ? game.screenSize.width + 50 - q.dx : -50.0, it, q.dx, q.dy);
    tc = 10 - rnd.nextInt(5);
    tissue = Tissue(game, this);
    isAway = !game.tru;
    ismoving = !game.tru;
  }

  newGame() async {
    isAway = game.tru;
    GameTable.aw.resume();
    await delay(Duration(seconds: 2), () {});
    newBox();
  }

  static delay(duration, func()) async => await Future.delayed(duration, func);
}

class Tissue {
  var tissueSprite = GameTable.getSprite('t'), isMoving = false;
  static var width = 100.0;
  final TissueBox tissueBox;
  final GameTable game;
  bool isAway;
  Rect rect;
  Tissue(this.game, this.tissueBox, [this.isAway = false]) {
    rect = tissueBox.initialRect;
  }
  render(c) => tissueSprite.renderRect(c, rect);
  update(t) => rect = isAway ? rect.shift(Offset.infinite) : tissueBox.initialRect;
}

class TissueAway extends Tissue {
  TissueAway(GameTable game, TissueBox tissueBox) : super(game, tissueBox);
  render(c) => tissueSprite.renderRect(c, rect);
  update(t) {
    var speed = 500 * t;
    Offset target = tissueBox.u - TissueBox.getOffset(rect.left, rect.top);
    if (speed < target.distance)
      rect = rect.shift(Offset.fromDirection(target.direction, speed));
    else
      isAway = game.tru;
  }
}
```
