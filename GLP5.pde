/****************************************************************************
 * Author: Jonathan Seguin
 * Last Modified: October 6th 2014
 ****************************************************************************/
//Description: don't fall into lava, jump, yay.

//Controls: 
//-----------------------------------------
//Use a or <- to move left
//Use d or -> to move right
//Press spacebar to jump
//-----------------------------------------

//Song Credits: 
//Artist: Linde - http://www.8bitpeoples.com/discography/by/linde
//Song: Void Traveller 
//Used under this license - http://creativecommons.org/licenses/by-nc-nd/3.0/
//----------------------------------------------------------------------------
import ddf.minim.*;

//Variables
//----------------------------------------------------------------------------
Timer timer; //class to keep track of time passed since game start/score
Minim minim;
AudioPlayer song;

PFont startFont; //our game font
PImage bg, l_wall, r_wall, t_wall, block; //game environment images
PImage logo, copyright; // title screen images

Player player;

Lava lava; 
Lava lava2;
Lava lava3;
Lava[] layeredLava; 

float DEFAULT_LAVAHEIGHT;
float GAMEPLAY_LAVAHEIGHT;
float lavaHeight = DEFAULT_LAVAHEIGHT;//level of lava for game play

final int TITLESCREEN = 0;
final int GAMEPLAYSCREEN = 1;
final int GAMEOVERSCREEN = 2;
int gameState = TITLESCREEN;

MultiSpawn platformManager;

void setup() {
    size(632, 620, P2D);
    //    smooth(); //uncomment for better graphics (at least tino thinks so) 
    timer = new Timer();
    minim = new Minim(this);
    song = minim.loadFile("music.mp3");
    song.loop();
    song.play();
    startFont = loadFont("pixelfont.vlw");

    //Image Loading
    logo = loadImage("data/logo.png");
    copyright = loadImage("data/copyright.png");
    bg = loadImage("data/background.gif");
    l_wall = loadImage ("data/wall_left.gif");
    r_wall = loadImage ("data/wall_right.gif");
    block = loadImage("plat_block.gif");

    //Player
    player = new Player();
    player.getAABB().setRange(l_wall.width, width - r_wall.width, 0, height-player.getAABB().getHeight());
    player.setPosition(width/2 - player.getAABB().getWidth()/2, height/4 + player.getAABB().getHeight());

    //Lava
    DEFAULT_LAVAHEIGHT = height * .435f;
    GAMEPLAY_LAVAHEIGHT = height * .333f;
    lava = new Lava(color(138, 17, 24), 0.002, DEFAULT_LAVAHEIGHT);
    lava2 = new Lava(color(227, 56, 28), 0.003, DEFAULT_LAVAHEIGHT-5);
    lava3 = new Lava(color(251, 102, 30), 0.004, DEFAULT_LAVAHEIGHT-10);
    lava3.toggleGradient(true);
    layeredLava = new Lava[] {
        lava, lava2, lava3
    };

    //Platforms
    platformManager = new MultiSpawn(4, 0 + l_wall.width, width - r_wall.width, int(player.getAABB().getWidth()));
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

void drawLayeredLava() {
    for (Lava lava : layeredLava) {
        lava.update(FrameTime.deltaTime());
        lava.display();
    }
}

//method displays title screen
void title() {
    image(bg, 0, 0, width, height);
    drawLayeredLava();

    image(logo, (width-logo.width)/2f, height*(1/6f));
    image(copyright, (width-copyright.width)/2f, height*.95f);

    textAlign(CENTER);
    //PRESS ANY BUTTON TEXT
    textFont(startFont);
    //Shadow:
    fill(125, 51, 15);
    text("PRESS ANY BUTTON", width/2, height * .7f + 4);
    //Actual Start Text:
    fill(222, 255, 122);
    text("PRESS ANY BUTTON", width/2, height * .7f);
}

//Displays GameOver screen
void gameOver() {
    println(FrameTime.deltaTime());
    image(bg, 0, 0, width, height);
    image(l_wall, 0, 0);
    image(r_wall, width-r_wall.width, 0);
    drawLayeredLava();
    fill(0, 100);
    rect(0, 0, width, height);
    textAlign(CENTER);
    textFont(startFont);

    //Shadow:
    fill(0);
    text("GAME OVER", width/2f, height/3f);

    //Actual Text:
    fill(222, 255, 122);
    text("GAME OVER", width/2f, height/3f + 2);
    textFont(startFont, 25);
    fill(0);
    text("Your score: " + timer.toString() + "", width/2, height*.37f + 2);
    text("Press R to try again", width/2, height *.44f + 2);
    fill(255);
    text("Your score: " + timer.toString() + "", width/2, height * .37f);
    text("Press R to try again", width/2, height * .44f);
}

void displayTime(float x, float y) {
    textFont(startFont, 25);
    fill(0);
    text(timer.toString(), x, y+2);
    fill(color(222, 255, 122));
    text(timer.toString(), x, y);
}

void reset() {
    song.rewind();
    song.play();
    player.setPosition(width/2 - player.getAABB().getWidth()/2, height/4 + player.getAABB().getHeight());
    player.setVelocity(0, 0);
    platformManager.reset();
    timer.reset();
    timer.begin();
    left = false;
    right = false;
    jump = false;
}

void gameStateChange(int gameState) {
    switch (gameState) {
    case TITLESCREEN:
        for (int i = 0; i < layeredLava.length; i++) {
            layeredLava[i].setHeight(DEFAULT_LAVAHEIGHT - i*5);
        }
        this.gameState = TITLESCREEN;
        break;
    case GAMEPLAYSCREEN:
        reset();
        for (int i = 0; i < layeredLava.length; i++) {
            layeredLava[i].setHeight(GAMEPLAY_LAVAHEIGHT - i*5);
        }
        this.gameState = GAMEPLAYSCREEN;
        break;
    case GAMEOVERSCREEN:
        timer.halt();
        lavaHeight = DEFAULT_LAVAHEIGHT;
        for (int i = 0; i < layeredLava.length; i++) {
            layeredLava[i].setHeight(GAMEPLAY_LAVAHEIGHT - i*5);
        }
        this.gameState = GAMEOVERSCREEN;
    }
}

void draw() {
    float delta = FrameTime.deltaTime();
    //    println("FPS: " + frameRate);
    switch (gameState) {
    case TITLESCREEN:
        title();
        break;
    case GAMEPLAYSCREEN:
        {
            image(bg, 0, 0, width, height); //draw background

            //Update Platforms
            platformManager.update(delta);

            //Update Player
            player.update(delta);

            if (player.isDead(GAMEPLAY_LAVAHEIGHT)) gameStateChange(GAMEOVERSCREEN);

            //Resovle Collisions
            for (Platform p : platformManager.getOnScreenPlatforms ()) {
                player.getAABB().handleCollision(p.getAABB());
                p.display();
            }
            player.display();

            image(l_wall, 0, 0);
            image(r_wall, width-r_wall.width, 0);

            drawLayeredLava();

            timer.update(); // call and draw timer
            platformManager.setDifficulty(timer.getTimePassed());
            displayTime(width * .92f, height * .95f);
        }
        break;
    case GAMEOVERSCREEN:
        gameOver();
        break;
    }
}

