static class FrameTime {
    
    private static long startTimeMillis = System.currentTimeMillis();
    private static float currentTime;
    private static float previousTime;
    private static float deltaTime;

    public static float deltaTime() {
        currentTime = (System.currentTimeMillis() - startTimeMillis) / 1000f;
        deltaTime = currentTime - previousTime;
        previousTime = currentTime;
        return deltaTime;
    }
}
