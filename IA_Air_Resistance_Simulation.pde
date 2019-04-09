
double re = 1000, g = 9.81, p = 1.225, dt=0.001;

class Sphere {
  private Position position;
  private double mass, cd, weight, area, r;
  private color sphereColor;
  private double x;
  public Sphere(double mass, double r, color sphereColor) {
    this.mass = mass;
    cd = 21.12/Math.sqrt(re)+6.3/Math.sqrt(re)+0.25;
    weight = mass*g;
    area = Math.PI*r*r;
    position = new Position(0, 0);
    this.r = r;
    this.sphereColor = sphereColor;
    x = width/2;
  }

  void tick() {
    double drag = cd*p*Math.pow(position.getV(), 2)*area/2;
    position.setA((weight-drag)/mass);

    double deltaD = position.getV()*dt+1/2*position.getA()*dt*dt;
    position.setD(position.getD()+deltaD);

    double deltaV = position.getA()*dt;
    position.setV(position.getV()+deltaV);
  }

  void render() {
    fill(sphereColor);
    ellipse((float)x, (float)position.getRenderY(), (float)r*2, (float)r*2);
  }

  Position getPosition() {
    return position;
  }
  
  void setX(double x){
    this.x = x;
  }
}

class Position {
  private double d, v, a;

  public Position(double d, double v) {
    this.d = d;
    this.v = v;
    a = 0;
  }

  public double getD() {
    return d;
  }

  public double getV() {
    return v;
  }

  public double getA() {
    return a;
  }

  public void setD(double d) {
    this.d = d;
  }

  public void setV(double v) {
    this.v = v;
  }

  public void setA(double a) {
    this.a = a;
  }

  public double getRenderY() {
    return d;
  }
}

long lastTime;
double d2t;
private ArrayList<Sphere> spheres;
private ArrayList<Double>[][] data;
void setup() {
  fullScreen();
  ellipseMode(RADIUS);
  background(color(0, 0, 0));
  spheres = new ArrayList();
  setupSpheres();
  double spacing = (double)width/spheres.size();
  for(int i = 0; i < spheres.size(); i++){
    double x = spacing*(double)i+1/2;
    spheres.get(i).setX(x);
  }
  data = new ArrayList[spheres.size()][];
  for (int i = 0; i < data.length; i++) {
    data[i] = new ArrayList[]{
      new ArrayList(), 
      new ArrayList(), 
      new ArrayList()
    };
  }
  d2t = 0;
  lastTime = System.nanoTime();
}

void draw() {
  clear();
  long now = System.nanoTime();
  d2t += (now-lastTime)/dt/1e9;
  lastTime = now;
  while (d2t>=1) {
    for (int i = 0; i < spheres.size(); i++) {
      spheres.get(i).tick();
      data[i][0].add(spheres.get(i).getPosition().getD());
      data[i][1].add(spheres.get(i).getPosition().getV());
      data[i][2].add(spheres.get(i).getPosition().getA());
    }
    d2t--;
  }
  for (int i = 0; i < spheres.size(); i++) {
      spheres.get(i).render();
    }
}

void save(){
  
}

void keyPressed(){
  if(key=='w'){
    save();
  }
}

void setupSpheres() {
  for(int i = 0; i < 15; i++){
    spheres.add(new Sphere(i*1000, i, color((int)(Math.random()*255), (int)(Math.random()*255), (int)(Math.random()*255))));
  }
}
