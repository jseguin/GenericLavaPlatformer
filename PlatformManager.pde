class MultiSpawn {
    ArrayList<PlatformSpawner> spawners;
    ArrayList<Platform> platformsOnScreen;
    ArrayList<Platform> platformPool;
    float interval, stateTime, maxPlatformWidth, blockWidth, blockHeight, playerWidth;
    float difficultyLevel = 4;
    float jumpUnit = 120;
    
    MultiSpawn (int numSpawners, int xRangeMin, int xRangeMax, int playerWidth) {

        spawners = new ArrayList<PlatformSpawner>();
        platformsOnScreen = new ArrayList<Platform>();
        platformPool = new ArrayList<Platform>();
        interval = 2;

        this.playerWidth = playerWidth;

        Platform refPlatform = new Platform(1);

        blockHeight = refPlatform.getHeight();
        blockWidth = refPlatform.getWidth();
        int maxPlatformBlocks = 4;
        maxPlatformWidth = blockWidth * maxPlatformBlocks;

        int range = xRangeMax-xRangeMin;

        float extraSpace = range - (maxPlatformWidth + playerWidth) * numSpawners;
        extraSpace = extraSpace > 0 ? extraSpace : 0;
        float extraPerColumn = extraSpace / numSpawners;
        float columnWidth = maxPlatformWidth + extraPerColumn;
        //---

        for (int i = 0; i < numSpawners; i++) {
            
            addSpawner(
                xRangeMin + (columnWidth*i + playerWidth*i), 
                xRangeMin + columnWidth + (columnWidth*i + playerWidth*i), 
                interval
            );
            
//            println(
//                "Column xstart: " + (xRangeMin + (columnWidth*i + playerWidth*i)) + 
//                ", Column End: " + (xRangeMin + columnWidth + (columnWidth*i + playerWidth*i)) + 
//                ", Total Width: " + columnWidth
//            );
        }
    }

    void addSpawner(float xMin, float xMax, float interval) {
        spawners.add(new PlatformSpawner(xMin, xMax, interval));
    }

    ArrayList<Platform> getOnScreenPlatforms() {
        return platformsOnScreen;
    }

    Platform getInactivePlatform() {
        for (Platform p : platformPool) {  
            return p;
        }
        int numBlocks = round(random(2, 4));
        Platform p = new Platform(numBlocks);
        platformPool.add(p);
        println("created extra platform");
        return p;
    }

    void spawnPlatform(PlatformSpawner spawner) {
        Platform p = getInactivePlatform();

        float x = random(spawner.xMin, spawner.xMax-p.getWidth());
        float y = -p.getHeight();

        p.getAABB().setRange(0, width, -p.getHeight(), height);
        p.setPosition(x, y);
        p.toggleGravity(true);
        p.setGravity(0, 10 * difficultyLevel);
        platformPool.remove(p);
        platformsOnScreen.add(p);
        spawner.setLastSpawned(p);
    }

    void setInactive(Platform p) {
        platformsOnScreen.remove(p);
        platformPool.add(p);
        p.toggleGravity(false);
    }
    
    void setDifficulty(float timePassed) {
       difficultyLevel = map(timePassed, 0, 600, 1, 20);
    }

    void update(float deltaTime) {
        stateTime += deltaTime;

        if (stateTime >= interval) {
            for (PlatformSpawner spawner : spawners) {

                if (round(random(0, 3)) == 1) {

                    if (spawner.getLastSpawned() == null) {
                        spawnPlatform(spawner);
                    } else {
                        if (spawner.getLastSpawned().getY() > jumpUnit) { 
                            spawnPlatform(spawner);
                        }
                    }
                }
            }
            stateTime = 0;
        }

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

