//Jonathan Seguin, 2014
class BoxCollider {

    private float x, y, xRangeMin, xRangeMax, yRangeMin, yRangeMax;
    private int w, h;
    private boolean rightLock, leftLock, upLock, downLock;
    private BoxCollider[] objectsTouching;

    //For Calculations; Defined at class scope to avoid repeated allocation when called in loops
    private PVector correctionVector, b1_CentrePoint, b2_CentrePoint, centrePointDifference, overlap;

    //This Object's Faces
    private final int LEFT = 0;
    private final int RIGHT = 1;
    private final int TOP = 2;
    private final int BOTTOM = 3;

    BoxCollider (int w, int h) {
        this.w = w;
        this.h = h;

        xRangeMin = 0; //Float.NEGATIVE_INFINITY;
        xRangeMax = width-w; //Float.POSITIVE_INFINITY;
        yRangeMax = height-h; //Float.POSITIVE_INFINITY;
        yRangeMin = 0; //Float.NEGATIVE_INFINITY;

        correctionVector = new PVector();
        b1_CentrePoint = new PVector();
        b2_CentrePoint = new PVector();
        centrePointDifference = new PVector();
        overlap = new PVector();

        objectsTouching = new BoxCollider[4];
    }


    BoxCollider (int x, int y, int w, int h) {
        this(w, h);
        this.x = x;
        this.y = y;
    }


    void setRange(float xMin, float xMax, float yMin, float yMax) {
        xRangeMin = xMin;
        xRangeMax = xMax - w;
        yRangeMin = yMin;
        yRangeMax = yMax - h;
    }

    //Returns the bounds inside an array [xmin, xmax, ymin, ymax]
    float[] getRange() {
        return new float[] {
            this.xRangeMin, this.xRangeMax, this.yRangeMin, this.yRangeMax
        };
    }

    float getX () {
        return x;
    }

    float getWidth() {
        return w;
    }

    float getY () {
        return y;
    }

    float getHeight() {
        return h;
    }

    PVector getPosition () {
        return new PVector(x, y);
    }


    void setX(float x) {
        float minRange = xRangeMin, maxRange = xRangeMax;

        if (rightLock) { 
            maxRange = this.x;
            rightLock = false;
        }

        if (leftLock) {
            minRange = this.x;
            leftLock = false;
        }

        this.x = constrain(x, minRange, maxRange);
    }


    void setY(float y) {
        float minRange = yRangeMin, maxRange = yRangeMax;

        if (upLock) {
            minRange = this.y;
            upLock = false;
        }

        if (downLock) {
            maxRange = this.y;
            downLock = false;
        }

        this.y = constrain(y, minRange, maxRange);
    }


    void setPosition(float x, float y) {
        setX(x);
        setY(y);
    }

    void clearLocks() {
        rightLock = leftLock = downLock = upLock = false;
    }

    boolean[] getSidesTouching() {
        boolean[] locks = {
            leftLock, rightLock, upLock, downLock
        };
        return locks;
    }

    boolean isCollidingWith (BoxCollider b2) {

        if (isColliding(this, b2)) {
            return true;
        }

        return false;
    }

    boolean isColliding (BoxCollider b1, BoxCollider b2) {

        if (b2.x - (b1.x+ b1.w) <= 0 && (b2.x + b2.w) - b1.x >=0) {
            if (b2.y - (b1.y+b1.h) <= 0 && (b2.y + b2.h) - b1.y >=0) {
                return true;
            }
        }

        return false;
    }

    void handleCollisionGroup(BoxCollider[] collisionGroup) {

//        clearLocks();

        for (BoxCollider currentBox : collisionGroup) {
            handleCollision(currentBox);
        }
    }

    boolean handleCollision(BoxCollider otherBox) {
        return handleCollision(this, otherBox);
    }

    boolean handleCollision (BoxCollider b1, BoxCollider b2) {
        boolean xTouching = false;
        boolean yTouching = false;
        boolean topTouching = false, 
        bottomTouching = false, 
        rightTouching = false, 
        leftTouching  = false;

        //Is a contact occuring?
        if (isColliding(b1, b2)) {

            //Left or Right Touching?
            if (b2.x - (b1.x + b1.w) == 0) {
                //b1 right touching b2 left
                xTouching = true;
                rightTouching = true;
            } else if ((b2.x+b2.w) - b1.x == 0) {
                //b1 left touching b2 right 
                xTouching = true;
                leftTouching = true;
            }

            //Top or Bottom Touching?
            if (b2.y - (b1.y+b1.h) == 0) {
                //b1 bottom touching b2 top
                yTouching = true;
                bottomTouching = true;
            } else if ((b2.y + b2.h) - b1.y == 0) {
                //b1 top touching b2 bottom
                yTouching = true;
                topTouching = true;
            }

            //If this object is penetrating, resolve
            if (!yTouching && !xTouching) {
                resolveCollision(b2);
            }
            //If this object is touching, lock respective direction
            else if (!(yTouching && xTouching)) {
                if (topTouching) {
                    upLock = true;
                    storeObjectTouching(TOP, b2);
                } else if (bottomTouching) {
                    downLock = true;
                    storeObjectTouching(BOTTOM, b2);
                }

                if (rightTouching) {
                    rightLock = true;
                    storeObjectTouching(RIGHT, b2);
                } else if (leftTouching) {
                    leftLock = true;
                    storeObjectTouching(LEFT, b2);
                }
            }
            return true;
        }
        return false;
    }

    BoxCollider[] getObjectsTouching() {
        return objectsTouching;
    }

    //store the current object colliding against this object's specified face
    private void storeObjectTouching (int face, BoxCollider currentTouching) {

        if (objectsTouching[face] != null) {

            BoxCollider previousTouching = objectsTouching[face];

            float previousOverlapX = abs(findOverlap(this, previousTouching).x);
            float currentOverlapX = abs(findOverlap(this, previousTouching).x);

            if (currentOverlapX >= previousOverlapX) {
                objectsTouching[face] = currentTouching;
            }
        } else {

            objectsTouching[face] = currentTouching;
        }
    }

    void resolveCollision (BoxCollider b2) {
        resolveCollision(this, b2);
    }

    void resolveCollision (BoxCollider b1, BoxCollider b2) {

        //Set CorrectionVector
        PVector.mult(findOverlap(b1, b2), -1, correctionVector);

        //Correct Positioning by moving the shortest distance
        if (abs(correctionVector.y) < abs(correctionVector.x)) {
            b1.y += correctionVector.y;

            if (correctionVector.y > 0) {
                upLock = true;
                storeObjectTouching(TOP, b2);
            } else if ( correctionVector.y < 0) {
                downLock = true;
                storeObjectTouching(BOTTOM, b2);
            }
        } else {
            b1.x += correctionVector.x;
            if (correctionVector.x > 0 ) {
                leftLock = true;
                storeObjectTouching(LEFT, b2);
            } else if (correctionVector.x < 0) {
                rightLock = true;
                storeObjectTouching(RIGHT, b2);
            }
        }
    }

    //negative overlap = overlap on right, positive overlap = overlap on left
    //b1 is x & y pixels into b2
    PVector findOverlap(BoxCollider b1, BoxCollider b2) {

        float combinedWidth = b1.w/2 + b2.w/2;
        float combinedHeight = b1.h/2 + b2.h/2;

        b1_CentrePoint.set(b1.x + b1.w/2, b1.y + b1.h/2);
        b2_CentrePoint.set(b2.x + b2.w/2, b2.y + b2.h/2);

        //Set centrePointDifference
        PVector.sub(b2_CentrePoint, b1_CentrePoint, centrePointDifference);

        overlap.x = combinedWidth - abs(centrePointDifference.x);
        overlap.y = combinedHeight - abs(centrePointDifference.y);

        if (overlap.y < 0 && overlap.x < 0) {
            //not overlapping
            overlap.set(0, 0);
        }

        //if b1 is to the right of b2
        if (centrePointDifference.x < 0 ) {
            //b1 is -n number of pixels into b2's right side
            overlap.x *= -1;
        }

        //if b1 is to the bottom of b2
        if (centrePointDifference.y < 0) {
            //b1 is -n number of pixels into b2's bottom side
            overlap.y *= -1;
        }

        return overlap;
    }

    void display() {
        fill(0, 0);
        stroke(255, 0, 0);
        rect(x, y, w, h);
    }
}

