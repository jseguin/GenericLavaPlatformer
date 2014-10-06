//Jonathan Seguin, 2014
class Player extends MovableEntity {

    private boolean platformLocked;
    private boolean isGravityAffected = true;
    private float maxSpeedX, maxSpeedY;
    private int jumpCounter = 0;
    
    private SpriteSheet.Animation runLeft; //animation object for walking left
    private SpriteSheet.Animation runRight; //animation object for walking right
    private SpriteSheet spriteSheet;
    private PImage sprite;

    Player() {
        spriteSheet = new SpriteSheet("playersheet.gif", 32, 34);
        this.sprite = spriteSheet.getFrame(0);
        runRight = spriteSheet.new Animation(6, 8, 0.15, true);
        runLeft = spriteSheet.new Animation (1, 3, 0.15, true);
        maxSpeedX = 800;
        maxSpeedY = 550;
        acceleration = new PVector(1000, 100);
        AABB = new BoxCollider(width/2, height/2, 32, 34);
        gravity.set(0,1000);
    }

    void jump () {
        if (jumpCounter >= 0 && jumpCounter < 2) {
            velocity.y = -maxSpeedY;
            if (direction == LEFT) sprite = spriteSheet.getFrame(4);
            else if (direction == RIGHT) sprite = spriteSheet.getFrame(9);
            platformLocked = false;
        }
        jumpCounter++;
        jump=false;
    }

    void setDirection (int direction) {
        this.direction = direction;
    }

    void left(float deltaTime) { 
        direction = LEFT;
        if (AABB.getSidesTouching()[LEFT] || AABB.getX() == AABB.getRange()[LEFT]) {
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

        if (AABB.getSidesTouching()[RIGHT] || AABB.getX() == AABB.getRange()[RIGHT]) {
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
        //reset jumpCounter so player can jump again
        jumpCounter = 0; 
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
        if (AABB.getY() > height-lavaHeight) {
            return true;
        }
        return false;
    }

    void update(float deltaTime) {
        
        if (left) {
            player.left(deltaTime);
        }

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

        if (AABB.getSidesTouching()[DOWN]) {
            land();
            platformLocked = true;
            velocity.y = 0;
        } else {
            platformLocked = false;
        }

        if (jump) {
            player.jump();
        }

        if (isGravityAffected) {
            applyGravity(deltaTime);
        }
        
        //Set Position
        AABB.setPosition(AABB.getX() + velocity.x * deltaTime, AABB.getY() + velocity.y * deltaTime);
        
        //Lock Y position to platform if locked
        if(platformLocked) {
            float platformPositionY = AABB.getObjectsTouching()[DOWN].getY();
            setY(platformPositionY - AABB.getHeight());
        }
    }

    void display () {
        image(sprite, AABB.getX(), AABB.getY());
    }
}
