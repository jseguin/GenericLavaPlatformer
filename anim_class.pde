/****************************************************************************
 * Author: Jonathan Seguin, Konstantino Kapetaneas, Winnie Kwan
 * Last Modified: April 21st 2010
 * Final Project
 ****************************************************************************/
class Anim {
  int frame, numFrames; // current frame, total number of frames
  String prefix; //name of the image file
  PImage[] anim; //array to store frames

  //constructor takes number of frames, filename prefix: 
  //files are to be specified prefix##.gif, and directory of file
  Anim (int numFrames, String prefix, String path) {
    anim = new PImage[numFrames];
    this.numFrames = numFrames;
    frame = 0;
    for (int a = 0; a < numFrames; a++) {
      anim[a] = loadImage(path+prefix+nf(a,2)+".gif");
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
    return anim[(frame+1)%numFrames];
    } catch (Exception e) {
      println ("divded by 0: numFrames = 0: broked my program");
      return null;
    }
  } 

}





