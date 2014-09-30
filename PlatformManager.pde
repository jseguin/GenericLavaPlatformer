///****************************************************************************
// * Author: Jonathan Seguin, Konstantino Kapetaneas, Winnie Kwan
// * Last Modified: April 21st 2010
// * Final Project
// ****************************************************************************/
//class PlatformManager {
//
//  int numPlats;// total number of platforms on screen at any time
//  float maxDistX, minDistX;// platform distance away from adjacent platforms
//  float wallRight, wallLeft;//the positon of the right and left walls
//  boolean newLine, direction;
//  FWorld world;//physics world to add platforms to
//  Block[] plats;//array containing all platforms to be drawn on screen
//  Block startPlat;// platform to make sure player doesn't die automatically
//  Block prev;//last block to be added to the screen
//  float difficulty; //determines the movement speed of the platforms;
//
//  //constructor
//  PlatformManager (int numPlats,FWorld world) {
//    this.world = world;
//    wallRight = width-world.right.getWidth();
//    wallLeft = world.left.getWidth();
//    difficulty = 0.2;
//    startPlat = new Block (26,350,round(width/28), world);
//    minDistX = 32;
//    maxDistX = 32*3;
//    newLine = true;
//    direction = false;
//    this.numPlats = numPlats;
//    plats = new Block[this.numPlats];
//    for (int a = 0; a < this.numPlats; a++) {
//      if (plats[a] == null) {
//        plats[a] = new Block(round(random(1,4)),world); //platforms have 1-4 blocks in them
//      }
//    }
//  }
//
//
//  //method generates blocks
//  //algorithm: start a new row of bricks, if placing left to right:
//  //place platform a random distance away from the left wall, if placing
//  //right to left: place platform a random distance away from the right wall.
//  //check to see if next block placed along side the previous with a minimum
//  //of one space between them will go out of bounds of the walls. If it does
//  //start a new line. [kind of working]
//  void generate (Block current, float y) {
//    if (newLine) {
//      direction = !direction;
//      if (direction) { //lay out left to right ->
//        current.setPosition(wallLeft + round(random(0, width/4)), y);
//      } 
//      else if (!direction) { //lay out right to left <-
//        current.setPosition(wallRight-round(random(0, width/4))
//          -current.platWidth , y);
//      }
//      prev = current; //platform added referenced for next call
//      newLine = false;
//    }
//    //-------------
//    if (!newLine) {
//      if (direction) { //lay out left to right ->
//        if (prev.endX()+current.platWidth+minDistX > wallRight) {
//          newLine = true;
//          generate(current,y);
//          return;
//        }
//        current.setPosition(prev.endX()+
//          random(minDistX,(wallRight-(prev.endX()+current.platWidth))),y);
//      }
//      if (!direction) { //lay out right to left <-
//        if (prev.getX()-current.platWidth-minDistX < wallLeft) {
//          newLine = true;
//          generate(current,y);
//          return;
//        }
//        current.setPosition(prev.getX()-
//          random((prev.getX()-current.platWidth-wallLeft),minDistX),y);
//      }
//      prev = current;
//    }
//  }
//
//  //space between the end of the plaform and the right wall
//  //[plat]*<--dist-->|wr|
//  //returns distance in number of 28px spaces
//  float spaceAfter (Block target) {
//    return round((wallRight-target.endX())/target.blockWidth);
//  }
//
//  //distance between platform t1 and platform t2:
//  //[t1]*<--dist-->*[t2]
//  //returns number of 28px spaces between.
//  float spacebtween (Block t1, Block t2) {
//    return round(t2.getX() - t1.endX()/t1.blockWidth);
//  }
//
//  //space between the beginning of a platform and the left wall
//  //|wl|<--dist-->*[plat]
//  //distance in number of 28px spaces
//  float spaceBefore (Block target) {
//    return round((target.getX()-wallLeft)/target.blockWidth); 
//  }
//
//  //method increases difficulty based on the time passed
//  //since game play has started. after 200 seconds the
//  //game is on hardest difficulty
//  //Takes a time object as a parameter. 
//  void difficulty (Timer timer) {
//    difficulty = map(timer.getSeconds(), 1, 200, 0.2,2);
//  }
//
//  //method lowers all the platforms on/off screen
//  //uses difficulty to determine how fast they move
//  //down.
//  void down () {
//    for (int a = 0; a < numPlats; a++) {
//      if (plats[a] != null) {
//        plats[a].adjustPosition(0, difficulty);
////          plats[a].setPosition(plats[a].getX(),-plats[a].getY() - 0.01);
//      }
//    }
//    if (startPlat != null) {
//      startPlat.adjustPosition (0,difficulty);
//    }
//  }
//
//  //method takes any platforms that have dropped below lava and
//  //repositions them above the screen for dropping.
//  //take the lava level as a parameter.
//  void cleanUp (float lavalvl) {
//    for (int a = 0; a < numPlats; a++) {
//      // if platform is below lava
//      if (plats[a] != null && plats[a].getY() > height-lavaHeight+30) { 
//        generate(plats[a],random(-75,0)); //reset platforms to top of screen
//      } 
//      //if starting platform is below lava
//      if (startPlat != null && startPlat.getY() > height-lavaHeight+30) {
//        startPlat.remove(); //move starting platform down and remove it.
//        startPlat = null; //only needs to be removed once from the physics engine.
//      }
//    }
//  }
//}
