class liquid{
  PShader lq;
  ArrayList<phsp> ps;
  liquid(){
    ps=new ArrayList<phsp>();
    lq=loadShader("/sdcard/liquid/liquid.glsl");
    lq.set("lcolor",0.,0.,1.,0.5);
    lq.set("mx",float(width)/height);
  }
  
  void add(float x, float y, float m){
    ps.add(new phsp(x,y,m));
  }
  
  void clear(){
    ps.clear();
  }
  
  void update(earth e){
    filter(lq);
    int cnt=0;
    float[] px,py;
    px=new float[100];
    py=new float[100];
    if(ps.size()!=0){
      //beginShape();
      for(int i=0;i<ps.size();i++){
        phsp p = (phsp) ps.get(i);
        p.move(e);
        for(phsp p1:ps){
          if(p1!=p)
            collide(p1,p);
        }
        if(cnt<100){
          px[cnt]=p.x/width;
          py[cnt++]=p.y/width;
        }
      }
    }
    lq.set("pC",cnt);
    lq.set("px",px);
    lq.set("py",py);
  }
  
  void expl(float ex, float ey, float size){
    if(ps.size()!=0){
      for(int i=0;i<ps.size();i++){
        phsp p = (phsp) ps.get(i);
        p.expl(ex,ey,size);
      }
    }
  }
  
}

void collide(phsp c1, phsp c2) {
  float a=atan2(c2.y-c1.y, c2.x-c1.x);
  float l=dist(c1.x, c1.y, c2.x, c2.y);
  if (l<c1.l+c2.l) {
    l=c1.l+c2.l;
    float tx1=0, ty1=0, 
    tx2=l, ty2=l;
    
    c1.v.rotate(-a);
    c2.v.rotate(-a);
    
    float v1=c1.v.x,
    v2=c2.v.x, vtemp=v1;
    
    v1=(c1.m*v1+2*c2.m*v2-c2.m*v1)/(c2.m+c1.m);
    v2=(2*c1.m*vtemp-c1.m*v2+c2.m*v2)/(c1.m+c2.m);
    
    c1.v.x=v1;
    c2.v.x=v2;
    
    c1.v.rotate(a);
    c2.v.rotate(a);
    
    c2.x=c1.x+cos(a)*l;
    c2.y=c1.y+sin(a)*l;
  }
}

class phsp {
  int l=10;
  float x, y, m;
  PVector v, a, g;
  phsp(float ix, float iy, float im) {
    x=ix;
    y=iy;
    m=im;
    v=new PVector(0, 0);
    a=new PVector(0, 0.09);
    g=new PVector(0, 0.09);
    l*=2;
  }

  void expl(float ex, float ey, float size) {
    if (dist(x, y, ex, ey)<=size/2) {
      float dx=size*(x-ex)/(sq(dist(x, y, ex, ey))+0.001);
      float dy=size*(y-ey)/(sq(dist(x, y, ex, ey))+0.001);
      v.x+=dx/m;
      v.y+=dy/m;
      //v.add(a);
    }
  }

  void display() {
    noStroke();
    fill(255,0,0);
    ellipse(x, y, l, l);
  }

  void moveX(earth e) {
    x+=step;
    e.collision(this);
  }

  void moveY(earth e) {
    y+=step;
    e.collision(this);
  }

  void move(earth e) {
    v.add(a);
    if (x<0) {
      v.x*=-1;
    }
    if (x>width-l) {
      v.x*=-1;
    }
    /*float lx=x;
     float ly=y;*/
    float lx=x,ly=y;
    x+=v.x;
    y+=v.y;
    e.collision(this);
    /*x=lx+v.x;
     y=ly+v.y;*/
    
    if(random(1)>0.5){
      x+=noise(random(x));
      //y+=noise(y,x)*2;
    }else{
      x-=noise(random(x));
      //y-=noise(y,x)*2;
    }
    
    display();
    stroke(255,0,0);
    strokeWeight(l);
    line(lx,ly,x,y);
  }
}