class Player extends MovableEntity {

    //private BoxCollider AABB;
    protected static final int LEFT = 0;
    protected static final int RIGHT = 1;
    protected static final int UP = 2;
    protected static final int DOWN = 3;
    protected int direction;

    boolean isGravityAffected = true;

    //boolean direction; //player is facing: right = true; left = false;
    float maxSpeedX, maxSpeedY;// xVelocity, yVelocity;//player velocity in x and y axes
    int jumpCounter = 0;
    SpriteSheet.Animation runLeft; //animation object for walking left
    SpriteSheet.Animation runRight; //animation object for walking right

        SpriteSheet spriteSheet;
    PImage sprite;

    Player() {
        spriteSheet = new SpriteSheet("playersheet.gif", 32, 34);
        this.sprite = spriteSheet.getFrame(0);
        runRight = spriteSheet.new Animation(6, 8, 0.15, true);
        runLeft = spriteSheet.new Animation (1, 3, 0.15, true);
        maxSpeedX = 800;
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
            if (direction == LEFT) sprite = spriteSheet.getFrame(4);
            else if (direction == RIGHT) sprite = spriteSheet.getFrame(9);
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
            sprite = (jumpCounter > 0) ? spriteSheet.getFrame(4) : runLeft.getCurrentFrame(deltaTime);
        } else {
            //If in air
            if (jumpCounter > 0) {
                velocity.x = constrain(velocity.x - acceleration.x * deltaTime, -maxSpeedX, maxSpeedX);
                sprite = spriteSheet.getFrame(4);
            } 
            //If on ground
            else {
                //must accelerate upto 15% of maxSpeed left before direction change from right
                velocity.x = constrain(velocity.x - acceleration.x * deltaTime, -maxSpeedX, maxSpeedX*0.15);
                sprite = runLeft.getCurrentFrame(deltaTime);
            }
        }
    }

    void right (float deltaTime) { 
        direction = RIGHT;

        if (AABB.getTouching()[RIGHT] || AABB.getX() == AABB.getRange()[RIGHT]) {
            velocity.x = 0;
            sprite = (jumpCounter > 0) ? spriteSheet.getFrame(9) : runRight.getCurrentFrame(deltaTime);
        } else {

            //If in air
            if (jumpCounter > 0) {
                velocity.x = constrain(velocity.x + acceleration.x * deltaTime, -maxSpeedX, maxSpeedX);
                sprite = spriteSheet.getFrame(9);
            } 
            //If on ground
            else {        
                //must accelerate upto 15% of maxSpeed right before direction change from left  
                velocity.x = constrain(velocity.x + acceleration.x * deltaTime, -maxSpeedX*0.15, maxSpeedX);
                sprite = runRight.getCurrentFrame(deltaTime);
            }
        }
    }

    void land() {
        jumpCounter = 0; //reset jumpCounter so player can jump again
    }

    boolean isFalling() {
        return velocity.y > 0 ? true : false;
    }

    boolean isGravityAffected() {
        return isGravityAffected;
    } 

    //method checks to see if character is dead
    //and changes game state to game over if true
    boolean isDead(float lavaHeight) {
        if (AABB.getY()+AABB.getHeight() > height-lavaHeight) {
            return true;
        }
        return false;
    }

    void update(float deltaTime) {
        //move left
        if (left) {
            player.left(deltaTime);
        }

        //move right
        if (right) {
            player.right(deltaTime);
        }

        //stop movement
        if (!right && !left) {
            float decelerationX = 0;
            float airAccelerationScale = jumpCounter > 0 ? 0.5 : 1;
            float frictionScale = jumpCounter > 0 ? 1 : 1;

            switch (direction) {
            case RIGHT: 
                decelerationX = -acceleration.x * frictionScale * airAccelerationScale;
                velocity.x = constrain(velocity.x + decelerationX * deltaTime, 0, maxSpeedX);
                if (jumpCounter == 0) sprite = spriteSheet.getFrame(5);
                break;
            case LEFT: 
                decelerationX = acceleration.x * frictionScale * airAccelerationScale;
                velocity.x = constrain(velocity.x + decelerationX * deltaTime, -maxSpeedX, 0);
                if (jumpCounter == 0) sprite = spriteSheet.getFrame(0);
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
    }

    void display () {
        image(sprite, AABB.getX(), AABB.getY());
        //        println(FrameTime.deltaTime());
    }
}

