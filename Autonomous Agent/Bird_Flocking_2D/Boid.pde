class Boid
{
  PVector pos;
  PVector v;
  float m;               //mass
  float r; // size of Boid
  float percept_r; // perception radius for a boid, limits the parameter calculation dependency on other boids
  float sizefactor;
  // constant parameters
  float max_speed,max_f,separate_d,cohesion_r, sepMag, aliMag, cohMag;
  
  
  Boid(PVector pos_, float m_, float percept_r_, float separate_d_, float cohesion_r_, float sepMag_, float aliMag_, float cohMag_)
  {
    pos = pos_;
    m = m_;
    percept_r = percept_r_;
    
    v = new PVector(random(-2,2), random(-2,2));
    // constant parameters assign
    max_speed = 2;
    max_f = 0.05;
    sizefactor = 3.0;
    separate_d = separate_d_; // preffered separate distance from neighbors;
    cohesion_r = cohesion_r_; // radius of neighborhood checking for calculating neighborhood center;
    sepMag = sepMag_;
    aliMag = aliMag_;
    cohMag = cohMag_;
    r = m*sizefactor;
    
  }
  
  void apply_force(PVector force)
  {
   PVector fc = force.copy();
   PVector a = fc.div(m); // = a
   v.add(a); 
   v.limit(max_speed); // limiting the max speed, regardless the unconstrained applied force
   a.mult(0); // velocity updated, so a is set to '0', otherwise with each frame, v will keep increasing. 
  }
  
  void update_pos() // update position with screen wrapping around
  {
    pos.add(v); 
    // adding wrapping around the screen
    if (pos.x < -r) pos.x = width+r;  // x-left to x-right wrapping
    if (pos.y < -r) pos.y = height+r; // y-top to y-bottom wrapping
    if (pos.x > width+r) pos.x = -r;  // x-right to x-left wrapping
    if (pos.y > height+r) pos.y = -r;  // y-bottom to y-top wrapping
    
  }
  
  //// Reynolds : Steering force = Desired - Velocity
  
  
  //steering force towards target calculation, used in coherence to navigate to flock center
  
  PVector steer_force(PVector target_loc)
  {
    // the desired velocity = (target_location - current_location)*scaling_factor(k)
    // A reasonable choice for 'k' is max speed
    PVector desired_v = PVector.sub(target_loc, pos);
    //desired_v.normalize();
    //desired_v.mult(max_speed);
    desired_v.setMag(max_speed); // does the same job as the two lines above (normalize then mult)
                                 // desired velocity ; set to max magnitude because its desired 
    
    // now the steering force is calculated from desired velocity
    // steering force = desired velocity - current velocity
    PVector steering_f = PVector.sub(desired_v, v);
    steering_f.limit(max_f); // steering force can be limited here, but not necessary, the constarint is only set for only max speed;
                             // But without thi slimiting boids join together and start spinning on a joined axis;
    return steering_f;
  }
  
  void display() // display a Boid
  {
   // Drawing a triangle rotated in the direction of velocity
    float theta = v.heading() + radians(90);
    
    fill(200, 100);
    stroke(255);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix(); 
  }
  
 // The three rules -> Alignment, separation, cohesion
 PVector alignForce(ArrayList <Boid> boids){
   PVector v_sum = new PVector(0,0);
   float no_neighbors= 0;
   
   for (Boid other: boids){
    float dist = abs(PVector.dist(pos, other.pos));
    if (dist >0 && dist < percept_r) // checking for all but self Boids in percept_r
    {
     v_sum.add(other.v); 
     no_neighbors++;
    }
   }
   
   if (no_neighbors >0) // if a Boid is in isolation, this check is necessary
   {
    v_sum.div(no_neighbors); // group avg velocity is here
    v_sum.setMag(max_speed); // desired velocity ; set to max magnitude because its desired 
    PVector steering_f = PVector.sub(v_sum, v);
    // steering force can be limited here, but not necessary, the constarint is only set for only max speed;
    steering_f.limit(max_f); // without this line all boids appear as a single boid if all are generated at the same point
    return steering_f;
   }
   else {
      return new PVector(0, 0);
    }
 }

 // Separation, Method checks for nearby boids and steers away
   PVector separateForce (ArrayList<Boid> boids) {
   PVector avg_neighbor_dir = new PVector(0, 0); // average direction away from neighbors
   float no_neighbors = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float dist = PVector.dist(pos, other.pos); // dist always gives +ve result
      if (dist < separate_d && dist >0) { // dist >0 to avoid checking itself
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, other.pos); // gives a vector in opposite dir of neighbor in vicinity    
        diff.setMag(1.0/dist); // weighted by inverse dist, the far away the neighbor, the less the influence
        avg_neighbor_dir.add(diff);
        no_neighbors++;            
      }
    }
    // Average
    if (no_neighbors > 0) { //necessary to check if Boid is in isolation; to avoid 0 division
      avg_neighbor_dir.div(no_neighbors);
    }

    // As long as the vector is greater than 0
    if (avg_neighbor_dir.mag() > 0) {
      
       avg_neighbor_dir.setMag(max_speed);

      // Implement Reynolds: Steering = Desired - Velocity
      
      PVector steer_f = PVector.sub(avg_neighbor_dir,v);
      steer_f.limit(max_f);
      //steer_f.mult(-1);
      //println(steer_f.mag());
      return steer_f;
    }
    else return new PVector(0,0);
  }

// Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesionForce (ArrayList<Boid> boids) {
    
    PVector neighborDist_sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    float no_neighbors = 0;
    for (Boid other : boids) {
      float dist = PVector.dist(pos, other.pos);
      if (dist > 0 && dist < cohesion_r) {
        neighborDist_sum.add(other.pos); // Add position
        no_neighbors++;
      }
    }
    if (no_neighbors > 0) { // isolation check to avoid 0 division
      neighborDist_sum.div(no_neighbors);
      return steer_force(neighborDist_sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0);
    }
  }
  
// combining applying of all three Flock forces (Cohesion, Sep, align) in a single func
  void applyFlockForces(ArrayList<Boid> boids) {
    PVector sep = separateForce(boids);   // Separation
    PVector ali = alignForce(boids);      // Alignment
    PVector coh = cohesionForce(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(sepMag);
    ali.mult(aliMag);
    coh.mult(cohMag);
    // Add the force vectors to acceleration
    apply_force(sep);
    apply_force(ali);
    apply_force(coh);
  }

void run_all_functions(ArrayList<Boid> boids){ // combining flocking forces, rendering, updating
  applyFlockForces(boids);
  update_pos();
  display();
  
}

}
