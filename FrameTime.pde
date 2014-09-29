class FrameTime {

    float currentTime;
    float previousTime;

    float deltaTime() {
        float deltaTime;
        currentTime = millis()/1000f;
        deltaTime = currentTime - previousTime;
        previousTime = currentTime;
        return deltaTime;
    }
}
