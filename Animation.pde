//Jonathan Seguin, 2014
class SpriteSheet {


    // Sprite Sheet
    //    PImage[] sprites;
    //    String prefix; //name of the image file
    PImage sheet;
    PImage sprite;
    int frameWidth, frameHeight;
    
    //constructor takes number of frames, filename prefix: 
    //files are to be specified prefix##.gif, and directory of file
    //    Animation (int numFrames, String prefix, String path) {
    //        sprites = new PImage[numFrames];
    //        this.numFrames = numFrames;
    //        for (int i = 0; i < numFrames; i++) {
    //            sprite[i] = loadImage(path+prefix+nf(i, 2)+".gif");
    //        }
    //    }
    
    
    SpriteSheet (String sheetPath, int frameWidth, int frameHeight) {
        this(frameWidth, frameHeight);
        this.sheet = loadImage(sheetPath);
        sprite = createImage(frameWidth, frameHeight, ARGB);
    }

    SpriteSheet (PImage sheet, int frameWidth, int frameHeight) {
        this(frameWidth, frameHeight);
        this.sheet = sheet;
        sprite = createImage(frameWidth, frameHeight, ARGB);
    }
    
    private SpriteSheet (int frameWidth, int frameHeight) { 
        this.frameWidth = frameWidth;
        this.frameHeight = frameHeight;
    }

    int getTotalNumFrames() {
        return int(sheet.width / frameWidth * sheet.height / frameHeight);
    }

    PImage getFrame(int frameNum) {

        int row = floor(frameWidth*frameNum/sheet.width);
        int frameY = row * frameHeight;
        int frameX = (frameWidth * frameNum) - (sheet.width*row);

        sprite.copy(sheet, frameX, frameY, frameWidth, frameHeight, 0, 0, frameWidth, frameHeight);

        return sprite;
    }

    class Animation {

        private float frameDelay = 0.15; //delay between frames in seconds
        private float tick;
        boolean reversing, isReversible;
        private int frame, numFrames, startFrame, endFrame;

        Animation (int startFrame, int endFrame, float frameDelay, boolean isReversible) {
            this.startFrame = frame = startFrame;
            this.endFrame = endFrame;
            this.numFrames = endFrame+1 - startFrame;
            this.isReversible = isReversible;
            this.frameDelay = frameDelay;
        }

        PImage getCurrentFrame(float deltaTime) {

            tick+= deltaTime;

            if (tick >= frameDelay) {

                if (isReversible == false) {
                    frame = frame < endFrame ? frame + 1 : startFrame;
                } else {

                    if (frame == endFrame) reversing = true;
                    else if (frame == startFrame) reversing = false;

                    frame = (!reversing) ? frame+1 : frame-1;
                }

                tick = 0;
            }

            return getFrame(frame);
        }
    }
}

