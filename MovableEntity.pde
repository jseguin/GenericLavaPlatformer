//Jonathan Seguin, 2014
abstract class MovableEntity implements Entity {

    protected BoxCollider AABB;
    protected PVector velocity, acceleration;
    protected boolean isGravityAffected;
    protected PVector gravity;

    public MovableEntity () {
        velocity = new PVector();
        acceleration = new PVector();
        gravity = new PVector();
    }

    BoxCollider getAABB() {
        return AABB;
    }

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

    void setGravity(float x, float y) {
        gravity.set(x,y);
    }
    
    void applyGravity(float deltaTime) {
        PVector g = PVector.mult(gravity, deltaTime);
        velocity.add(g);
    }

    public abstract boolean isFalling();

    public abstract boolean isGravityAffected();

    public abstract void update(float deltaTime);

    public abstract void display();
}

