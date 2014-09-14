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
