class Snake{
  
  PVector pos;
  float speed;
  //
  int dir = 3; // indicates head direction,
                 // 1 = right, 2 = up, 
                 // 3 = left, 4 = down
  //float updatelimit = 5; // position udate event max limit
  //float updatecounter= 0; // position update event initial var
  boolean dead = false;
  float size = 20;
  float spacing = 4;
  ArrayList<PVector> cells = new ArrayList<PVector>();
  
  
  Snake(PVector pos_, float speed_){
    pos = pos_;
    speed = speed_;
    // 
    //create initial head
    PVector temp_i = pos.copy();
    cells.add(temp_i);
    //create initial body
    for(float i = 1.0; i<size;i+=1.0)
    {
      float temp_x = temp_i.x+ i*spacing;
      float temp_y = temp_i.y;
      PVector temp = new PVector(temp_x,temp_y);
      cells.add(temp);
    }
    for(int i = 0; i<cells.size(); i++)
    {
      PVector cell = (PVector) cells.get(i);
      println(i+ "initial "+cell);
    }
  }
  
  
    
  //boolean updateCounter() // indicates position update event
  //{
  //  updatecounter += speed;
  //  if (updatecounter >=  updatelimit)
  //  {
  //   return true; 
  //  }
    
  //  else return false;
  //}
  
  //void updatePosition(){
    
  //}
  
  void getDirection(int direction) //direction filtering, avoiding reverse or froward motions
  {
   if(dir == 1 && (direction == 2 || direction == 4)) dir= direction;
   else if (dir == 2 && (direction == 1 || direction == 3)) dir= direction;
   else if (dir == 3 && (direction == 2 || direction == 4)) dir= direction;
   else if (dir == 4 && (direction == 1 || direction == 3)) dir= direction;
  }
  
  void updateSnakeHead(){
   PVector tempi = new PVector(0,0);
   tempi = cells.get(0);
   PVector temp = tempi.copy();
   if (dir == 1){
     temp.x+= speed;
     if (temp.x > width)temp.x-=width;
   }
   else if (dir == 2){
     temp.y-= speed;
     if (temp.y < 0)temp.y+=height;
   }
   else if (dir == 3){
     temp.x-= speed;
     if (temp.x < 0)temp.x+=width;
   }
   else {
     temp.y+= speed;
     if (temp.y > height)temp.y-=height;
   }
   for(int i = 0; i<3; i++)
    {
      PVector cell = (PVector) cells.get(i);
      println(i+ "Head "+cell);
    }
    
    cells.remove((cells.size()-1));
    cells.add(0,new PVector(temp.x,temp.y));
  }
  
  void updateSnakeBody(){ //simply shfit body cells in arraylist
    cells.remove((cells.size()-1));
    println("Snake body:");
    for(int i = 0; i<cells.size(); i++)
    {
      PVector cell = (PVector) cells.get(i);
      println(i+ " "+cell);
    }
    cells.add(0,new PVector(pos.x,pos.y)); 
    
    for(int i = 0; i<cells.size(); i++)
    {
      PVector cell = (PVector) cells.get(i);
      println(i+ " "+cell);
    }
  }
  
  void display()
  {
   fill(255);
   noStroke();
   rectMode(CENTER);
   for (PVector cell: cells)
   {
    rect(cell.x,cell.y,spacing,spacing);
   }
  }
  
  void run(int direction)
  {
    getDirection( direction);
    updateSnakeHead();
    //updateSnakeBody();
    //wrapScreen();
    display();
    isDead();
  }
  
  boolean eat(PVector food_loc){
    PVector head = (PVector) cells.get(0);
    if(PVector.dist(head,food_loc)<= 12){
       //size++;
       //cells.add(0,new PVector(pos.x,pos.y)); // grow head
       PVector end = (PVector) cells.get((int)(size-1));
       PVector endC = new PVector(0,0);
       endC = end.copy();
       cells.add(endC); // grow same tail
       size++;
       return true;
    }
    else return false;
  }
  
  void wrapScreen()
  {
    for (PVector cell: cells)
   {
     if(cell.x >= width) cell.x=0;
     if(cell.x < 0) cell.x=width;
     if(cell.y >= height) cell.y=0;
     if(cell.y < 0) cell.y=height;
   }
  }
  
  void isDead()
  {
    PVector head = (PVector) cells.get(0);
    /*for(int i = 0; i<cells.size(); i++)
    {
      PVector cell = (PVector) cells.get(i);
      println(i+ " "+cell);
    }*/
    
    for(int i= 2; i<cells.size(); i++)
    {
      PVector other_cell = (PVector) cells.get(i);
      //println(other_cell);
      float dist = PVector.dist(head,other_cell);
      if(abs(dist)< 0.005)
      { dead = true;println(i+" "+str(dist)); 
        //println(head);
        //println(other_cell);
        break;}//}
      else dead = false;
   }
  }
}
