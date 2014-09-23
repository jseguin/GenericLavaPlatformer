class Player implements Entity {
    
    private BoxCollider AABB;
    
    FBox boundingBox; //physics object that represents the player
    boolean direction; //player is facing: right = true; left = false;
    float speedX, speedY;//player velocity in x and y axes
    int jumpCounter = 0;
    Animation runLeft; //animation object for walking left
    Animation runRight; //animation object for walking right

        Player() {
        runRight = new Animation (3, "hr_sprite", "data/");
        runLeft = new Animation (3, "hl_sprite", "data/");
        speedX = 10;
        speedY = 400;

        //Physics
        boundingBox = new FBox(32, 34);
        boundingBox.setRestitution(0);
        boundingBox.setPosition(width/2, 300);
        boundingBox.setRotatable(false);
        boundingBox.attachImage(hl_sprite);
        boundingBox.setFriction(0.1);
        
        //AABB
    }

    FBox getBody() {
        return boundingBox;
    }
    
//    BoxCollider getAABB() {
//    
//    }

    //method causes player to jump
    void jump () {

        if (direction) { //if facing right
            boundingBox.attachImage(hrj_sprite); //draw right jump sprite
        } else if (!direction) { //if facing left
            boundingBox.attachImage(hlj_sprite); //draw left jump sprite
        }


        if (jumpCounter < 2) { // allow jump to be called twice only
            boundingBox.adjustVelocity(0, -speedY); //adjust vertical velocity
            jumpCounter++; //keeps track of your jumps (max 2 allowed)
        }
    }

    void left() {
        boundingBox.adjustVelocity(-speedX, 0); //decrease player's horizontal velocity
        //draw sprites
        if (frameCount % 6 == 0) { 
            if (jumpCounter != 0) { // if in the air draw jump sprites
                boundingBox.attachImage(hlj_sprite);
            } else {
                boundingBox.attachImage(runLeft.cycler()); // if on ground cycle through run animation
            }
        }
    }

    void right() {
        boundingBox.adjustVelocity(speedX, 0); //increase player's horizontal velocity

        //draw sprites 
        if (frameCount % 6 == 0) {
            if (jumpCounter != 0) { // if in the air draw jump sprites
                boundingBox.attachImage(hrj_sprite);
            } else {
                boundingBox.attachImage(runRight.cycler()); // if on ground cycle through run animation
            }
        }
    }

    void land() {

        player.jumpCounter = 0; //reset jumpCounter so player can jump again

        //reset sprites when player lands to standing sprite
        if (player.direction)
            boundingBox.attachImage(hr_sprite);
        if (!player.direction)
            boundingBox.attachImage(hl_sprite);
    }

    void update(float delta) {
    }

    void display () {
    }
}
