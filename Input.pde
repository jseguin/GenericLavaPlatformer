boolean jumpInputLocked = false;

void keyPressed() {
    //if in game play state listen for control keys and activate control states
    if (gameState ==1) {
        if (key == 'a' || key == 'A' || key == CODED && keyCode == LEFT) {
            left = true;
            player.direction = false;
        } else if (
        key == 'd' || key == 'D' || key == CODED && keyCode == RIGHT) {
            right = true;
            player.direction = true;
        } else if (key == ' ' && !jumpInputLocked) {
            jump = true;
            jumpInputLocked = true;
        }
    }
    //if in game over game state stop song, reset game, restart song
    if (gameState == 2) {
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
    if (gameState == 0) {
        gameState=1;
    } else {
        //on release of left keys deactivate left state
        if (key == 'a' || key == 'A' || key == CODED && keyCode == LEFT) {
            left = false;
            if (player.jumpCounter != 0) {
            } else {
                //                player.getBody().attachImage(hl_sprite);
            }
        } 
        //on release of right keys deactivate right state
        else if (key == 'd' || key == 'D'|| key == CODED && keyCode == RIGHT) {
            right = false;
            if (player.jumpCounter != 0) {
            } else {
                //                player.getBody().attachImage(hr_sprite);
            }
        } 
        //on release of jump key activate jump
        else if (key == ' ') {
            jumpInputLocked = false;
        }
    }
}

