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
 Flame.audio.loadAll(['ts1.mp3','ts2.mp3','ts3.mp3','boxaway.mp3']);
 var g=G(((await SharedPreferences.getInstance()).getInt('hs')??0));
 var h=HorizontalDragGestureRecognizer();
 var v=VerticalDragGestureRecognizer();
 h.onUpdate=g.du;
 v.onUpdate=g.du;
 h.onStart=g.ds;
 v.onStart=g.ds;
 h.onEnd=g.de;
 v.onEnd=g.de;
 runApp(g.widget);
 u.addGestureRecognizer(h);
 u.addGestureRecognizer(v);
}
enum Dg{tissue,box,none}
class G extends Game{
 var bg=Sprite('bg/bg1.jpg');
 var ip=Offset(0,0);
 var dp=Offset(0,0);
 Dg m=Dg.none;
 var og=false;
 var ov=false;
 var pa=0.0;
 double ts;
 double sx;
 TB tB;
 int h=0;
 int s=0;
 int n=0;
 int l=0;
 Size sS;
 Rect r;
 init()async{
  resize(await Flame.util.initialDimensions());
  tB=TB(this);
  r=Rect.fromLTWH(0,sS.height-ts*23,ts*9,ts*23);
 }
 sh()async=>await(await SharedPreferences.getInstance()).setInt('hs',h); 
 G(this.h){init();}
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
  if(og)tpaint(pa.toStringAsFixed(pa<1?1:0),Offset(ct,tB.it+tB.r.height+10));
  tpaint(s.toString(),Offset(ct,100));
  h=s>h?s:h;
  tpaint(h.toString(),Offset(ct,50));
 }
 @override
 update(t){
  tB.update(t);
  pa-=og||ov?t:0;
  if(pa<=0&&og){
   tB.aw=true;
   og=false;
   ov=true;
   pa=2;
   sh();
   tB.nG();
  }else if(og&&!ov){
   var v=pa.floor();
   if(v<l&&v<6&&v!=0)Flame.audio.play('tick.mp3',volume:0.3);
   l=v;
  }
  ov=pa<=0&&ov?false:ov;
 }
 resize(s){
  sS=s;
  ts=sS.width/9;
 }
 ds(d){
  var p=d.globalPosition;
  m=tB.ti.r.contains(p)?Dg.tissue:tB.r.contains(p)?Dg.box:Dg.none;
  ip=Offset(p.dx==0?ip.dx:p.dx,p.dy==0?ip.dy:p.dy);
  sx=(tB.ti.r.left-p.dx).abs();
 }
 du(d){
  if(ov||m==Dg.none)return;
  var p=d.globalPosition;
  dp=Offset(p.dx==0?dp.dx:p.dx,p.dy==0?dp.dy:p.dy);
  if(m==Dg.tissue){
   if(ip.dy-dp.dy>100){
   if(og==false&&ov==false){
    pa=10;
    s=0;
    og=true;
   }
    var st=(sx-(tB.ti.r.left-p.dx).abs()).abs();
    var sa=st<3?3:st<6?2:1;
    t(sa);
    s+=sa;
    tB.nT(sa);
    m=Dg.none;
   }
  }else if(m==Dg.box&&og!=false){
   tB.mo=true;
   tB.r=Rect.fromLTWH(tB.il+dp.dx-ip.dx,tB.r.top,TB.w,TB.h);
  }
 }
 t(i)=>Flame.audio.play('ts$i.mp3',volume:0.2);
 de(details){
  ip=Offset(0,0);
  dp=ip;
  m=Dg.none;
  tB.mo=false;
  tB.ti.mov=false;
 }
}
class TB{
 Rect get ir=>Rect.fromLTWH(r.center.dx-T.wh/2,r.top-r.height+10,T.wh,T.ht);
 Offset get tu=>Offset(ir.left,ir.top-200);
 double get il=>g.sS.width/2-TB.w/2;
 double get it=>g.sS.height-g.ts*5.5;
 var tr=List<TA>();
 static var w=150.0;
 static var h=100.0;
 var rn=Random();
 var mo=false;
 var aw=false;
 final G g;
 Sprite b;
 T ti;
 Rect r;
 int tc;
 TB(this.g){
  r=Rect.fromLTWH(il,it,TB.w,TB.h);
  b=Sprite('tb/tb1.png');
  tc=10-rn.nextInt(5);
  ti=T(g,this);
 }
 render(c){
  b.renderRect(c,r);
  ti.render(c);
  tr.forEach((x)=>x.render(c));
 }
 update(t){
  ti.update(t);
  tr.removeWhere((x)=>x.a);
  tr.forEach((x)=>x.update(t));
  var v=(r.left-il);
  if(mo&&!g.ov){
   if(v.abs()>50&&tc==0)aw=true;
  }else if(aw&&!g.ov){
   r=r.shift(Offset(v>0?r.left+20:r.left-20,r.top));
   if((r.right<-50||r.left>g.sS.width+50))nB();
  }else if(aw&&g.ov){
   var o=Offset(r.left,g.sS.height+T.ht)-Offset(r.left,r.top);
   r=r.shift((20<o.distance)?Offset.fromDirection(o.direction,20):o);
  }else{
   var o=Offset(il,it)-Offset(r.left,r.top);
   r=r.shift((20<o.distance)?Offset.fromDirection(o.direction,20):o);
  }
 }
 nT(i){
  var d=Duration(milliseconds: 100);
  tr.add(TA(g,this));
  if(i>1)Future.delayed(d,(){tr.add(TA(g,this));
  if(i>2)Future.delayed(d,(){tr.add(TA(g,this));});});
  ti=T(g,this,--tc==0);
 }
 nB(){
  r=Rect.fromLTWH((r.right<-50)?g.sS.width+50:-50,it,TB.w,TB.h);
  tc=10-rn.nextInt(5);
  ti=T(g,this);
  aw=false;
  mo=false;
 }
 nG()async{
  aw=true;
  Flame.audio.play('boxaway.mp3',volume:0.3);
  await Future.delayed(Duration(milliseconds:2000));
  nB();
 }
} 
class T{
 var sp=Sprite('ts/ts1.png');
 static var ht=100.0;
 static var wh=100.0;
 final G g;
 var mov=false;
 final TB bx;
 bool a;
 Rect r;
 T(this.g,this.bx,[this.a=false]){r=bx.ir;}
 render(c)=>sp.renderRect(c,r);
 update(t)=>r=a?r.shift(Offset(-500,-500)):bx.ir;
} 
class TA extends T{
 TA(G g,TB bx):super(g,bx);
 render(c)=>sp.renderRect(c,r);
 update(t){
  var s=500*t;
  Offset o=bx.tu-Offset(r.left,r.top);
  if(s<o.distance)r=r.shift(Offset.fromDirection(o.direction,s));else a=true;
 }
}