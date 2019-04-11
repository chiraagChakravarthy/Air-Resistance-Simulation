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

    double dD = position.getV()*dt+1/2*position.getA()*dt*dt;
    position.setD(position.getD()+dD);

    double dV = position.getA()*dt;
    position.setV(position.getV()+dV);
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
double delta;
ArrayList<Sphere> spheres;
ArrayList<Double>[][] data;
boolean saving;


void setup() {
  fullScreen();
  ellipseMode(RADIUS);
  background(color(0, 0, 0));
  spheres = new ArrayList();
  setupSpheres();
  double spacing = (double)width/spheres.size();
  for(int i = 0; i < spheres.size(); i++){
    double x = spacing*((double)i+0.5d);
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
  delta = 0;
  lastTime = System.nanoTime();
  saving = false;
}

void draw() {
  clear();
  long now = System.nanoTime();
  delta += (now-lastTime)/dt/1e9;
  lastTime = now;
  while (delta>=1) {
    for (int i = 0; i < spheres.size(); i++) {
      spheres.get(i).tick();
    }
    delta--;
  }
  for (int i = 0; i < spheres.size(); i++) {
    if(!saving){
      data[i][0].add(spheres.get(i).getPosition().getD());
      data[i][1].add(spheres.get(i).getPosition().getV());
      data[i][2].add(spheres.get(i).getPosition().getA());
    }
    spheres.get(i).render();
  }
  System.out.println(spheres.get(0).getPosition().getD());
}

void save(){
  saving = true;
  Table table = new Table();
  table.addColumn("t");
  for(int i = 0; i < spheres.size(); i++){
    table.addColumn("M" + i + " Displacement");
    table.addColumn("M" + i + " Velocity");
    table.addColumn("M" + i + " Acceleration");
  }
  for(int i = 0; i < data[0][0].size(); i++){
    TableRow row = table.addRow();
    row.setDouble("t", i/60.0d);
    for(int j = 0; j < spheres.size(); j++){
      row.setDouble("M" + j + " Displacement", data[j][0].get(i));
      row.setDouble("M" + j + " Velocity", data[j][1].get(i));
      row.setDouble("M" + j + " Acceleration", data[j][2].get(i));
    }
  }
  saveTable(table, "data/trial.csv");
  exit();
}

void keyPressed(){
  if(key=='w'){
    save();
  }
}

void setupSpheres() {
  for(int i = 0; i < 15; i++){
    spheres.add(new Sphere(i*1000+1000, i+1, color((int)(Math.random()*255), (int)(Math.random()*255), (int)(Math.random()*255))));
  }
}
