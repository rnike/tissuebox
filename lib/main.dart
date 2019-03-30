import 'dart:math';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/flame.dart';
import 'package:shared_preferences/shared_preferences.dart';

main()async{
 var u=Util();
 await u.fullScreen();
 await u.setOrientation(DeviceOrientation.portraitUp);
 Flame.images.loadAll(['bg/bg1.jpg','tb/tb1.png','ts/ts1.png']);
 Flame.audio.loadAll(['ts1.mp3']);
 var g=GameTable(((await SharedPreferences.getInstance()).getInt('hs')??0));
 var h=HorizontalDragGestureRecognizer();
 var v=VerticalDragGestureRecognizer();
 h.onUpdate=g.onDragUpdate;
 v.onUpdate=g.onDragUpdate;
 h.onStart=g.onDragStart;
 v.onStart=g.onDragStart;
 h.onEnd=g.onDragEnd;
 v.onEnd=g.onDragEnd;
 runApp(g.widget);
 u.addGestureRecognizer(h);
 u.addGestureRecognizer(v);
}
enum Dg{tissue,box,none}
class GameTable extends Game{
 var bg=Sprite('bg/bg1.jpg');
 Rect r;
 var ing=false;
 double ts;
 Size sS;
 double sx;
 int hs=0;
 var ip=Offset(0,0);
 var dp=Offset(0,0);
 int sc=0;
 TisBox tB;
 Dg ste=Dg.none;
 int tm=0;
 var pa=0.0;
 var ov=false;
 int tt=0;
 init()async{ 
  resize(await Flame.util.initialDimensions());
  tB=TisBox(this);
  r=Rect.fromLTWH(0,sS.height-ts*23,ts*9,ts*23);
 }
 savehs()async{
  var pf=await SharedPreferences.getInstance(); 
  await pf.setInt('hs',hs);
 }
 GameTable(this.hs){init();}
 @override
 render(c){
  tpaint(s,o){
   var tp=TextPainter(text:TextSpan(style:TextStyle(color:Colors.black,fontSize:18),text:s),textDirection:TextDirection.ltr);
   tp.layout();
   tp.paint(c,Offset(o.dx-tp.width/2,o.dy));
  }
  bg.renderRect(c,r);
  tB.render(c);
  var ct=tB.il+tB.r.width/2;
  if(ing)tpaint(pa.toStringAsFixed(pa<1?1:0),Offset(ct,tB.it+tB.r.height+10));
  tpaint(sc.toString(),Offset(ct,100));
  hs=sc>hs?sc:hs;
  tpaint(hs.toString(),Offset(ct,50));
 }
 @override
 update(t){
  tB.update(t);
  pa-=ing||ov?t:0;
  if(pa<=0&&ing){
   pa=2;
   ing=false;
   ov=true;
   tB.aw=true;
   savehs();
   tB.newGame();
  }else if(ing&&!ov){
   var v=pa.floor();
   if(v<tt&&v<6)Flame.audio.play('tick.mp3');
   tt=v;
  }
  ov=pa<=0&&ov?false:ov;
 }
 resize(s){
  sS=s;
  ts=sS.width/9;
 }
 onDragStart(d){
  var gp=d.globalPosition;
  ste=tB.tis.r.contains(gp)?Dg.tissue:tB.r.contains(gp)?Dg.box:Dg.none;
  ip=Offset(gp.dx==0?ip.dx:gp.dx,gp.dy==0?ip.dy:gp.dy);
  sx=(tB.tis.r.left-gp.dx).abs();
 }
 onDragUpdate(d){
  if(ov||ste==Dg.none)return;
  var gp=d.globalPosition;
  dp=Offset(gp.dx==0?dp.dx:gp.dx,gp.dy==0?dp.dy:gp.dy);
  if(ste==Dg.tissue){
   if(ing==false&&ov==false){
    pa=10;
    sc=0;
    ing=true;
   }
   if(ip.dy-dp.dy>100){
    var st=(sx-(tB.tis.r.left-gp.dx).abs()).abs();
    var sa=st<3?3:st<6?2:1;
    Flame.audio.play('ts1.mp3',volume:0.1);
    sc+=sa;
    tB.nextTissue(sa);
    ste=Dg.none;
   }
  }else if(ste==Dg.box&&ing!=false){
   tB.mo=true;
   tB.r=Rect.fromLTWH(tB.il+dp.dx-ip.dx,tB.r.top,TisBox.w,TisBox.h);
  }
 }
 onDragEnd(details){
  ip=Offset(0,0);
  dp=ip;
  ste=Dg.none;
  tB.mo=false;
  tB.tis.mov=false;
 }
}
class TisBox{
 Rect get trt=>Rect.fromLTWH(r.center.dx-Tis.wh/2,r.top-r.height+10,Tis.wh,Tis.ht);
 Offset get tu=>Offset(trt.left,trt.top-200);
 var tr=List<TisAway>();
 static var w=150.0;
 static var h=100.0;
 final GameTable g;
 var rn=Random();
 var mo=false;
 var aw=false;
 double il;
 double it;
 Sprite bs;
 Tis tis;
 Rect r;
 int tc;
 render(c){
  bs.renderRect(c,r);
  tis.render(c);
  tr.forEach((x)=>x.render(c));
 }
 nextTissue(sa){
  tr.add(TisAway(g,this));
  tis=Tis(g,this,--tc==0);
 }
 nextBox(){
  r=Rect.fromLTWH((r.right<-50)?g.sS.width+50:-50,r.top,TisBox.w,TisBox.h);
  tc=10-rn.nextInt(5);
  tis=Tis(g,this);
  aw=false;
  mo=false;
 } 
 newGame()async{
  aw=true;
  await Future.delayed(Duration(milliseconds:2000));
  nextBox();
 }
 TisBox(this.g){
  bs=Sprite('tb/tb1.png');
  tc=10-rn.nextInt(5);
  il=g.sS.width/2-TisBox.w/2;
  it=g.sS.height-g.ts*5.5;
  r=Rect.fromLTWH(il,it,TisBox.w,TisBox.h);
  tis=Tis(g,this);
 }
 update(t){
  tis.update(t);
  tr.forEach((x)=>x.update(t));
  tr.removeWhere((x)=>x.aw);
  var v=(r.left-il);
  if(mo&&!g.ov){
   if(v.abs()>50&&tc==0)aw=true;
  }else if(aw&&!g.ov){
   r=r.shift(Offset(v>0?r.left+20:r.left-20,r.top));
   //r=Rect.fromLTWH(v>0?r.left+20:r.left-20,r.top,TisBox.w,TisBox.h);
   if((r.right<-50||r.left>g.sS.width+50))nextBox();
  }else if(aw&&g.ov){
   if(r.top-Tis.ht<g.sS.height)r=Rect.fromLTWH(r.left,r.top+20,TisBox.w,TisBox.h); 
  }else r=Rect.fromLTWH(v.abs()<10?il:r.left>il?r.left-20:r.left+20,it,TisBox.w,TisBox.h);
 }
} 
class Tis{
 var spr=Sprite('ts/ts1.png');
 static var ht=100.0;
 static var wh=100.0;
 final GameTable g;
 var mov=false;
 final TisBox bx;
 bool aw;
 Rect r;
 Tis(this.g,this.bx,[this.aw=false]){r=bx.trt;}
 render(c)=>spr.renderRect(c,r);
 update(t)=>r=aw?r.shift(Offset(-500,-500)):bx.trt;
} 
class TisAway extends Tis{
 TisAway(GameTable g,TisBox bx):super(g,bx);
 render(c)=>spr.renderRect(c,r);
 update(t){
  var sd=500*t;
  Offset tg=bx.tu-Offset(r.left,r.top);
  if(sd<tg.distance)r=r.shift(Offset.fromDirection(tg.direction,sd));
  else aw=true;
 }
}