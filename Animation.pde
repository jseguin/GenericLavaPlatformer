/****************************************************************************
 * Author: Jonathan Seguin, Konstantino Kapetaneas, Winnie Kwan
 * Last Modified: April 21st 2010
 * Final Project
 ****************************************************************************/
class Animation {
  int frame, numFrames; // current frame, total number of frames
  String prefix; //name of the image file
  PImage[] animation; //array to store frames

  //constructor takes number of frames, filename prefix: 
  //files are to be specified prefix##.gif, and directory of file
  Animation (int numFrames, String prefix, String path) {
    animation = new PImage[numFrames];
    this.numFrames = numFrames;
    frame = 0;
    for (int a = 0; a < numFrames; a++) {
      animation[a] = loadImage(path+prefix+nf(a,2)+".gif");
    }
  }
  
  //method cycles through frames and returns
  //the current frame as a PImage for loading.
  PImage cycler () {
    if (frame > frameRate) {
      frame=0;
    }
    frame++;
    //had forgotten to initialize numFrames using this.numFrames
    //so I put in an exception to handle 0 frames.
    //wasn't necessary after I fixed it, but still good
    //to have.
    try {
    return animation[(frame+1)%numFrames];
    } catch (Exception e) {
      println ("divded by 0: numFrames = 0: broked my program");
      return null;
    }
  } 

}
