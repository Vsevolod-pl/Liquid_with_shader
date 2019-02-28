

int k=100;
float step=1;
float damping=0.5;

int rnd(int n) {
  return int(random(n+1));
}

void cheat(int x1, int y1, int x2, int y2, phsp sp) {
  // Get difference between orb and ground
  float rot= atan2((y2 - y1), (x2 - x1));
  float deltaX = sp.x - (x1+x2)/2;
  float deltaY = sp.y - (y1+y2)/2;

  // Precalculate trig values
  float cosine = cos(rot);
  float sine = sin(rot);

  /* Rotate ground and velocity to allow 
   orthogonal collision calculations */
  float groundXTemp = cosine * deltaX + sine * deltaY;
  float groundYTemp = cosine * deltaY - sine * deltaX;
  float velocityXTemp = cosine * sp.v.x + sine * sp.v.y;
  float velocityYTemp = cosine * sp.v.y - sine * sp.v.x;

  /* Ground collision - check for surface 
   collision and also that orb is within 
   left/rights bounds of ground segment */
  if (groundYTemp > -sp.l/2
    && sp.x > x1 
    && sp.x < x2 ) {

    // keep orb from going into ground
    groundYTemp = -sp.l/2;
    // bounce and slow down orb
    velocityYTemp *= -1.0;
    velocityYTemp *= damping;
  }

  // Reset ground, velocity and orb
  deltaX = cosine * groundXTemp - sine * groundYTemp;
  deltaY = cosine * groundYTemp + sine * groundXTemp;
  sp.v.x = cosine * velocityXTemp - sine * velocityYTemp;
  sp.v.y = cosine * velocityYTemp + sine * velocityXTemp;
  sp.x = (x1+x2)/2 + deltaX;
  sp.y = (y1+y2)/2 + deltaY;
}

void near(phsp sp1, phsp sp2){
    float rot=atan2(sp1.y-sp2.y,sp1.x-sp2.x);
    float dx=cos(rot)*(sp1.l+sp2.l)/2;
    sp1.x=sp2.x+dx;
    //sp2.x=sp1.x-dx/2;
    
    float dy=sin(rot)*(sp1.l+sp2.l)/2;
    sp1.y=sp2.y+dy;
    //sp2.y=sp1.y-dy/2;
    
    /*stroke(0);
    strokeWeight(2);
    line(sp1.x,sp1.y,sp1.x+dx,sp1.y+dy);
    */
}

class earth {
  int[] px, py;
  earth(int [] pointx, int[] pointy) {
    px=pointx;
    py=pointy;
  }

  void display() {
    noStroke();
    fill(color(0, 255, 0));
    beginShape();
    vertex(0, height);
    for (int i=0; i< px.length-1; i++) {
      //line(px[i], py[i], px[i+1], py[i+1]);
      vertex(px[i], py[i]);
    }
    vertex(px[px.length-1], py[px.length-1]);
    vertex(width, height);
    endShape();
  }

  void collision(phsp sp) {
    for (int xi=0; xi<px.length-1; xi++) {
      //if (intersect(px[xi], py[xi], px[xi+1], py[xi+1], sp.x, sp.y, sp.l)) {
      /*int bx=px[xi+1]-px[xi];
       int by=py[xi+1]-py[xi];
       sp.v.y=sqrt( (sp.v.x*sp.v.x+sp.v.y*sp.v.y) / (1+by*by/(bx*bx)) )*(-sp.v.y/abs(sp.v.y))*damping;
       sp.v.x=sp.v.y*by/bx*damping;
       
              /*sp.x+=sp.v.x;
       sp.y+=sp.v.y;*/
      //}
      cheat(px[xi], py[xi], px[xi+1], py[xi+1], sp);
    }
  }
}





phsp sp, sp1;
liquid l;
//phsp[] sps= new phsp[100];

earth e;
int size=0;
boolean loe;

void setup() {
  requestPermission("android.permission.READ_EXTERNAL_STORAGE");
  size(displayWidth, displayHeight,P2D);
  int[] w = new int[(width)/100+1];
  int[] h = new int[w.length];
  for (int t=0; t<w.length; t++) {
    w[t]=t*width/(w.length-1);
    //h[t]=int(60*sqrt(sq(w.length/2)-sq(t-w.length/2) ));
    //h[t]=int(height - sq(t-w.length/2)*height/sq(w.length/2) );
    h[t]=int(noise(t)*height/2+height/2);
  }
  e = new earth(w, h);
  sp = new phsp(10, 0, 2);
  sp1= new phsp(0, 0, 20);
  
  /*for(int i=0;i<sps.length;i++){
   sps[i]=new phsp(i*width/sps.length+width/(2*sps.length), 0, -1);
   }*/
   
  l= new liquid();

  background(255);
}

void mousePressed() {
  /*
  background(0);
   text(intersect(rnd(width), rnd(height), rnd(width), rnd(height), rnd(width), rnd(height), 10*rnd(50))+"", 100, 100);
   */
  sp1.x=mouseX;
  sp1.y=mouseY;
  
  if(loe){
    l.clear();
  }
}

void draw() {
  
  if (mousePressed && loe) {
    l.add(mouseX,mouseY,2);
  }
  
  //background(0);
  noStroke();
  fill(color(255, 255, 0), 255);
  rect(0, 0, width, height);

  if (mousePressed && !loe) {
    size+=10;
    fill(color(255, 128, 0));
    ellipse(mouseX, mouseY, size, size);
  }

  e.display();
  sp.move(e);
  sp1.move(e);
  
  
  /*for(int i=0;i<sps.length;i++){
   sps[i].move(e);
   }*/

  l.update(e);
}

void keyPressed(){
  loe=!loe;
}

void mouseReleased() {
  sp.expl(mouseX, mouseY, size);
  sp1.expl(mouseX, mouseY, size);
  /*for(int i=0;i<sps.length;i++){
   sps[i].expl(mouseX,mouseY,size);
   }*/
  
  l.expl(mouseX, mouseY, size);
  
  size=0;
}
