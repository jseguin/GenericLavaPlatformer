/****************************************************************************
 * Author: Jonathan Seguin, Konstantino Kapetaneas, Winnie Kwan
 * Last Modified: April 21st 2010
 * Final Project
 ****************************************************************************/
class Lava {
  
  float lavaLvl= height/4;
  float noiseConst; //how wavy the lava is: under 0.01 works best for lava effect
  final float time = 0.01; // represents a second dimension of time in the noise calculation
  float current;//current noise calculation
  color lavaColour; // lava colour
  color[] colorArray = { //colour array for gradient effect
    color(120,42,5), 
    color(143,51,8), 
    color(166,59,8), 
    color(184,72,18), 
    color(201,83,27), 
    color(220,92,31), 
    color(233,99,36)
    };
    
    //constructor sets colour and how wavy lava will be
    Lava (color lavaColour, float noiseConst) {
      this.lavaColour = lavaColour;
      this.noiseConst=noiseConst;
    }
  
  //method creates a lava effect by drawing verticles lines at
  //different heights along the x-axis. heights follow a noise
  //pattern for smooth transitions between heights.
  void drawLava(float lavaLvl) {
    for (float x = 0; x < width; x++) {
      stroke(lavaColour);
      current = noise(x*noiseConst,frameCount*time);
      line (x,height,x, height-lavaLvl+current*50);
    }
  }
  
  //method draws a transparent gradient over top the lava effect
  void drawGradient () {
    for (int i = 0; i < 7; i++) {
      noStroke();
      fill(colorArray[i]);
      rect(0,(height-30)-(15*i),width,30);
    }
  }
}
