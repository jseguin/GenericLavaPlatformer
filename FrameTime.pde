class FrameTime {

    double currentTime;
    double previousTime;
    
    double deltaTime() {
        double deltaTime;
        currentTime = millis()/1000f;
        deltaTime = currentTime - previousTime;
        previousTime = currentTime;
        return deltaTime;
    }
}
