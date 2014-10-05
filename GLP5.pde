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

Lava lava; //objects to draw layered lava
Lava lava2;// "
Lava lava3;// "
float lavaHeight = 200;//level of lava for game play
float titleScreen_lavaHeight = 270;// level of lava for title screen

//PlatformManager plats; //class to handle platform generation and modification

final int TITLESCREEN = 0;
final int GAMEPLAYSCREEN = 1;
final int GAMEOVERSCREEN = 2;
int gameState = TITLESCREEN; //3 game states: 0 = title screen; 1 = game play; 2 = game over;

boolean left, right, jump;//booleans switches to see if an action is to be performed

//Test Stuff, Remove!
BoxCollider floor;
BoxCollider platform;
MultiSpawn platformManager;

//Initialization - see ^Variables^ for what each variable does.
//----------------------------------------------------------------------------
void setup() {
    size(632, 620, P2D);
    //    smooth(); //uncomment for better graphics (at least tino thinks so) 
    timer = new Timer();
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
    block = loadImage("plat_block.gif");
    //-----------------------------------------

    //Player
    //-------
    player = new Player();
    //-------
    lava = new Lava(color(138, 17, 24), 0.002, lavaHeight);
    lava2 = new Lava(color(227, 56, 28), 0.003, lavaHeight-5);
    lava3 = new Lava(color(251, 102, 30), 0.004, lavaHeight-10);

    //    plats = new PlatformManager(12, world);

    //Test Stuff; Remove!
    platform = new BoxCollider(width/4, height/2, 30, 100);
    floor = new BoxCollider(0, height/2+40, width, 30  );
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

//method displays title screen
void title() {
    //  background(150);
    image(bg, 0, 0, width, height);
    lava.setHeight(titleScreen_lavaHeight);
    lava2.setHeight(titleScreen_lavaHeight-5);
    lava3.setHeight(titleScreen_lavaHeight-10);
    lava.update(FrameTime.deltaTime());
    lava2.update(FrameTime.deltaTime());
    lava3.update(FrameTime.deltaTime());
    lava.display();
    lava2.display();
    lava3.display();
    lava3.drawGradient();

    image(logo, 65, 100);
    image(copyright, 142, 585);

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

//Displays GameOver screen
void gameOver() {
    image(bg, 0, 0, width, height);
    lava.setHeight(titleScreen_lavaHeight);
    lava2.setHeight(titleScreen_lavaHeight-5);
    lava3.setHeight(titleScreen_lavaHeight-10);
    lava.update(FrameTime.deltaTime());
    lava2.update(FrameTime.deltaTime());
    lava3.update(FrameTime.deltaTime());
    lava.display();
    lava2.display();
    lava3.display();
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
    text("Your score: " + timer.toString() + "", width/2, 232);
    text("Press R to try again", width/2, 272);
    fill(255);
    text("Your score: " + timer.toString() + "", width/2, 230);
    text("Press R to try again", width/2, 270);
}

void displayTime(int x, int y) {
    textFont(startFont, 25);
    fill(0);
    text(timer.toString(), x, y+2);
    fill(color(222, 255, 122));
    text(timer.toString(), x, y);
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
            if (!timer.isTiming()) {
                timer.reset();
                timer.begin();
                lava.setHeight(lavaHeight);
                lava2.setHeight(lavaHeight-5);
                lava3.setHeight(lavaHeight-10);
            }

            image(bg, 0, 0, width, height); //draw background
            image(l_wall, 0, 0);
            image(r_wall, width-r_wall.width, 0);

            //Update Platforms
            //            spawner.update(delta);
            platformManager.update(delta);

            //Update Player
            player.update(delta);

            //Resovle Collisions
            for (Platform p : platformManager.getOnScreenPlatforms ()) {
                player.getAABB().handleCollision(p.getAABB());
                p.display();
            }

            player.getAABB().handleCollision(platform);
            player.getAABB().handleCollision(floor);

            player.display();
            platform.display();
            floor.display();

            lava.update(delta);
            lava2.update(delta);
            lava3.update(delta);
            lava.display();
            lava2.display();
            lava3.display();
            lava3.drawGradient();

            timer.update(); // call and draw timer
            platformManager.setDifficulty(timer.getTimePassed());
            displayTime(450, 600);
        }
        break;
    case GAMEOVERSCREEN:
        timer.halt();
        gameOver();
        break;
    }
}

