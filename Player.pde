class Player extends MovableEntity {

    //private BoxCollider AABB;
    protected static final int LEFT = 0;
    protected static final int RIGHT = 1;
    protected static final int UP = 2;
    protected static final int DOWN = 3;
    protected int direction;

    boolean isGravityAffected = true;

    FBox boundingBox; //physics object that represents the player
    //boolean direction; //player is facing: right = true; left = false;
    float maxSpeedX, maxSpeedY;// xVelocity, yVelocity;//player velocity in x and y axes
    int jumpCounter = 0;
    Animation runLeft; //animation object for walking left
    Animation runRight; //animation object for walking right
    Player() {
        runRight = new Animation (3, "hr_sprite", "data/");
        runLeft = new Animation (3, "hl_sprite", "data/");
        maxSpeedX = 800;//10;
        maxSpeedY = 550;

        acceleration = new PVector(1000, 100);

        //AABB
        AABB = new BoxCollider(width/2, height/2, 32, 34);
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

    void setDirection (int direction) {
        this.direction = direction;
    }

    void left(float deltaTime) { 
        direction = LEFT;
        if (AABB.getTouching()[LEFT] || AABB.getX() == AABB.getRange()[LEFT]) {
            velocity.x = 0;
        } else {
            //If in air
            if (jumpCounter > 0) {
                velocity.x = constrain(velocity.x - acceleration.x * deltaTime, -maxSpeedX, maxSpeedX);
            } 
            //If on ground
            else {
                //must accelerate upto 15% of maxSpeed left before direction change from right
                velocity.x = constrain(velocity.x - acceleration.x * deltaTime, -maxSpeedX, maxSpeedX*0.15);
            }
        }
    }

    void right (float deltaTime) { 
        direction = RIGHT;

        if (AABB.getTouching()[RIGHT] || AABB.getX() == AABB.getRange()[RIGHT]) {
            velocity.x = 0;
        } else {

            //If in air
            if (jumpCounter > 0) {
                velocity.x = constrain(velocity.x + acceleration.x * deltaTime, -maxSpeedX, maxSpeedX);
            } 
            //If on ground
            else {        
                //must accelerate upto 15% of maxSpeed right before direction change from left  
                velocity.x = constrain(velocity.x + acceleration.x * deltaTime, -maxSpeedX*0.15, maxSpeedX);
            }
        }
    }

    void land() {

        jumpCounter = 0; //reset jumpCounter so player can jump again

        //reset sprites when player lands to standing sprite
        //        if (direction == RIGHT) {
        //            //set standing right sprite
        //        }
        //
        //        if (direction == LEFT) {
        //            //set standing left sprite
        //        }
    }

    boolean isFalling() {
        return velocity.y > 0 ? true : false;
    }

    boolean isGravityAffected() {
        return isGravityAffected;
    } 

    void update(float deltaTime) {
        if (left) {
            player.left(deltaTime);
        }

        //move right
        if (right) {
            player.right(deltaTime);
        }


        if (!right && !left) {
            float decelerationX = 0;
            float airAccelerationScale = jumpCounter > 0 ? 0.5 : 1;
            float frictionScale = jumpCounter > 0 ? 1 : 1;

            switch (direction) {
            case RIGHT: 
                decelerationX = -acceleration.x * frictionScale * airAccelerationScale;
                velocity.x = constrain(velocity.x + decelerationX * deltaTime, 0, maxSpeedX);
                break;
            case LEFT: 
                decelerationX = acceleration.x * frictionScale * airAccelerationScale;
                velocity.x = constrain(velocity.x + decelerationX * deltaTime, -maxSpeedX, 0);
                break;
            }
        }
        
        
        
        //Land - order important;
        if (AABB.getTouching()[DOWN]) {
            land();
            velocity.y = 0;
        }

        if (jump) {
            player.jump();
        }

             if (isGravityAffected) {
            applyGravity(new PVector(0, 1000), deltaTime);
        }

        AABB.setPosition(AABB.getX() + velocity.x * deltaTime, AABB.getY() + velocity.y * deltaTime);
//        println("Velocity y: " + velocity.y);
    }

    void display () {
    }
}

