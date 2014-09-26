class Player extends MovableEntity {

    //private BoxCollider AABB;
    boolean isGravityAffected = true;

    FBox boundingBox; //physics object that represents the player
    boolean direction; //player is facing: right = true; left = false;
    float maxSpeedX, maxSpeedY;// xVelocity, yVelocity;//player velocity in x and y axes
    int jumpCounter = 0;
    Animation runLeft; //animation object for walking left
    Animation runRight; //animation object for walking right
    Player() {
        runRight = new Animation (3, "hr_sprite", "data/");
        runLeft = new Animation (3, "hl_sprite", "data/");
        maxSpeedX = 800;//10;
        maxSpeedY = 400;
        
        acceleration = new PVector(50,100);

        //AABB
        AABB = new BoxCollider(width/2, height/2, 32, 34);
    }

    FBox getBody() {
        return boundingBox;
    }

    BoxCollider getAABB() {
        return AABB;
    }

    void jump () {
        if (jumpCounter >= 0 && jumpCounter < 2) {
            velocity.y = -maxSpeedY;
        }
        jumpCounter++;
        jump=false;
    }

    void left() { 
        velocity.x = constrain(velocity.x - acceleration.x, -maxSpeedX, maxSpeedX);
    }

    void right () { 
        velocity.x = constrain(velocity.x + acceleration.x, -maxSpeedX, maxSpeedX);
    }

    void land() {

        jumpCounter = 0; //reset jumpCounter so player can jump again

        //reset sprites when player lands to standing sprite
        if (direction) {
        }
        //            boundingBox.attachImage(hr_sprite);
        if (!direction) {
        }
        //            boundingBox.attachImage(hl_sprite);
    }

    boolean isFalling() {
        if (velocity.y > 0) {
            return true;
        }
        return false;
    }

    boolean isGravityAffected() {
        return isGravityAffected;
    } 

    void update(float deltaTime) {
        if (left) {
            player.left();
        }

        //move right
        if (right) {
            player.right();
        }

        if (!right && !left) {
//            float decelerationX = velocity.x > 0 ? -acceleration.x : acceleration.x;
//            velocity.x = constrain(velocity.x + decelerationX, -maxSpeedX, maxSpeedX);;
            velocity.x = 0;
        }
        
        //Land - order important;
        if (AABB.getTouching()[3]) {
            land();
        }

        if (jump) {
            player.jump();
        }

        if (isGravityAffected) {
            applyGravity(new PVector(0, 1000), deltaTime);
        }     
        
        AABB.setPosition(AABB.getX() + velocity.x * deltaTime, AABB.getY() + velocity.y * deltaTime);
    }

    void display () {
    }
}

