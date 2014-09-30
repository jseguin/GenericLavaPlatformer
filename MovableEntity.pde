abstract class MovableEntity implements Entity {

    protected BoxCollider AABB;
    protected PVector velocity, acceleration;
    private boolean isGravityAffected;

    abstract boolean isFalling();
    abstract boolean isGravityAffected();

    public MovableEntity () {
        velocity = new PVector();
        acceleration = new PVector();
    }
    
//    BoxCollider getAABB() {
//     return AABB;   
//    }
    
    float getX () {
        return AABB.getX();
    }

    float getY () {
        return AABB.getY();
    }

    PVector getPosition() {
        return AABB.getPosition();
    }

    void setX (float x) {
        AABB.setX(x);
    }

    void setY (float y) {
        AABB.setY(y);
    }

    void setPosition(float x, float y) {
        AABB.setPosition(x, y);
    }

    void setVelocity(float velX, float velY) {
        velocity.set(velX, velY);
    }

    PVector getVelocity() {
        return velocity;
    }

    void applyGravity(PVector gravity, float deltaTime) {
        gravity.mult(deltaTime);
        velocity.add(gravity);
    }

    abstract void update(float deltaTime);
    abstract void display();
}

