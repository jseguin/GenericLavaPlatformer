//Jonathan Seguin, 2014
class Platform extends MovableEntity {

    private int blockWidth, blockHeight, numBlocks, platformWidth;
    private float maxSpeedY;

    PImage blockSprite;
    PGraphics platformSprite;

    Platform (int numBlocks) {
        blockSprite = loadImage ("data/plat_block.gif");
        this.blockWidth = blockSprite.width;//28;
        this.blockHeight = blockSprite.height;//26;
        this.numBlocks = numBlocks;
        this.platformWidth = blockWidth*numBlocks;
        AABB = new BoxCollider(platformWidth, blockHeight);
        createPlatformImage();
        gravity.set(0,10);
    }    

    float getHeight() {
        return AABB.getHeight();
    }

    float getWidth() {
        return AABB.getWidth();
    }
    
    void resizePlatform(int numBlocks) {
        if (this.numBlocks != numBlocks) {
            this.numBlocks = numBlocks;
            this.platformWidth = numBlocks * blockWidth;
            AABB.resize(platformWidth, blockHeight);
            createPlatformImage();
        }
    }
    
    private void createPlatformImage() {
        platformSprite = createGraphics(platformWidth, blockHeight, P2D);
        platformSprite.beginDraw();
        for (int i = 0; i < numBlocks; i++) {
            platformSprite.image(blockSprite, i * blockWidth, 0);
        } 
        platformSprite.endDraw();   
    }
    
    //gets the x position of the last block in the
    //platform.
    //[  |  |  ]* <- endX()
    float endX() {
        return getX() + platformWidth;
    }

    boolean isFalling() {
        return (velocity.y > 0) ? true : false;
    }

    boolean isGravityAffected() {
        return isGravityAffected;
    }

    void toggleGravity(boolean state) {
        isGravityAffected = state;
        if (isGravityAffected) {
            velocity = gravity;
        } else {
            velocity.set(0,0);
        }
    }

    void update(float deltaTime) {
        if (isGravityAffected) {
            AABB.setPosition(AABB.getX() + velocity.x * deltaTime, AABB.getY() + velocity.y * deltaTime);
        }
    }

    void display() {
        image(platformSprite, AABB.getX(), AABB.getY());
    }
}

