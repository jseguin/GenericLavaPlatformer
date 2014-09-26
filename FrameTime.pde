class FrameTime {

    float currentTime;
    float previousTime;
    
//    double deltaTime() {
//        double deltaTime;
//        currentTime = millis()/1000f;
//        deltaTime = currentTime - previousTime;
//        previousTime = currentTime;
//        return deltaTime;
//    }

    float deltaTime() {
        float deltaTime;
        currentTime = millis()/1000f;
        deltaTime = currentTime - previousTime;
        previousTime = currentTime;
//        println(deltaTime);
        return deltaTime;
    }
}
