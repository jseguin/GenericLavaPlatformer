//Jonathan Seguin, 2014
boolean jumpInputLocked = false;
boolean left, right, jump; 

void keyPressed() {
    switch (gameState) {
    case TITLESCREEN:        
        gameState = GAMEPLAYSCREEN;
        gameStateChange(GAMEPLAYSCREEN);
        break;

    case GAMEPLAYSCREEN:
        if (key == 'a' || key == 'A' || key == CODED && keyCode == LEFT) {
            left = true;
        } else if (
        key == 'd' || key == 'D' || key == CODED && keyCode == RIGHT) {
            right = true;
        } else if (key == ' ' && !jumpInputLocked) {
            jump = true;
            jumpInputLocked = true;
        }
        break;

    case GAMEOVERSCREEN:
        if (key == 'r' || key == 'R') {
            reset();
            gameState = GAMEPLAYSCREEN;
            gameStateChange(GAMEPLAYSCREEN);
        }
        break;
    }
}

void keyReleased() {
    if (gameState == GAMEPLAYSCREEN) {
        if (key == 'a' || key == 'A' || key == CODED && keyCode == LEFT) {
            left = false;
        } else if (key == 'd' || key == 'D'|| key == CODED && keyCode == RIGHT) {
            right = false;
        } else if (key == ' ') {
            jumpInputLocked = false;
        }
    }
}

