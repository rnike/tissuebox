import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flame/game.dart';
import 'dart:math';
main()async{
 var u=Util();
 await u.fullScreen();
 await u.setOrientation(DeviceOrientation.portraitUp);
 Flame.audio.loadAll(['t1','t2','t3','a','tk']);
 Flame.images.loadAll(['bg1','b0','b1','b2','t1','c']);
 var g=G((await SharedPreferences.getInstance()).getInt('hs')??0);
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
 double get k=>sS.width/5/ts;
 var bg=Sprite('bg1');
 var cr=Sprite('c');
 var ip=Offset.zero;
 var dp=Offset.zero;
 Dg m=Dg.none;
 final e=true;
 var g=false;
 var o=false;
 var u=0.0;
 double ts;
 double sx;
 int h=0;
 int s=0;
 int l=0;
 Size sS;
 Rect r;
 B b;
 init()async{
  resize(await Flame.util.initialDimensions());
  r=Rect.fromLTWH(0,sS.height-ts*23,ts*9,ts*23);
  b=B(this);
 }
 sh()async=>await(await SharedPreferences.getInstance()).setInt('hs',h);
 G(this.h){init();}
 @override
 render(c){
  tx(s,o,u,f,[b=false]){
   var t=TextPainter(text:TextSpan(style:TextStyle(color:b?Colors.black:Colors.white,fontSize:f,fontFamily:'NS'),text:s),textScaleFactor:k,textDirection:TextDirection.ltr);
   t.layout();
   t.paint(c,u?Offset(o.dx-t.width/2,o.dy):o);
  }
  bg.renderRect(c,r);
  b.render(c);
  var ct=b.il+b.r.width/2;
  if(g)tx(u.toStringAsFixed(u<1?1:0),Offset(ct,b.it+b.r.height+10),true,k*10,true);
  tx(h.toString(),Offset(60,k*5),false,k*12);
  cr.renderRect(c,Rect.fromLTWH(5,k*10,49.2,39));
  tx(s.toString(),Offset(ct,k*50),true,k*25);
  h=s>h?s:h;
 }
 @override
 update(t){
  b.update(t);
  u-=g||o?t:0;
  if(u<0&&g){
   b.a=e;
   g=!e;
   u=2;
   o=e;
   sh();
   b.nG();
  }else if(g&&!o){
   var v=u.floor();
   if(v<l&&v<6&&v!=0)Future.delayed(Duration(milliseconds:200),()=>Flame.audio.play('tk'));
   l=v;
  }
  o=u<=0&&o?!e:o;
 }
 resize(s){
  sS=s;
  ts=sS.width/9;
 }
 ds(d){
  var p=d.globalPosition;
  m=b.ti.r.contains(p)?Dg.tissue:b.r.contains(p)?Dg.box:Dg.none;
  ip=Offset(p.dx==0?ip.dx:p.dx,p.dy==0?ip.dy:p.dy);
  sx=(b.ti.r.left-p.dx).abs();
 }
 du(d){
  if(o||m==Dg.none)return;
  var p=d.globalPosition;
  dp=Offset(p.dx==0?dp.dx:p.dx,p.dy==0?dp.dy:p.dy);
  if(m==Dg.tissue){
   if(ip.dy-dp.dy>100){
    if(g!=e&&o!=e){
     g=e;
     u=10;
     s=0;
    }
    var st=(sx-(b.ti.r.left-p.dx).abs()).abs();
    var sa=st<3?3:st<6?2:1;
    m=Dg.none;
    b.nT(sa);
    t(sa);
    s+=sa;
   }
  }else if(m==Dg.box){
   b.r=Rect.fromLTWH(b.il+dp.dx-ip.dx,b.r.top,B.q.dx,B.q.dy);
   b.m=e;
  }
 }
 t(i)=>Flame.audio.play('t$i',volume:0.2);
 de(d){
  ip=Offset.zero;
  b.ti.m=!e;
  b.m=!e;
  m=Dg.none;
  dp=ip;
 }
}
class B{
 Rect get ir=>Rect.fromLTWH(r.center.dx-T.w/2,r.top-r.height+15,T.w,T.w);
 Sprite get gb=>Sprite('b'+y.nextInt(3).toString());
 Offset get u=>Offset(ir.left,ir.top-150);
 double get it=>g.sS.height-g.ts*5.5;
 double get il=>g.sS.width/2-B.q.dx/2;
 static var q=Offset(150,100);
 var l=List<TA>();
 var y=Random();
 var m=false;
 var a=false;
 final G g;
 Sprite b;
 Rect r;
 int tc;
 T ti;
 B(this.g){
  r=Rect.fromLTWH(il,it,q.dx,q.dy);
  tc=10-y.nextInt(5);
  ti=T(g,this);
  b=gb;
 }
 render(c){
  b.renderRect(c,r);
  ti.rd(c);
  l.forEach((x)=>x.rd(c));
 }
 update(t){
  ti.ud(t);
  l.removeWhere((x)=>x.a);
  l.forEach((x)=>x.ud(t));
  var v=r.left-il;
  if(m&&!g.o){
   if(v.abs()>50&&tc==0)a=g.e;
  }else if(a&&!g.o){
   r=r.shift(Offset(v>0?r.left+g.k*11:r.left-g.k*11,r.top));
   if(r.right<-50||r.left>g.sS.width+50)nB();
  }else if(a&&g.o){
   var o=Offset(r.left,g.sS.height+T.w)-Offset(r.left,r.top);
   r=r.shift(g.k*11<o.distance?Offset.fromDirection(o.direction,g.k*11):o);
  }else{
   var o=Offset(il,it)-Offset(r.left,r.top);
   r=r.shift(g.k*11<o.distance?Offset.fromDirection(o.direction,g.k*11):o);
  }
 }
 nT(i){
  var d=Duration(milliseconds:100);
  l.add(TA(g,this));
  if(i>1)Future.delayed(d,(){l.add(TA(g,this));
  if(i>2)Future.delayed(d,(){l.add(TA(g,this));});});
  ti=T(g,this,--tc==0);
 }
 nB(){
  b=gb;
  r=Rect.fromLTWH(r.right<-0?g.sS.width+50-q.dx:-50,it,q.dx,q.dy);
  tc=10-y.nextInt(5);
  ti=T(g,this);
  a=!g.e;
  m=!g.e;
 }
 nG()async{
  a=g.e;
  Flame.audio.play('a',volume:0.5);
  await Future.delayed(Duration(seconds:2));
  nB();
 }
} 
class T{
 var s=Sprite('t1');
 static var w=100.0;
 var m=false;
 final B b;
 final G g;
 bool a;
 Rect r;
 T(this.g,this.b,[this.a=false]){r=b.ir;}
 rd(c)=>s.renderRect(c,r);
 ud(t)=>r=a?r.shift(Offset.infinite):b.ir;
}
class TA extends T{
 TA(G g,B b):super(g,b);
 rd(c)=>s.renderRect(c,r);
 ud(t){
  var s=500*t;
  Offset o=b.u-Offset(r.left,r.top);
  if(s<o.distance)r=r.shift(Offset.fromDirection(o.direction,s));else a=g.e;
 }
}