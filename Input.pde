boolean jumpInputLocked = false;

void keyPressed() {
    //if in game play state listen for control keys and activate control states
    if (gameState == GAMEPLAYSCREEN) {
        if (key == 'a' || key == 'A' || key == CODED && keyCode == LEFT) {
            left = true;
        } else if (
        key == 'd' || key == 'D' || key == CODED && keyCode == RIGHT) {
            right = true;
        } else if (key == ' ' && !jumpInputLocked) {
            jump = true;
            jumpInputLocked = true;
        }
    }
    //if in game over game state stop song, reset game, restart song
    if (gameState == GAMEOVERSCREEN) {
        if (key == 'r' || key == 'R') {
            song.close();
            setup();
            gameState = 1;
            song.play(1500);
        }
    }
}

void keyReleased() {
    // if in title screen state switch to gameplay and reset timer on key release
    if (gameState == TITLESCREEN) {
        gameState = GAMEPLAYSCREEN;
    } else {
        //on release of left keys deactivate left state
        if (key == 'a' || key == 'A' || key == CODED && keyCode == LEFT) {
            left = false;
        } 
        //on release of right keys deactivate right state
        else if (key == 'd' || key == 'D'|| key == CODED && keyCode == RIGHT) {
            right = false;
        } 
        //on release of jump key activate jump
        else if (key == ' ') {
            jumpInputLocked = false;
        }
    }
}

