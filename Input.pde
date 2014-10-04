//Jonathan Seguin, 2014
boolean jumpInputLocked = false;

void keyPressed() {
    switch (gameState) {
    case TITLESCREEN:
        gameState = GAMEPLAYSCREEN;
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
            song.close();
            setup();
            gameState = GAMEPLAYSCREEN;
            song.play(1500);
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

