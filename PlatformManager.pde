class MultiSpawn {
    ArrayList<PlatformSpawner> spawners;
    ArrayList<Platform> platformsOnScreen;
    ArrayList<Platform> platformPool;
    float interval, stateTime, maxPlatformWidth, blockWidth, blockHeight, playerWidth;
    float difficultyLevel = 4;
    float maxDifficulty = 15;
    float jumpUnit = 120;
    Platform floor;

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

        floor = new Platform(ceil(width/blockWidth));
        floor.getAABB().setRange(0, width+floor.getWidth(), 0, height);

        startSequence();
    }

    void startSequence() {

        floor.setPosition(0, height/2.2);
        floor.toggleGravity(true);
        floor.setGravity(0, 1);
        platformsOnScreen.add(floor); 
        
        for (PlatformSpawner currentSpawner : spawners) {
            spawnPlatform(currentSpawner);
            Platform p = currentSpawner.getLastSpawned();
            p.setY(random(height/5-jumpUnit, height/5));
        }
    }

    void reset() {
        platformsOnScreen.clear();
        platformPool.clear();
        difficultyLevel = 4;
        startSequence();
    }

    void addSpawner(float xMin, float xMax, float interval) {
        spawners.add(new PlatformSpawner(xMin, xMax, interval));
    }

    ArrayList<Platform> getOnScreenPlatforms() {
        return platformsOnScreen;
    }

    Platform getInactivePlatform() {
        int minBlocks = 1;//round(map(difficultyLevel, 1, maxDifficulty, 2, 1));
        int maxBlocks = round(map(difficultyLevel, 1, maxDifficulty, 4, 2));//difficulty <= maxDifficulty/2 ? 4 : 2;
        int numBlocks = round(random(minBlocks, maxBlocks));

        for (int i = 0; i < platformPool.size (); i++) {
            Platform p = platformPool.get(i);
            if (p == floor) break;
            if (i == platformPool.size()-1) {
                p.resizePlatform(numBlocks);
                return p;
            } else {
                if (p.getWidth() == blockWidth * numBlocks) {
                    return p;
                }
            }
        }

        Platform p = new Platform(numBlocks);
        platformPool.add(p);
        return p;
    }

    void spawnPlatform(PlatformSpawner spawner) {
        Platform p = getInactivePlatform();

        float x = random(spawner.xMin, spawner.xMax-p.getWidth());
        float y = random(-jumpUnit/2, -p.getHeight());

        p.getAABB().setRange(0, width, y, height);
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
        float newDifficulty = map(timePassed, 0, 195, 1, maxDifficulty);
        if (newDifficulty != difficultyLevel) {
            difficultyLevel = newDifficulty;
            for (Platform p : platformsOnScreen) {
                p.setGravity(0, 10 * difficultyLevel);
            }
        }
    }

    void update(float deltaTime) {
        stateTime += deltaTime;
        
        if (floor.getY() > height - 235) { //lava
            platformsOnScreen.remove(floor);
        }

        if (stateTime >= interval) {
            boolean hasSpawned = false;
            for (PlatformSpawner spawner : spawners) {

                float oddsFor = map(difficultyLevel, 1, maxDifficulty, 3, 1f);
                float chance = oddsFor/spawners.size();

                if (random(0, 1) <= chance) { //Simplify

                    if (spawner.getLastSpawned() == null) {
                        spawnPlatform(spawner);
                        hasSpawned = true;
                    } else {
                        if (spawner.getLastSpawned().getY() > jumpUnit) { 
                            spawnPlatform(spawner);
                            hasSpawned = true;
                        }
                    }
                }
            }
            if (hasSpawned == false) {
                PlatformSpawner spawner = spawners.get(round(random(0, spawners.size()-1)));
                if (spawner.getLastSpawned() == null) {
                    spawnPlatform(spawner);
                } else {
                    if (spawner.getLastSpawned().getY() > jumpUnit) {
                        spawnPlatform(spawner);
                    }
                }
            }
            stateTime = 0;
        }

        for (int i = 0; i < platformsOnScreen.size (); i++) {
            Platform p = platformsOnScreen.get(i);
            p.update(deltaTime);
            if (p.getY() > height - 235) { //lava
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

