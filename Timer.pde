/****************************************************************************
 * Author: Jonathan Seguin, Konstantino Kapetaneas, Winnie Kwan
 * Last Modified: April 21st 2010
 * Final Project
 ****************************************************************************/
class Timer {
  
  int s; //used for easy calculation of time with modulo
  long beginTime; //time in milliseconds the timer started
  int minutes; //minutes past since timer started
  int seconds; //seconds past since timer started
  float x, y; //position of timer text
  color c; //timer text colour
  PFont startFont = loadFont("pixelfont.vlw");// timer font
  
  Timer(float x, float y) {
    this.beginTime = millis();
    this.x = x;
    this.y = y;
    s = 60 * (int)(passedTime()/1000);
    c = color(222, 255, 122);
  }
  
  //return the time passed since the timer started
  long passedTime() {
    return millis() - beginTime;
  }
  
  //restart the timer
  void restart() {
    this.beginTime = millis();
  }
  
  //keep track of time and print time in minutes and seconds
  //to the screen based on an x and y position.
  void timer() {
    //adjust time
    s = 60 * (int)(passedTime()/1000);
    minutes = (s/3600) % 60;
    seconds = (s/60) % 60;
    textFont(startFont, 30);
    // timer text
    fill(0);
    text(nf(minutes, 2) + ":" + nf(seconds,2), x, y+2);
    fill(c);
    text(nf(minutes, 2) + ":" + nf(seconds,2), x, y);
  }

}
