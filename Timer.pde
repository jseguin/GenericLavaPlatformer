//Jonathan Seguin, 2014
class Timer {
    private float timePassed, timePassedPrevious, currentTime, startTime;
    private boolean isTiming = false;

    public void begin()
    {    
        if (isTiming == false) {
            reset();
            isTiming = true;
            startTime = millis()/1000f;
        }
    }

    public boolean isTiming ()
    {
        return isTiming;
    }

    public void halt()
    {
        if (isTiming) {
            isTiming = false;
            timePassedPrevious = timePassed;
        }
    }

    public void resume ()
    {
        if (!isTiming) {
            startTime = millis()/1000f;
            isTiming = true;
        }
    }

    public void reset ()
    {
        timePassed = currentTime = startTime = timePassedPrevious = 0;
    }

    public void update ()
    {
        if (isTiming) {
            currentTime = millis()/1000f;
            timePassed = (currentTime - startTime) + timePassedPrevious;
        }
    }

    public float getTimePassed()
    {
        return timePassed;
    }

    public int getMinutes () {
        return floor(timePassed/60f);
    }

    public int getSeconds ()
    {
        return floor(timePassed);
    }
  
    public String toString()
    {
        int minutes = floor (timePassed / 60);
        int seconds = floor (timePassed - (minutes * 60));
        return nf(minutes, 2) + ":"+ nf(seconds,2);
    }
}
