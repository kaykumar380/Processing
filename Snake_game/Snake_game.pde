Snake snake;
int dir = 3;
PVector food;
float food_radius=12;

void setup()
{
 size(400,400);
 frameRate(20);
 snake = new Snake(new PVector(100,100),4);
 food = new PVector(random(width),random(height));
}

void draw()
{
  background(0);
  snake.run(dir);
  displayFood(food); //<>//
  if(snake.eat(food)){
    food = new PVector(random(width),random(height)); // create new food
  }
  if(snake.dead){
   snake = new Snake(new PVector(100,100),4); 
  }
  
}

void displayFood(PVector food)
{
 fill(50,250,50); 
 noStroke();
 rectMode(CENTER);
 rect(food.x,food.y,food_radius*0.4,food_radius*0.4);
 stroke(50,250,50);
 noFill();
 rect(food.x,food.y,food_radius,food_radius);
}

void keyReleased()
{
  if (key == CODED) {
    if (keyCode == RIGHT) {
      dir = 1;
    } else if (keyCode == UP) {
      dir = 2;
    }
    else if (keyCode == LEFT) {
      dir = 3;
    }
    else if (keyCode == DOWN) {
      dir = 4;
    }
    
  }
  
}
