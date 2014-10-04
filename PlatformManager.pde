class MultiSpawn {
    ArrayList<PlatformSpawner> spawners;
    ArrayList<Platform> platformsOnScreen;
    ArrayList<Platform> platformPool;
    float interval, stateTime;
    float difficultyLevel;

    MultiSpawn (int numSpawners) {

        spawners = new ArrayList<PlatformSpawner>();
        platformsOnScreen = new ArrayList<Platform>();
        platformPool = new ArrayList<Platform>();
        interval = 3;
        
        for (int i = 0; i < numSpawners; i++) {
            addSpawner(28+i*112, 28+i*112 +112, 3);
        }
    }

    void addSpawner(float xMin, float xMax, int interval) {
        spawners.add(new PlatformSpawner(xMin, xMax, interval));
    }

    ArrayList<Platform> getOnScreenPlatforms() {
        return platformsOnScreen;
    }

    Platform getInactivePlatform() {
        for (Platform p : platformPool) {
            platformPool.remove(p);    
            return p;
        }
        int numBlocks = round(random(1, 4));
        Platform p = new Platform(numBlocks);
        println("created extra platform");
        return p;
    }

    void spawnPlatform(PlatformSpawner spawner) {
        //        if (lastSpawned.getY() - p.getY() > 120) { 
        Platform p = getInactivePlatform();

        float x = random(spawner.xMin, spawner.xMax-p.getWidth());
        float y = -p.getHeight();

        p.getAABB().setRange(0, width, -p.getHeight(), height);
        p.setPosition(x, y);
        p.toggleGravity(true);
        p.setGravity(0, 10);

        platformsOnScreen.add(p);
        spawner.setLastSpawned(p);
    }

    void setInactive(Platform p) {
        platformsOnScreen.remove(p);
        platformPool.add(p);
        p.toggleGravity(false);
        p.setVelocity(0, 0);
    }

    void update(float deltaTime) {
        stateTime += deltaTime;

        if (stateTime >= interval) {
            for (PlatformSpawner spawner : spawners) {
                if (round(random(0, 3)) == 1) {
                    spawnPlatform(spawner);
                }
            }
            stateTime = 0;
        }

        //        if (lastSpawned.getY() - p.getY() > 120) {    

        for (int i = 0; i < platformsOnScreen.size (); i++) {
            Platform p = platformsOnScreen.get(i);
            p.update(deltaTime);
            if (p.getY() > height - 235) {
                setInactive(p);
            }
        }
    }

    class PlatformSpawner {

        float xMin, xMax;
        float interval, stateTime;
        Platform lastSpawned;

        PlatformSpawner (float xMin, float xMax, float interval) {
            this.xMin = xMin;
            this.xMax = xMax;
            interval = 1;
        }

        void setInterval (float i) {
            this.interval = i;
        }

        void setLastSpawned(Platform p) {
            this.lastSpawned = p;
        }

        Platform getLastSpawned() {
            return lastSpawned;
        }
    }
}

