//Jonathan Seguin, 2014
class Lava implements Entity{

    float lavaHeight = height/4;
    float stateTime;
    float noiseConst; //how wavy the lava is: under 0.01 works best for lava effect
    final float time = 0.01; // represents a second dimension of time in the noise calculation
    //  float current;//current noise calculation
    color lavaColour; // lava colour
    int strokeThickness = 1;
    float[] noiseLevels;
    boolean gradientEnabled = false;

    color[] gradientArray = {
        color(120, 42, 5), 
        color(143, 51, 8), 
        color(166, 59, 8), 
        color(184, 72, 18), 
        color(201, 83, 27), 
        color(220, 92, 31), 
        color(233, 99, 36)
    };

    //constructor sets colour and how wavy lava will be
    Lava (color lavaColour, float noiseConst, float lavaHeight) {
        this.lavaColour = lavaColour;
        this.noiseConst=noiseConst;
        noiseLevels = new float[width];
        this.lavaHeight = lavaHeight;
    }

    //Note: lava height is from the bottom of the sketch, not the top.
    void setHeight (float lavaHeight) {
        this.lavaHeight = lavaHeight;
    }

    //method draws a transparent gradient over top the lava effect
    void drawGradient () {
        for (int i = 0; i < 7; i++) {
            noStroke();
            fill(gradientArray[i]);
            rect(0, (height-30)-(15*i), width, 30);
        }
    }
    
    void toggleGradient(boolean state) {
        gradientEnabled = state;
    }

    void update(float delta) {
//        stateTime += delta;
        for (int x = 0; x < width; x++) {
            noiseLevels[x] = noise(x*noiseConst, frameCount*time/*stateTime/1.5*/) * 50;
        }
    }

    //method creates a lava effect by drawing verticles lines at
    //different heights along the x-axis. heights follow a noise
    //pattern for smooth transitions between heights.
    void display() {
        strokeWeight(strokeThickness);
        stroke(lavaColour);
        for (int x = 0; x < width; x+=strokeThickness) {
            line (x, height, x, height - lavaHeight + noiseLevels[x]);
        }
        if (gradientEnabled) {
            drawGradient();
        }
    }
}

