/****************************************************************************
 * Author: Jonathan Seguin, Konstantino Kapetaneas, Winnie Kwan
 * Last Modified: April 21st 2010
 * Final Project
 ****************************************************************************/
class PlatformGen {

  int numPlats;// total number of platforms on screen at any time
  float maxDistX, minDistX;// platform distance away from adjacent platforms
  float wallRight, wallLeft;//the positon of the right and left walls
  boolean newLine, direction;
  FWorld world;//physics world to add platforms to
  Block[] plats;//array containing all platforms to be drawn on screen
  Block startPlat;// platform to make sure player doesn't die automatically
  Block prev;//last block to be added to the screen
  float difficulty; //determines the movement speed of the platforms;

  //constructor
  PlatformGen (int numPlats,FWorld world) {
    this.world = world;
    wallRight = width-world.right.getWidth();
    wallLeft = world.left.getWidth();
    difficulty = 0.2;
    startPlat = new Block (26,350,round(width/28), world);
    minDistX = 32;
    maxDistX = 32*3;
    newLine = true;
    direction = false;
    this.numPlats = numPlats;
    plats = new Block[this.numPlats];
    for (int a = 0; a < this.numPlats; a++) {
      if (plats[a] == null) {
        plats[a] = new Block(round(random(1,4)),world); //platforms have 1-4 blocks in them
      }
    }
  }


  //method generates blocks
  //algorithm: start a new row of bricks, if placing left to right:
  //place platform a random distance away from the left wall, if placing
  //right to left: place platform a random distance away from the right wall.
  //check to see if next block placed along side the previous with a minimum
  //of one space between them will go out of bounds of the walls. If it does
  //start a new line. [kind of working]
  void generate (Block current, float y) {
    if (newLine) {
      direction = !direction;
      if (direction) { //lay out left to right ->
        current.setPosition(wallLeft + round(random(0, width/4)), y);
      } 
      else if (!direction) { //lay out right to left <-
        current.setPosition(wallRight-round(random(0, width/4))
          -current.platWidth , y);
      }
      prev = current; //platform added referenced for next call
      newLine = false;
    }
    //-------------
    if (!newLine) {
      if (direction) { //lay out left to right ->
        if (prev.endX()+current.platWidth+minDistX > wallRight) {
          newLine = true;
          generate(current,y);
          return;
        }
        current.setPosition(prev.endX()+
          random(minDistX,(wallRight-(prev.endX()+current.platWidth))),y);
      }
      if (!direction) { //lay out right to left <-
        if (prev.getX()-current.platWidth-minDistX < wallLeft) {
          newLine = true;
          generate(current,y);
          return;
        }
        current.setPosition(prev.getX()-
          random((prev.getX()-current.platWidth-wallLeft),minDistX),y);
      }
      prev = current;
    }
  }

  //space between the end of the plaform and the right wall
  //[plat]*<--dist-->|wr|
  //returns distance in number of 28px spaces
  float spaceAfter (Block target) {
    return round((wallRight-target.endX())/target.blockWidth);
  }

  //distance between platform t1 and platform t2:
  //[t1]*<--dist-->*[t2]
  //returns number of 28px spaces between.
  float spacebtween (Block t1, Block t2) {
    return round(t2.getX() - t1.endX()/t1.blockWidth);
  }

  //space between the beginning of a platform and the left wall
  //|wl|<--dist-->*[plat]
  //distance in number of 28px spaces
  float spaceBefore (Block target) {
    return round((target.getX()-wallLeft)/target.blockWidth); 
  }

  //method increases difficulty based on the time passed
  //since game play has started. after 200 seconds the
  //game is on hardest difficulty
  //Takes a time object as a parameter. 
  void difficulty (Time time) {
    difficulty = map(time.passedTime()/1000, 1, 200, 0.2,2);
  }

  //method lowers all the platforms on/off screen
  //uses difficulty to determine how fast they move
  //down.
  void down () {
    for (int a = 0; a < numPlats; a++) {
      if (plats[a] != null) {
        plats[a].adjustPosition(0, difficulty);
      }
    }
    if (startPlat != null) {
      startPlat.adjustPosition (0,difficulty);
    }
  }

  //method takes any platforms that have dropped below lava and
  //repositions them above the screen for dropping.
  //take the lava level as a parameter.
  void cleanUp (float lavalvl) {
    for (int a = 0; a < numPlats; a++) {
      // if platform is below lava
      if (plats[a] != null && plats[a].getY() > height-lavaLvl+30) { 
        generate(plats[a],random(-75,0)); //reset platforms to top of screen
      } 
      //if starting platform is below lava
      if (startPlat != null && startPlat.getY() > height-lavaLvl+30) {
        startPlat.remove(); //move starting platform down and remove it.
        startPlat = null; //only needs to be removed once from the physics engine.
      }
    }
  }
}

class Block {
  int numBlocks; //number of blocks in the platform
  int blockWidth, blockHeight, platWidth; //width and height of blocks, total width of blocks combined
  float posX, posY; //position of platform
  PImage block; //image used on each block
  FWorld world; //physics world
  FBox[] plat; //array of physics rectangles to represent the blocks

  //constructor sets up a platform and randomly generates
  //it's position. Parameters are the number of blocks
  //and the physics world we're working with.
  Block (int numBlocks, FWorld world) {
    this.world = world;
    this.blockWidth = 28;
    this.blockHeight = 26;
    this.numBlocks = constrain (numBlocks,1,21);
    this.platWidth = blockWidth*numBlocks;
    posX = random (28,width-platWidth+28);
    posY = random (0,height-100);
    plat = new FBox[this.numBlocks];
    block = loadImage ("data/plat_block.gif");
    makePlat();
  }

  //constructor sets up a platform and positions it based on
  //the parameters posX and posY. Also takes in the number of
  //blocks in the platform and the physics world to add to.
  Block (float posX, float posY, int numBlocks, FWorld world) {
    this.world = world;
    this.blockWidth = 28;
    this.blockHeight = 26;
    this.numBlocks = constrain (numBlocks,1,21);
    this.platWidth = blockWidth*numBlocks;
    this.posX = posX;
    this.posY = posY;
    plat = new FBox[this.numBlocks];
    block = loadImage ("data/plat_block.gif");
    makePlat();
  }

  //sets up the platform
  void makePlat () {
    for (int a = 0; a < numBlocks; a++){
      plat[a] = new FBox (blockWidth, blockHeight);
      plat[a].setRestitution(0);
      plat[a].attachImage(block);
      plat[a].setStatic(true);
      plat[a].setPosition(posX+blockWidth/2 + a*blockWidth, posY);
      plat[a].setFriction(0.5);
      this.world.add(plat[a]);
    }
  }

  //adjusts the position by adding x and y
  //values to the positions of all blocks
  //in the platform array
  void adjustPosition (float x, float y) {
    for (int a = 0; a < numBlocks; a++){
      plat[a].adjustPosition(x, y);
    }
  }

  //sets the x and y position of all blocks
  //in the platform array
  void setPosition (float x, float y) {
    for (int a = 0; a < numBlocks; a++){
      plat[a].setPosition(x+a*blockWidth, y);
    }
  }

  //gets the x position of the first block in the
  //platform. Adjusts the position due to the physics
  //engine using centred x and y positions
  //getX() -> *[  |   |  ]
  float getX() {
    return plat[0].getX()- plat[0].getWidth()/2;

  }

  //gets the x position of the last block in the
  //platform.
  //[  |  |  ]* <- endX()
  float endX() {
    return getX() + platWidth;
  }

  //gets the y position of the first bricks in the
  //platform. Adjusts the position due to the physics
  //engine using centred x and y positions
  //getX() -> *[  |   |  ]
  float getY() {
    return plat[0].getY()- plat[0].getHeight()/2;
  }

  //removes all bricks in the platform array
  //from the physics world.
  void remove() {
    for (int a = 0; a < numBlocks; a++){
      if (plat[a] != null) {
        world.remove(plat[a]);
      }
    }
  }
}







