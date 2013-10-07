/****************************************************************************
 * Author: Jonathan Seguin, Konstantino Kapetaneas, Winnie Kwan
 * Last Modified: April 21st 2010
 * Final Project
 ****************************************************************************/
//4 days of programmming hell. 
//Disclaimer: Possible sloppy and or redundant code still lying around in here.
//Description: don't fall into lava, jump, yay.
//Controls: 
//-----------------------------------------
//Use a or <- to move left
//Use d or -> to move right
//Press and release spacebar to jump
//-----------------------------------------
//Song Credits: 
//Artist: Linde - http://www.8bitpeoples.com/discography/by/linde
//Song: Void Traveller 
//Used under this license - http://creativecommons.org/licenses/by-nc-nd/3.0/
//----------------------------------------------------------------------------
//Physics Engine: Fisica - http://www.ricardmarxer.com/fisica/
//It's a JBox2d wrapper for processing, very early alpha release. 
//However it had much better documentation and an easier implementation
//----------------------------------------------------------------------------


//Import Statements
//----------------------------------------------------------------------------
import fisica.*;
import ddf.minim.*;

//Variables
//----------------------------------------------------------------------------
Time time; //class to keep track of time passed since game start/score
Minim minim;
AudioPlayer song;
PFont startFont; //our game font
Anim runLeft;//animation object for walking left
Anim runRight;//animation object for walking right
PImage bg, l_wall, r_wall, t_wall; //game environment images
PImage hl_sprite, hr_sprite, hlj_sprite, hrj_sprite; //player sprites
PImage logo, copyright; // title screen images
FWorld world;//physics environment for the sketch
FBox hero; //physics object that represents the player
boolean direction; //player is facing: right = true; left = false;
Lava lava; //objects to draw layered lava
Lava lava2;// "
Lava lava3;// "
int gameState = 0; //3 game states: 0 = title screen; 1 = game play; 2 = game over;
PlatformGen plats; //class to handle platform generation and modification

float lavaLvl = 235;//level of lava for game play
float lavaLvl2 = 270;// level of lava for title screen
float speedX, speedY;//player velocity in x and y axes
boolean left, right, jump;//booleans switches to see if an action is to be performed
int jumpCounter = 0;

//Initialization - see ^Variables^ for what each variable does.
//----------------------------------------------------------------------------
void setup(){
  size(500,620, P2D);
  Fisica.init(this); //sets up physics  
  smooth(); //uncomment for better graphics (at least tino thinks so) 
  time = new Time(450, 600);
  minim = new Minim(this);
  song = minim.loadFile("music.mp3");
  song.play();
  startFont = loadFont("pixelfont.vlw");
  //Image Loading
  //-----------------------------------------
  logo = loadImage("data/logo.png");
  copyright = loadImage("data/copyright.png");
  bg = loadImage("data/background.gif");
  l_wall = loadImage ("data/wall_left.gif");
  r_wall = loadImage ("data/wall_right.gif");
  runRight = new Anim (3, "hr_sprite","data/");
  runLeft=  new Anim (3, "hl_sprite","data/");
  hl_sprite = loadImage ("data/hl_sprite.gif");
  hlj_sprite = loadImage ("data/hlj_sprite.gif");
  hr_sprite = loadImage ("data/hr_sprite.gif");
  hrj_sprite = loadImage ("data/hrj_sprite.gif");
  //-----------------------------------------
  lava = new Lava(color(138,17,24),0.002);
  lava2 = new Lava(color(227,56,28),0.003);
  lava3 = new Lava(color(251,102,30),0.004);
  speedX = 10;
  speedY = 400;
  //initialization specific to physics engine 
  //-----------------------------------------
  world = new FWorld();
  world.setGravity(0, 800);
  world.setEdges(color(255,150,0));
  world.setGrabbable(false);
  world.left.setWidth(26);
  world.left.adjustPosition(18,0);
  world.left.attachImage(l_wall);
  world.right.setWidth(26);
  world.right.adjustPosition(-18,0);
  world.right.attachImage(r_wall);
  world.top.setDrawable(false); 
  hero = new FBox(32,34);
  hero.setRestitution(0);
  hero.setPosition(width/2, 300);
  hero.setRotatable(false);
  hero.attachImage(hl_sprite);
  hero.setFriction(0.1);
  world.add(hero);
  //-----------------------------------------
  plats = new PlatformGen(12, world);
}

//Methods
//----------------------------------------------------------------------------

//overide processing's stop() method
//to kill mimim on exit.
void stop() {
  song.close();
  minim.stop();
  super.stop();
}

//method displays title screen
void title() {
  //  background(150);
  image(bg,0,0);

  lava.drawLava(lavaLvl2);
  lava2.drawLava(lavaLvl2-5);
  lava3.drawLava(lavaLvl2-10);
  lava3.drawGradient();

  image(logo,65,100);
  image(copyright,142,585);

  textAlign(CENTER);
  //PRESS ANY BUTTON TEXT
  textFont(startFont);
  //Shadow:
  fill(125, 51, 15);
  text("PRESS ANY BUTTON", width/2, 434);
  //Actual Start Text:
  fill(222, 255, 122);
  text("PRESS ANY BUTTON", width/2, 430);
}

//method displays "Game Over" screen
void gameOver() {
  image(bg,0,0);
  world.step();
  world.draw();
  lava.drawLava(lavaLvl2);
  lava2.drawLava(lavaLvl2-5);
  lava3.drawLava(lavaLvl2-10);
  lava3.drawGradient();
  fill(0, 100);
  rect(0, 0, width, height);
  textAlign(CENTER);
  textFont(startFont);

  //Shadow:
  fill(0);
  text("GAME OVER", width/2, 200);

  //Actual Text:
  fill(222, 255, 122);
  text("GAME OVER", width/2, 202);
  textFont(startFont, 25);
  fill(0);
  text("Your score: " + time.minutes + ":" + time.seconds +"", width/2, 232);
  text("Press R to try again", width/2, 272);
  fill(255);
  text("Your score: " + time.minutes + ":" + time.seconds +"", width/2, 230);
  text("Press R to try again", width/2, 270);
}

//method causes player to jump
void jump (FBody target) {
  if (jumpCounter < 2) { // allow jump to be called twice only
    target.adjustVelocity(0,-speedY); //adjust vertical velocity
    jumpCounter++; //keeps track of your jumps (max 2 allowed)
  }
}

//method detects when collisons are started
//if a collision involves the player
//and an object and the player's feet touch
//the surface of that object then 
void contactStarted (FContact contact) {
  if (contact.getBody1() == hero || 
    contact.getBody2() == hero) 
  {
    //is touching ground? *cough or beside the ground cough*
    if ((hero.getY()+hero.getHeight()/2) - contact.getY() < 1){
      jumpCounter = 0; //reset jumpCounter so player can jump again

      //reset sprites when player lands to standing sprite
      if (direction)
        hero.attachImage(hr_sprite);
      if (!direction)
        hero.attachImage(hl_sprite);
    }
  }

}

//method checks to see if character is dead
//and changes game state to game over if true
void isDead(FBody target) {
  if (target.getY() > height-lavaLvl) {
    gameState = 2;
  }
}

//method handles activation of any player actions
//eg: if jump state is active then call the jump function
//if control() is not called the player will be immobile.
void control() {
  //move left
  if (left){
    hero.adjustVelocity(-speedX,0); //decrease player's horizontal velocity
    //draw sprites
    if (frameCount % 6 == 0) { 
      if (jumpCounter != 0) { // if in the air draw jump sprites
        hero.attachImage(hlj_sprite);
      } 
      else {
        hero.attachImage(runLeft.cycler()); // if on ground cycle through run animation
      }
    }
  }

  //move right
  if (right) {
    hero.adjustVelocity(speedX,0); //increase player's horizontal velocity

    //draw sprites 
    if (frameCount % 6 == 0) {
      if (jumpCounter != 0) { // if in the air draw jump sprites
        hero.attachImage(hrj_sprite); 
      } 
      else {
        hero.attachImage(runRight.cycler()); // if on ground cycle through run animation
      }
    }
  }

  //Jump 
  if (jump) {
    if (direction) { //if facing right
      hero.attachImage(hrj_sprite); //draw right jump sprite
    } 
    else if (!direction) { //if facing left
      hero.attachImage(hlj_sprite); //draw left jump sprite
    }
    jump(hero);
    jump=false;
  }
}


void keyPressed() {
  //if in game play state listen for control keys and activate control states
  if (gameState ==1) {
    if (key == 'a' || key == 'A' || key == CODED && keyCode == LEFT) {
      left = true;
      direction = false;
    } 
    else if (
    key == 'd' || key == 'D' || key == CODED && keyCode == RIGHT) {
      right = true;
      direction = true;
    } 
  }
  //if in game over game state stop song, reset game, restart song
  if (gameState == 2) {
    if (key == 'r' || key == 'R') {
      song.close();
      setup();
      gameState = 1;
      song.play(1500);
    }
  }
}

void keyReleased() {
  // if in title screen state switch to gameplay and reset timer on key release
  if (gameState == 0) {
    gameState=1;
    time.restart();
  } 
  else {
    //on release of left keys deactivate left state
    if (key == 'a' || key == 'A' || key == CODED && keyCode == LEFT) {
      left = false;
      if (jumpCounter != 0) {
      } 
      else {
        hero.attachImage(hl_sprite);
      }
    } 
    //on release of right keys deactivate right state
    else if (key == 'd' || key == 'D'|| key == CODED && keyCode == RIGHT) {
      right = false;
      if (jumpCounter != 0) {
      } 
      else {
        hero.attachImage(hr_sprite);
      }
    } 
    //on release of jump key activate jump
    else if (key == ' '){
      jump = true;
    }
  }
}

//Output
//----------------------------------------------------------------------------
void draw(){
  //title Screen
  if(gameState == 0) {
    title();
  } 
  //Game Play
  else if (gameState == 1) {
    control(); //manage user input
    image(bg,0,0); //draw background
    isDead(hero); //check to see if player is dead


    //advance and draw physics
    world.step();
    world.draw();

    //draw lava
    lava.drawLava(lavaLvl);
    lava2.drawLava(lavaLvl-5);
    lava3.drawLava(lavaLvl-10);
    lava3.drawGradient();

    //manage platforms
    plats.difficulty(time); //increases difficulty(speed) as time goes by
    plats.down(); //adjust platforms to move down
    plats.cleanUp(lavaLvl); //any platforms under the lava are moved to the top

    time.timer(); // call and draw timer
  } 
  //Game Over
  else if (gameState == 2) {
    gameOver();
  }
}













