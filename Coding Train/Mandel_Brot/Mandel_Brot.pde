import controlP5.*;

int maxIter = 100;
float mandelXrange = 1.5;
float mandelYrange = 1.5;

int hue_velocity = 1;

color[] colors = {color(66, 30, 15), color(25, 7, 26), color(9, 1, 47), color(4, 4, 73),
                  color(0, 7, 100), color(12, 44, 138), color(24, 82, 177), color(57, 125, 209),
                  color(134, 181, 229), color(211, 236, 248),color(241, 233, 191),color(248, 201, 95),
                  color(255, 170, 0),color(204, 128, 0),color(153, 87, 0), color(106, 52, 3)};
void setup()
{
 size(1600,1350);
 
}

int iterVal(float a,float b)
{
  int iterNum = 0;
  float z_real = 0;
  float z_img = 0;
  float z_real_temp, z_img_temp;
  for (iterNum = 0; iterNum< maxIter; iterNum++)
    {
      z_real_temp = z_real*z_real-z_img*z_img + a;
      z_img_temp = 2*z_real*z_img + b;
      z_real = z_real_temp;
      z_img = z_img_temp;
      
      if ((z_real*z_real+z_img*z_img)> (mandelXrange*mandelXrange+mandelYrange*mandelYrange)) break;
    }
    
   return iterNum; 
}

color brightnessVal(int iterNum){
 // close to wikipedia coloring scheme, 16 discrete color gradient
     //if (iterNum == maxIter){
     //  return color(0);
     //}
     //else { 
     //  int val = iterNum % 16;
     //  return colors[val];
     //}
     
     
 //-------------------------------------------------
 // Shiffman Coding Train
 //float temp= map(iterNum,0,maxIter,0,1);
 //temp = map(sqrt(temp),0,1,0,255); 
 //----------------------------------------------
 // Cosine interpolation : http://www.stefanbion.de/fraktal-generator/colormapping/index.htm
     colorMode(HSB,360,100,100);
     if (iterNum == maxIter){
       return color(255,255,0);
     }
     else { 
       float temp = map(iterNum,0,maxIter,0,1);
       temp = (cos(temp * PI + PI) + 1) / 2; 
       temp = map(temp,0,1,20,220);
       return color((int) temp, 100,100);
     }
 //---------------------------------------------------------------    
  
}

void draw()
{
 loadPixels();
 for (int i = 0; i < width ; i++)
  {
    for (int j = 0; j < height ; j++)
    {
      float x = map(i,0,1500,-1*mandelXrange-.7,mandelXrange-.7);
      float y = map(j,0,1500,-1*mandelYrange+.2,mandelYrange+.2); 
      int iter = iterVal(x,y);
      pixels[i+j*width] = brightnessVal(iter);     
    }  
  }
  updatePixels();
  hue_velocity++;
  save("Mandelbrot_6.png");
}