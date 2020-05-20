Boid b;
ArrayList<Boid> boids = new ArrayList<Boid>();
int no_of_boids = 250;

void setup() {
  size(800, 600);
  // Add an initial set of boids into the system
  for (int i = 0; i < no_of_boids; i++) {
    //b = new Boid(new PVector(random(width),random(height)),1,50,25,50, 1.7,1.0,1.0);  // the cohesion,separation ad alignment radii determine flocking pattern (no of sub groups, group splitting etc)...
    //Boid(PVector pos_, float m_, float percept_r_, float separate_d_, float cohesion_r_, float sepMag_, float aliMag_, float cohMag_)
    //b.apply_force(new PVector(random(1),random(1),0)); // all boids are generated in mid screen with random initial force hence veocity
    b = new Boid(new PVector(width/2,height/2),1,50,25,50, 1.7,1.0,1.0);
    boids.add(b); //<>//
  }
}

void draw() {
  background(50);
  for (Boid b : boids){
    b.run_all_functions(boids); // start the simulation
  }
  
}

// Add a new boid into the System
void mousePressed() {
  b = new Boid(new PVector(mouseX,mouseY),1,50,25,50, 1.5,1.0,1.0);
  //b.apply_force(new PVector(random(1),random(1),0)); // all boids are generated in mid screen with random initial force hence veocity
  boids.add(b);
}
