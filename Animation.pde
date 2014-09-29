/****************************************************************************
 * Author: Jonathan Seguin, Konstantino Kapetaneas, Winnie Kwan
 * Last Modified: April 21st 2010
 * Final Project
 ****************************************************************************/
class Animation {
    int frame, numFrames; // current frame, total number of frames
    String prefix; //name of the image file
    // New ---
//    PImage[] sprites;
    PImage sheet;
    PImage sprite;
    int frameWidth, frameHeight, startFrame;
    float frameDelay = 0.15; //delay between frames in seconds
    float tick;
    boolean reversing, isReversable;

    //constructor takes number of frames, filename prefix: 
    //files are to be specified prefix##.gif, and directory of file
//    Animation (int numFrames, String prefix, String path) {
//        sprites = new PImage[numFrames];
//        this.numFrames = numFrames;
//        for (int i = 0; i < numFrames; i++) {
//            sprite[i] = loadImage(path+prefix+nf(i, 2)+".gif");
//        }
//    }

    Animation (String sheetPath, int frameWidth, int frameHeight, int startFrame, int numFrames, boolean isReversable) {
        this.sheet = loadImage(sheetPath);
        sprite = createImage(frameWidth, frameHeight, ARGB);
        this.frameWidth = frameWidth;
        this.frameHeight = frameHeight;
        this.numFrames = numFrames;
        this.startFrame = startFrame;
        this.isReversable = isReversable;
    }
    
    Animation (PImage sheet, int frameWidth, int frameHeight, int startFrame, int numFrames, boolean isReversable) {
        this.sheet = sheet;
        sprite = createImage(frameWidth, frameHeight, ARGB);
        this.frameWidth = frameWidth;
        this.frameHeight = frameHeight;
        this.numFrames = numFrames;
        this.startFrame = startFrame;
        this.isReversable = isReversable;
    }

    int getMaxFrames() {
        return int(sheet.width / frameWidth * sheet.height / frameHeight);
    }

    int cycleFrame(float deltaTime) {
        tick+= deltaTime;
        
        if (tick >= frameDelay) {
            
            if (isReversable == false) {
                frame = frame < startFrame+numFrames-1 ? frame + 1 : startFrame;
            } 
            else {
                
                if (frame == startFrame+numFrames-1) reversing = true;
                else if (frame == startFrame) reversing = false;
                
                frame = (!reversing) ? frame+1 : frame-1;
            }
            
            tick = 0;
        }
//        println("Frame: " + frame);
        return frame;
    }

    PImage getFrame(int frameNum) {
        //location = x + y * width
        //x = location - y * width 
        //y = (location - x) / width

        int row = floor(frameWidth*frameNum/sheet.width);
        int frameY = row * frameHeight;
        int frameX = (frameWidth * frameNum) - (sheet.width*row);

        sprite.copy(sheet, frameX, frameY, frameWidth, frameHeight, 0, 0, frameWidth, frameHeight);

        return sprite;
    }
}

